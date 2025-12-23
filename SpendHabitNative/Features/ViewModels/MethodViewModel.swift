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
                headers: nil
            )
            
            let result: ResponseModel<[Method]> = try await network.request(endpoint)
            
            DispatchQueue.main.async { self.methods = result.data }
        }
        catch{
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message")
        }
        
    }
    
    
}
