//
//  SpendingViewModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import Foundation
import Observation

@MainActor
@Observable
class SpendingViewModel {
    var newSpending: CreateSpendingRequest?
    var spendings: [Spending] = []
    var errorMessage: String? = nil
    var isLoading: Bool = false
    var network = NetworkService()
    var responseCode : Int?
    var totalSpentByCategory: [CategorySpending] = []
    var allTimeSpendingsList: [Spending] = []
    
    var allTimeSpent: Double {
        return allTimeSpendingsList.reduce(0) { $0 + $1.amount }
    }
    
    private(set) var hasLoaded = false
    
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
            .sorted { $0.day > $1.day }
    }
    
    var monthlySpendingByMonth: [(month: String, total: Double)] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: allTimeSpendingsList) { spending in
            let components = calendar.dateComponents([.year, .month], from: spending.createdDate)
            return components
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yy" // Jan 26
        formatter.locale = Locale.current

        return grouped
            .compactMap { components, spendings in
                guard let date = calendar.date(from: components) else { return nil }

                return (
                    month: formatter.string(from: date),
                    total: spendings.reduce(0) { $0 + $1.amount }
                )
            }
            .sorted {
                guard
                    let d1 = formatter.date(from: $0.month),
                    let d2 = formatter.date(from: $1.month)
                else { return false }
                return d1 > d2
            }
    }

    
    
    func loadSpendings(for user: User) async{
        guard !hasLoaded else { return }
        hasLoaded = true
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
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )
            
            let result: ResponseModel<[Spending]> = try await network.request(endpoint)
            
            if result.success == 0{
                guard let data = result.data else { return }
                
                self.spendings = data
            }
        }
        catch{
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message")
        }
    }
    
    
    func createSpending() async {
        hasLoaded = false
        guard let newSpending = newSpending else { return }
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/spendings/createSpending",
                queryItems: nil,
                method: RequestMethod.post,
                body: newSpending,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
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
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )
            
            let result: ResponseModel<[Spending]> = try await network.request(endpoint)
            
            if result.success == 0{
                guard let data = result.data else { return }
                
                self.allTimeSpendingsList = data
            }
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
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )
            
            let result: ResponseModel<[CategorySpending]> = try await network.request(endpoint)
            
            if result.success == 0{
                guard let data = result.data else { return }
                
                self.totalSpentByCategory = data
            }
        }
        catch{
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message")
        }
    }
    
    func updateSpending(id: Int, userId: Int, title: String, categoryId: Int, methodId: Int, createdDate: Date, amount: Double) async {
        hasLoaded = false
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
    
    func deleteSpending(spending: Spending) async {
        spendings.removeAll { $0.id == spending.id }
        hasLoaded = false
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
    
    var availablePastMonths: [YearMonth] = []

    func buildAvailablePastMonths(for user: User) {
        let calendar = Calendar.current
        let now = Date()
        
        print("🚀 buildAvailablePastMonths called")
        print("Current date: \(now)")
        print("User registered date: \(user.registeredDate)")

        // Normalize date
        let registeredDate = calendar.startOfDay(for: user.registeredDate)
        print("Normalized registered date: \(registeredDate)")

        var months: [YearMonth] = []

        var year = calendar.component(.year, from: registeredDate)
        var month = calendar.component(.month, from: registeredDate)
        print("Start year: \(year), start month: \(month)")

        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)
        print("Current year: \(currentYear), current month: \(currentMonth)")

        // Include the registration month as past month
        while (year < currentYear) || (year == currentYear && month <= currentMonth - 1) {
            print("Appending month: \(month)/\(year)")
            months.append(YearMonth(year: year, month: month))

            month += 1
            if month > 12 {
                month = 1
                year += 1
                print("Rolled over to next year: \(year)")
            }
        }

        print("All months before reversing: \(months.map { $0.displayName })")
        availablePastMonths = months.reversed()
        print("Available past months after reversing: \(availablePastMonths.map { $0.displayName })")
    }


}
