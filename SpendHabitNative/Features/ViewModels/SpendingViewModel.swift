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
    
    var totalSpentMonthlyForEachCategory: [Int: Double] {
        Dictionary(grouping:
            spendings,
            by: { (spending: Spending) in spending.categoryId }
        )
        .mapValues { (spendings: [Spending]) in
            spendings.reduce(0) { $0 + $1.amount }
        }
    }
    
    var totalMonthlySpendings: Double {
        spendings.reduce(0) { $0 + $1.amount }
    }
    
    var dailySpendingByDay: [(day: Int, total: Double)] {
        let calendar = Calendar.current
        let now = Date()

        guard
            let monthInterval = calendar.dateInterval(of: .month, for: now)
        else { return [] }

        let monthSpendings = spendings.filter({ (s: Spending) in
            s.createdDate >= monthInterval.start && s.createdDate < monthInterval.end
        })

        let grouped = Dictionary(grouping: monthSpendings, by: { (s: Spending) in
            calendar.component(.day, from: s.createdDate)
        })

        return grouped
            .map { (day: $0.key, total: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.day < $1.day }
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
            self.newSpending = nil
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
    
    func updateSpending(id: Int, userId: Int, title: String, categoryId: Int, methodId: Int, createdDate: Date, amount: Double) async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let updateSpending = UpdateSpendingRequest(
            id: id,
            title: title,
            category: IdWrapper(id: categoryId),
            method: IdWrapper(id: methodId),
            amount: amount,
            createdDate: formatter.string(from: createdDate)
        )

        print("Entered the function")
        
        isLoading = true
        defer { isLoading = false}
        
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/spendings/updateSpending",
                queryItems: nil,
                method: RequestMethod.post,
                body: updateSpending,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
            )
            
            let result: ResponseModel<String?> = try await network.request(endpoint)
            print("the code is: \(result.success)")
            
            responseCode = result.success
        }
        catch{
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message in spending vm")
        }
    }


}
