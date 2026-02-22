//
//  BugetViewModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 14/12/25.
//

import Foundation

@Observable
class BudgetViewModel {
    var updateBudget: UpdateBudgetRequest?
    var budgets: [Budget] = []
    var network = NetworkService()
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var resultCode: Int? = nil
    
    private(set) var hasLoaded = false
    
    var totalToSpend: Double {
        budgets.reduce(0){ $0 + $1.amount }
    }
    
    
    func getCurrentMonthBudgets(user: User) async {
        guard !hasLoaded else { return }
        hasLoaded = true
        isLoading = true
        defer {
            isLoading = false
        }
        
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/budgets/currentMonth",
                queryItems: [URLQueryItem(name: "userId", value: "\(user.id)")],
                method: RequestMethod.get,
                body: nil,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )
            
            let result: ResponseModel<[Budget]> = try await network.request(endpoint)
            
            if result.success == 0{
                guard let data = result.data else { return }
                
                DispatchQueue.main.async { self.budgets = data }
            }
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
    
    func updateBudget(budget: Budget, user: User) async {
        hasLoaded = false
        isLoading = true
        defer {
            isLoading = false
        }
        
        guard let budgetId = budget.id else { return }
        
        do{
            //print("Budget id: \(budgetId) -- UserId: \(user.id) -- CategoryId: \(budget.categoryId) -- Amount: \(budget.amount)")
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/budgets/update",
                queryItems: [URLQueryItem(name: "budgetId", value: "\(budgetId)"),
                             URLQueryItem(name: "userId", value: "\(user.id)"),
                             URLQueryItem(name: "categoryId", value: "\(budget.categoryId)"),
                             URLQueryItem(name: "amount", value: "\(budget.amount)")],
                method: RequestMethod.post,
                body: nil,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )
            
            let result: ResponseModel<String?> = try await network.request(endpoint)
            
            resultCode = result.success
            //print(resultCode ?? -1)
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
