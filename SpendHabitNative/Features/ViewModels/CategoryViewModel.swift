//
//  CategoryViewModel.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 8/12/25.
//

import Foundation

@Observable
class CategoryViewModel{
    var categories: [Category] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var resultCode: Int? = nil
    var network = NetworkService()
    
    func loadCategories(user: User) async {
        isLoading = true
        defer { isLoading = false}
        
        do{
            let endpoint = Endpoint(
                path: "http://localhost:8080/categories/all",
                queryItems: [URLQueryItem(name: "userId", value: "\(user.id)")],
                method: RequestMethod.get,
                body: nil,
                headers: nil
            )
            
            let result: ResponseModel<[Category]> = try await network.request(endpoint)
            
            DispatchQueue.main.async { self.categories = result.data }
        }
        catch{
            DispatchQueue.main.async { self.errorMessage = error.localizedDescription }
            print(errorMessage ?? "No error message in category vm")
        }
    }
}
