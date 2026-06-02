//
//  MethodViewModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import Foundation


@Observable
class MethodViewModel{
    var methods: [Method] = []
    var isLoading = false
    var errorMessage: String? = nil
    var network = NetworkService()
    
    func loadMethods() async {
        isLoading = true
        defer { isLoading = false}
        
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/methods/all",
                queryItems: nil,
                method: RequestMethod.get,
                body: nil,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )
            
            let result: ResponseModel<[Method]> = try await network.request(endpoint)
            
            
            if result.success == 0 {
                guard let data = result.data else { return }
                
                let sorted = data.sorted { lhs, rhs in
                    if lhs.id == 2 { return true }   // Card first
                    if rhs.id == 2 { return false }
                    return lhs.id < rhs.id           // fallback order
                }

                DispatchQueue.main.async {
                    self.methods = sorted
                    
                }
            }
        }
        catch{
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message")
        }
    }
    
    
}
