//
//  UserViewModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import Foundation
import Observation

enum APIResult {
    case success
    case usernameTaken
    case invalidRequest
    case serverError
}


@Observable
class UserViewModel{
    var user: User?
    var newUser: UserCreate?
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
    
    @MainActor
    func checkUsername() async -> APIResult {
        isLoading = true
        defer { isLoading = false }

        do {
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/users/checkUsername",
                queryItems: [
                    URLQueryItem(name: "username", value: newUser?.username ?? "")
                ],
                method: .get,
                body: nil,
                headers: nil
            )

            let result: ResponseModel<String?> = try await network.request(endpoint)

            switch result.success {
            case 0:
                return .success
            case 2:
                return .usernameTaken
            default:
                return .serverError
            }

        } catch {
            errorMessage = error.localizedDescription
            return .serverError
        }
    }

    
    @MainActor
    func createUser() async -> APIResult {
        isLoading = true
        defer { isLoading = false }

        do {
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/users/createUser",
                queryItems: nil,
                method: .post,
                body: newUser,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
            )

            let result: ResponseModel<String?> = try await network.request(endpoint)

            return result.success == 0 ? .success : .invalidRequest

        } catch {
            errorMessage = error.localizedDescription
            return .serverError
        }
    }

}

