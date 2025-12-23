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
    var totalSpentByCategory: [CategorySpending] = []
    var allTimeSpent: Double = 0
    
    var totalSpentForEachCategory: [Int: Double] {
        Dictionary(grouping:
            spendings,
            by: { $0.categoryId }
        )
        .mapValues { spendings in
            spendings.reduce(0) { $0 + $1.amount }
        }
    }
    
    
    func loadSpendings(for user: User) async{
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/spendings/currentMonth",
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
                path: "\(APIConfig.baseURL)/spendings/createSpending",
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
    
    func loadTotalAmountSpent(for user: User) async{
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/spendings/totalSpent",
                queryItems: [URLQueryItem(name: "userId", value: "\(user.id)")],
                method: RequestMethod.get,
                body: nil,
                headers: nil
            )
            
            let result: ResponseModel<Double> = try await network.request(endpoint)
            
            DispatchQueue.main.async { self.allTimeSpent = result.data }
        }
        catch{
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message")
        }
    }
    
    func loadTotalForEachCategory(for user: User) async{
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/spendings/totalByCategory",
                queryItems: [URLQueryItem(name: "userId", value: "\(user.id)")],
                method: RequestMethod.get,
                body: nil,
                headers: nil
            )
            
            let result: ResponseModel<[CategorySpending]> = try await network.request(endpoint)
            
            DispatchQueue.main.async { self.totalSpentByCategory = result.data }
        }
        catch{
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message")
        }
    }

}
