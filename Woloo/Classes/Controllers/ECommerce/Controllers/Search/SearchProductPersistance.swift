//
//  SearchProductPersistance.swift
//  Woloo
//
//  Created by Rahul Patra on 31/08/21.
//

import Foundation


class SearchProductPersistance {
    
    var searchedProduct: [Product] = []
    var products: [Product]?
    var productDetailsImages: [ProductImages] = []
    
    func search(withtext text: String) {
        searchedProduct = products?.filter { ($0.name ?? "").lowercased().replacingOccurrences(of: " ", with: "").contains(text.lowercased().replacingOccurrences(of: " ", with: "")) } ?? []
    }
    
    func getSearchList(userType: String = "customer", pincode: String = "", _ completion: @escaping FinalCompletion) {
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getSearchList, params: [:], headers: [:], method: .get, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    if let decodedJson = try? JSONDecoder().decode([Product].self, from: data) {
                        self.products = decodedJson
                        completion(true, "Success")
                    } else if let decodedJson = try? JSONDecoder().decode([[Product]].self, from: data) {
                        self.products = decodedJson.first
                        
                        if let decodedImages = try? JSONDecoder().decode([[ProductImages]].self, from: data) {
                            self.productDetailsImages = decodedImages.flatMap { $0 }
                        }
                        
                        completion(true, "Success")
                    } else {
                        self.products = []
                        completion(true, "Success")
                    }
                    return
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
    
    
    func searchProducts(withText: String, _ completion: @escaping FinalCompletion) {
        let userId = UserDefaults.standard.value(forKey: "user_id") as? String ?? ""
        let zipCode = UserDefaults.standard.value(forKey: "zip_code") as? String ?? ""
        
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .searchProduct(userId, withText, zipCode), params: [:], headers: [:], method: .get, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    if let decodedJson = try? JSONDecoder().decode([Product].self, from: data) {
                        self.products = decodedJson
                        completion(true, "Success")
                    } else if let decodedJson = try? JSONDecoder().decode([[Product]].self, from: data) {
                        self.products = decodedJson.first
                        self.searchedProduct = decodedJson.first ?? []
                        let dataLog: [String:Any] = ["keywords": withText,
                                                  "result_count": (self.searchedProduct.count),
                                                  "pincode": zipCode
                        ]
                        
                        Global.addFirebaseEvent(eventName: "search_product_search_bar", param: dataLog)
                        
                        
                        if let decodedImages = try? JSONDecoder().decode([[ProductImages]].self, from: data) {
                            self.productDetailsImages = decodedImages.flatMap { $0 }
                        }
                        completion(true, "Success")
                    } else {
                        self.products = []
                        completion(true, "Success")
                    }
                    return
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
}
