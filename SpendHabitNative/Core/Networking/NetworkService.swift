//
//  Networkservice.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import Foundation

final class NetworkService{
    func request<T: Decodable> (_ endpoint: Endpoint) async throws -> T {
        guard var components = URLComponents(string: endpoint.path) else {
            throw APIError.invalidURL
        }
        
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let headers = endpoint.headers{
            headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key)}
        }
        
        if let body = endpoint.body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw APIError.unexpectedStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        // <-- Here: use custom decoder with date strategy
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateStr)"
            )
        }
        return try decoder.decode(T.self, from: data)
    }
}
