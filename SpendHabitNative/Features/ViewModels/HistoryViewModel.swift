//
//  PastMonthViewModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 01/05/2026.
//

import Foundation

@MainActor
@Observable
class HistoryViewModel {
    var isLoading: Bool = false
    var spendings: [Spending] = []
    var incomes: [Income] = []
    var budgets: [Budget] = []
    
    var errorMessage: String? = nil
    var responseCode: Int? = nil
    var network = NetworkService()
    
    var totalSpending: Double {
        Double(spendings.reduce(0) { $0 + $1.amount })
    }
    
    var totalIncome: Double {
        Double(incomes.reduce(0) { $0 + $1.amount })
    }
    
    var totalBudget: Double {
        Double(budgets.reduce(0) { $0 + $1.amount })
    }
    
    var totalSpentMonthlyForEachCategory: [Int: Double] {
        Dictionary(grouping:
            spendings,
            by: { (spending: Spending) in spending.categoryId }
        )
        .mapValues { (spendings: [Spending]) in
            spendings.reduce(0) { $0 + $1.amount }
        }
    }
    
    func loadHistory(user: User, year: Int, month: Int) async{
        isLoading = true
        do{
            defer { isLoading = false}
            
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/history/allData",
                queryItems: [URLQueryItem(name: "userId", value: "\(user.id)"),
                             URLQueryItem(name: "year", value: "\(year)"),
                             URLQueryItem(name: "month", value: "\(month)")],
                method: RequestMethod.get,
                body: nil,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )
            
            let result: ResponseModel<History> = try await network.request(endpoint)
            
            if result.success == 0{
                guard let data = result.data else { return }
                
                self.incomes = data.incomes
                self.budgets = data.budgets
                self.spendings = data.spendings
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
    
    func deleteHistorySpending(spending: Spending) async {
        spendings.removeAll { $0.id == spending.id }
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/spendings/deleteSpending",
                queryItems: [URLQueryItem(name: "spendingId", value: "\(spending.id)")],
                method: RequestMethod.post,
                body: nil,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )
            
            let result: ResponseModel<String?> = try await network.request(endpoint)
            print("the code is: \(result.success)")
            
            responseCode = result.success
        }
        catch{
            self.errorMessage = error.localizedDescription
            print(errorMessage ?? "No error message in spending vm")
        }
    }
    
}
