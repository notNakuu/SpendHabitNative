//
//  IncomeViewModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 11/12/25.
//

import Foundation

@Observable
class IncomeViewModel{
    var newIncome: CreateIncomeRequest?
    var incomes: [Income] = []
    var network = NetworkService()
    var isLoading: Bool = false
    var errorMessage: String?
    var responseCode: Int?
    var allTimeIncome: [Income] = []
    
    var totalAllTimeIncome: Double{
        allTimeIncome.reduce(0){ $0 + $1.amount }
    }
    
    private(set) var hasLoaded = false
    
    var totalMonthIncome: Double{
        incomes.reduce(0){ $0 + $1.amount }
    }
    
    var totalMonthIncomeForEachMethod: [Int: Double]{
        Dictionary(grouping:
            incomes,
            by: { (income: Income) in income.methodId }
        )
        .mapValues { (incomes: [Income]) in
            incomes.reduce(0) { $0 + $1.amount }
        }
    }
    
    var monthlyIncomesByMonth: [(month: String, total: Double)] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: allTimeIncome) { income in
            let components = calendar.dateComponents([.year, .month], from: income.createdDate)
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

    
    func loadIncomes(user: User) async{
        guard !hasLoaded else { return }
        hasLoaded = true
        isLoading = true
        defer { isLoading = false}
        
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/incomes/currentMonth",
                queryItems: [URLQueryItem(name: "userId", value: "\(user.id)")],
                method: RequestMethod.get,
                body: nil,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )
            
            let result: ResponseModel<[Income]> = try await network.request(endpoint)
            
            if result.success == 0{
                guard let data = result.data else { return }
                
                DispatchQueue.main.async { self.incomes = data }
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
    
    
    
    
    @MainActor
    func createIncome() async {
        hasLoaded = false
        guard let newIncome = newIncome else { return }
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/incomes/create",
                queryItems: nil,
                method: RequestMethod.post,
                body: newIncome,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
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
    
    func loadAllTimeIncomes(user: User) async{
        isLoading = true
        defer { isLoading = false}
        
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/incomes/totalAmount",
                queryItems: [URLQueryItem(name: "userId", value: "\(user.id)")],
                method: RequestMethod.get,
                body: nil,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(APIToken.token)"
                ]
            )
            
            let result: ResponseModel<[Income]> = try await network.request(endpoint)
            
            if result.success == 0{
                guard let data = result.data else { return }
                
                DispatchQueue.main.async { self.allTimeIncome = data }
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
    
    func deleteIncome(income: Income) async {
        incomes.removeAll { $0.id == income.id }
        hasLoaded = false
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/incomes/delete",
                queryItems: [URLQueryItem(name: "incomeId", value: "\(income.id)")],
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
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message in spending vm")
        }
    }
    
    func updateIncome(id: Int, userId: Int, title: String, methodId: Int, createdDate: Date, amount: Double) async {
        hasLoaded = false
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let updateIncome = UpdateIncomeRequest(
            id: id,
            title: title,
            method: IdWrapper(id: methodId),
            amount: amount,
            createdDate: formatter.string(from: createdDate)
        )

        print("Entered the function")
        
        isLoading = true
        defer { isLoading = false}
        
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/incomes/update",
                queryItems: nil,
                method: RequestMethod.post,
                body: updateIncome,
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
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message in spending vm")
        }
    }

    
    
}
