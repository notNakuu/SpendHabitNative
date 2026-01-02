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

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            // 1️⃣ Try real ISO8601 (with timezone)
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds
            ]

            if let date = isoFormatter.date(from: dateStr) {
                return date
            }

            // 2️⃣ Fallback: backend date WITHOUT timezone
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.locale = Locale(identifier: "en_US_POSIX")
            fallbackFormatter.timeZone = TimeZone.current
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"

            if let date = fallbackFormatter.date(from: dateStr) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unparseable date: \(dateStr)"
            )
        }
        return try decoder.decode(T.self, from: data)
    }
}
