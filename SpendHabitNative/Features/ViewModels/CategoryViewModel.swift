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
    var newCategory: CreateCategoryRequest?
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var responseCode: Int? = nil
    var network = NetworkService()
    
    func loadCategories(user: User) async {
        isLoading = true
        defer { isLoading = false}
        
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/categories/all",
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
    
    @MainActor
    func createCategory() async {
        guard let category = newCategory else { return }
        do{
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/categories/create",
                queryItems: nil,
                method: RequestMethod.post,
                body: category,
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
            )
            
            let result: ResponseModel<String?> = try await network.request(endpoint)
            
            self.responseCode = result.success
            self.newCategory = nil
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
    
    func updateCategory(id: Int, name: String, iconKey: String, colorHex: String, isEnabled: Bool) async {
        let updatedCategory: UpdateCategoryRequest = .init(name: name, iconKey: iconKey, colorHex: colorHex)
        print("Entered the function")
        
        isLoading = true
        defer { isLoading = false}
        
        do{
 
            let endpoint = Endpoint(
                path: "\(APIConfig.baseURL)/categories/update",
                queryItems: [URLQueryItem(name: "categoryId", value: "\(id)"),
                             URLQueryItem(name: "isEnabled", value: "\(isEnabled)")],
                method: RequestMethod.post,
                body: updatedCategory,
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
            print(errorMessage ?? "No error message in category vm")
        }
    }
}
