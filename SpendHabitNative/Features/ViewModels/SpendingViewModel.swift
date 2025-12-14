//
//  SpendingViewModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import Foundation
import Observation

@Observable
class SpendingViewModel {
    
    
    var newSpending: CreateSpendingRequest?
    var spendings: [Spending] = []
    var errorMessage: String? = nil
    var isLoading: Bool = false
    var network = NetworkService()
    var responseCode : Int?
    
    
    func loadSpendings(for user: User) async{
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let endpoint = Endpoint(
                path: "http://localhost:8080/spendings/currentMonth",
                queryItems: [URLQueryItem(name: "userId", value: "\(user.id)")],
                method: RequestMethod.get,
                body: nil,
                headers: nil
            )
            
            let result: ResponseModel<[Spending]> = try await network.request(endpoint)
            
            DispatchQueue.main.async { self.spendings = result.data }
        }
        catch{
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message")
        }
    }
    
    @MainActor
    func createSpending() async {
        guard let newSpending = newSpending else { return }
        do{
            let endpoint = Endpoint(
                path: "http://localhost:8080/spendings/createSpending",
                queryItems: nil,
                method: RequestMethod.post,
                body: newSpending,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
            )
            
            let result: ResponseModel<String?> = try await network.request(endpoint)
            
            self.responseCode = result.success
        }
        catch{
            if let decodingError = error as? DecodingError {
                        print("Decoding error:", decodingError)
                    } else {
                        print("Network error:", error)
                    }
                    self.errorMessage = error.localizedDescription
            
        }
    }

}
