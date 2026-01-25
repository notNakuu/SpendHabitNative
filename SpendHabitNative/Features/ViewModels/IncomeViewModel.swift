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
    var allTimeIncome: Double = 0
    
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
                headers: nil
            )
            
            let result: ResponseModel<[Income]> = try await network.request(endpoint)
            
            DispatchQueue.main.async { self.incomes = result.data }
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
    
    func loadAllTimeIncomes(user: User) async{
        isLoading = true
        defer { isLoading = false}
        
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/incomes/totalAmount",
                queryItems: [URLQueryItem(name: "userId", value: "\(user.id)")],
                method: RequestMethod.get,
                body: nil,
                headers: nil
            )
            
            let result: ResponseModel<Double> = try await network.request(endpoint)
            
            DispatchQueue.main.async { self.allTimeIncome = result.data }
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
