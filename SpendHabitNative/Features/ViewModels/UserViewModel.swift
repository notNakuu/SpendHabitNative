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
    case invalidInput
    case invalidRequest
    case serverError
}

@MainActor
@Observable
class UserViewModel{
    var user: User?
    var newUser: UserCreate?
    var loginUser: UserLogin?
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
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )
            
            let result: ResponseModel<User> = try await network.request(endpoint)
            
            DispatchQueue.main.async { self.user = result.data }
            
        }
        catch{
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message")
        }
    }
    
    func login() async -> APIResult {
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/users/login",
                queryItems: nil,
                method: RequestMethod.post,
                body: loginUser,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                ]
            )
            
            let result: ResponseModel<LoginResponse> = try await network.request(endpoint)
            
            switch result.success {
            case 0:
                guard let loginData = result.data else { return .serverError }
                
                APIToken.token = loginData.token
                APIToken.expiresAt = Date().addingTimeInterval(1500) // Expires at 30 mins after token creating minus 5 min buffer -> 25 min
                
                self.user = loginData.user
                
                if let u = self.user{
                    print(u.email)
                }
                
                return .success
            case 1:
                return .invalidRequest
            case 2:
                return .invalidInput
            default:
                return .serverError
            }
            
        }
        catch{
            self.errorMessage = error.localizedDescription
            print(errorMessage ?? "No error message")
            return .serverError
        }
    }
    
    
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
                return .invalidInput
            default:
                return .serverError
            }

        } catch {
            errorMessage = error.localizedDescription
            return .serverError
        }
    }

    
    
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
    
    func sendVerificationCode(userEmail: String) async -> Int {
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/reset/generateToken",
                queryItems: nil,
                method: .post,
                body: ResetTokenRequest(userEmail: userEmail),
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
            )
            
            //print(endpoint.body)
            
            let result: ResponseModel<String?> = try await network.request(endpoint)
            self.errorMessage = result.message
            return result.success
        }
        catch {
            errorMessage = error.localizedDescription
            return 10
        }
    }
    
    func resetPassword(userEmail: String, token: String, newPassword: String) async -> Int {
        //print(" in resetPassword: \(userEmail), \(token), \(newPassword)")
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/reset/resetPasswd",
                queryItems: nil,
                method: .post,
                body: NewPasswordModel(userEmail: userEmail, token: token, newPassword: newPassword),
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
            )
            let result: ResponseModel<String?> = try await network.request(endpoint)
            self.errorMessage = result.message
            return result.success
            
        }
        catch {
            errorMessage = error.localizedDescription
            return 10
        }
        
    }
    
    func updateUserData(user: User) async -> Int {
        let updateUser = UpdateUserInfo( id: user.id, username: user.username, email: user.email, firstName: user.firstName, lastName: user.lastName)
        isLoading = true
        defer { isLoading = false }

        do {
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/users/updateUserData",
                queryItems: nil,
                method: .post,
                body: updateUser,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )

            let result: ResponseModel<String?> = try await network.request(endpoint)
            
            self.errorMessage = result.message

            return result.success

        } catch {
            errorMessage = error.localizedDescription
            return 10
        }
    }

}

