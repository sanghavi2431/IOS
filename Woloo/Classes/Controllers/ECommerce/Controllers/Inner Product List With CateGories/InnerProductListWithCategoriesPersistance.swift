//
//  InnerProductListWithCategoriesPersistance.swift
//  Woloo
//
//  Created by Rahul Patra on 28/08/21.
//

import Foundation


class InnerProductListWithCategoriesPersistance {
    
    var categories: HomeCategory?
    var products: [Product]?
    var productDetailsImages: [ProductImages] = []
    
    var headerCollectionViewwrapper: GenericCollectionViewHelper = GenericCollectionViewHelper()
    
    func getProductsAccordintToCategory(withCatId: String) -> [Product] {
        products?.filter { $0.sub_cat_id ?? "-1" == withCatId} ?? []
    }
    
    //home categories product
    func getHomeCategoriesProduct(userType: String = "customer", pincode: String = "", _ completion: @escaping FinalCompletion) {
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getHomeProductListingAccordingToCategories(Int(categories?.id ?? "0") ?? 0, userType, pincode), params: [:], headers: [:], method: .get, completion: { [weak self] result in
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
}
