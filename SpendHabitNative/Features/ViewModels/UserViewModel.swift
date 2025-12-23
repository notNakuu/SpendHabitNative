//
//  UserViewModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import Foundation
import Observation

@Observable
class UserViewModel{
    var user: User?
    var isLoading = false
    var errorMessage: String? = nil
    
    var network = NetworkService()
    
    func loadTestUser() async {
        isLoading = true
        defer { isLoading = false}
        
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/users/testUser",
                queryItems: nil,
                method: RequestMethod.get,
                body: nil,
                headers: nil
            )
            
            let result: ResponseModel<User> = try await network.request(endpoint)
            
            DispatchQueue.main.async { self.user = result.data }
            
        }
        catch{
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message")
        }
    }
}

