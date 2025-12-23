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
    
    var totalIncome: Double{
        incomes.reduce(0){ $0 + $1.amount }
    }
    
    func loadIncomes(user: User) async{
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
    
    
}
