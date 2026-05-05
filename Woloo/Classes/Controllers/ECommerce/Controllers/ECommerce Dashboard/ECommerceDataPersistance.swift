//
//  ECommerceDataPersistance.swift
//  Woloo
//
//  Created by Chandan Sharda on 01/08/21.
//

import Foundation
import CoreLocation

typealias FinalCompletion = ((Bool, String) -> Void)

class ECommerceDataPersistance {
    
    //MARK:- Varialbles
    var profileDetails = ProfileMoreResponse()
    let headerCollectionView = EcommerceCategoriesView.loadNib()
    
    var homeCategories: HomeCategories?
    var homeBanners: HomeBanners?
    
    var pinCode: String = ""
    
    //dispatch group for controlling and syncing apis in a serial way
    private var dispatchgroup = DispatchGroup()
    
    //MARK:- Initializers
    init() { DELEGATE.locationManager.startUpdatingLocation() }

    //MARK:- Custom Funcations
    /// Functon used to get user profile data
    func getUserData(_ completion: @escaping FinalCompletion) {
        UserModel.apiMoreProfileDetails { [weak self] (response) in
            guard let self = self else { return }
            if let result = response {
                DispatchQueue.main.async {
                    self.profileDetails = result
                    UserDefaults.standard.setValue(result.userData?.userId ?? 0, forKey: "user_id")
                    UserDefaults.standard.setValue(result.userData?.mobile ?? "", forKey: "user_mobile")
                    UserDefaults.standard.setValue(result.userData?.name ?? "", forKey: "username_")
                    completion(true, "Success")
                }
            } else {
                completion(false, "No Data found.")
            }
        }
    }
    
    ///getting all count of the products
    func getCartQuantityCount() -> Int {
        let products = LocalProducts.fetchRequests()
        do {
            let data = try EcommerceModelSingleton.instance?.mainContaxt.fetch(products)
            return data?.count ?? 0
        } catch {
            return 0
        }
    }
   
    
    /// Function used to get current pincode
    func getCurrentLocation(completion: @escaping ((Bool, String, String) -> Void)) {
        
        if pinCode != ""  {
            completion(true, "success", pinCode)
            return
        }
        guard let location = DELEGATE.locationManager.location else { completion(false, "Location Not Enabled.", ""); return }
        
        location.placemark(completion: { placeMark, error in
            if let err = error {
                print("Error", err.localizedDescription)
                completion(false, err.localizedDescription, "")
                return
            }
            
            completion(true, "Success", "\(placeMark?.postalCode ?? "")")
        })
    }
    
    func getProductsCategories(_ completion: @escaping FinalCompletion) {
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .homeProductCategoriesApi, params: [:], headers: [:], method: .get, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let json = try (JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[[String:Any]]])
                    
                    var productCategories: ProductCategories?
                    var categoriesImagesData: ProductCategoriesImages?
                    var products: [Product]?
                    
                    if json?.indices.contains(3) ?? false {
                        let categoriesNameData = try JSONSerialization.data(withJSONObject: json?[3], options: .prettyPrinted)
                        let productCategoriesData = try JSONDecoder().decode(ProductCategories.self, from: categoriesNameData)
                        productCategories = productCategoriesData
                    }
                    if json?.indices.contains(2) ?? false {
                        let productCategoriesImagesData = try JSONSerialization.data(withJSONObject: json?[2], options: .prettyPrinted)
                        let productCategoriesImages = try JSONDecoder().decode(ProductCategoriesImages.self, from: productCategoriesImagesData)
                        categoriesImagesData = productCategoriesImages
                    }
                    
                    if json?.indices.contains(1) ?? false {
                        let productCategoriesImagesData = try JSONSerialization.data(withJSONObject: json?[1], options: .prettyPrinted)
                        let productsData = try JSONDecoder().decode([Product].self, from: productCategoriesImagesData)
                        products = productsData
                    }
                    
                    for cat in self.homeCategories ?? [] {
                        for innercat in productCategories ?? [] {
                            if innercat.categoryID ?? "" == cat.id ?? "-2" {
                                cat.productCategories.append(innercat)
                            }
                         }
                    }
                    completion(true, "Success")
                    
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
    
    ///Get Categories
    func getCategories(_ completion: @escaping FinalCompletion) {
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getHomeCategories, params: [:], headers: [:], method: .get, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let decodedJson = try JSONDecoder().decode(HomeCategories.self, from: data)
                    self.homeCategories = decodedJson
                    self.headerCollectionView?.categories = decodedJson
                    
                    for carId in decodedJson {
                        self.dispatchgroup.enter()
                        self.getHomeCategoriesProduct(catId: Int(carId.id ?? "0") ?? 0) { products, images in
                            self.dispatchgroup.leave()
                            carId.products = products
                            carId.images = images
                        }
                    }
                    
                    self.dispatchgroup.notify(queue: .main) {
                        completion(true, "Success")
                        return
                    }
                    
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
    
    ///Get Home Banners
    func getHomeBanners(_ completion: @escaping FinalCompletion) {
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getHomeBanners, params: [:], headers: [:], method: .get, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let decodedJson = try JSONDecoder().decode(HomeBanners.self, from: data)
                    self.homeBanners = decodedJson
                    completion(true, "Success")
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
    
    //home categories product
    func getHomeCategoriesProduct(catId: Int, userType: String = "customer", pincode: String = "", _ completion: @escaping ([Product], [ProductImages]) -> Void) {
        print("HITTING WITH \(catId)")
        
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getHomeProductListingAccordingToCategories(catId, userType, pinCode), params: [:], headers: [:], method: .get, completion: { [weak self] result in
            guard let self = self else { completion([], []); return }
            switch result {
            case .success(let data):
                do {
                    if let decodedJson = try? JSONDecoder().decode([Product].self, from: data) {
                        completion(decodedJson, [])
                    } else if let decodedJson = try? JSONDecoder().decode([[Product]].self, from: data) {
                        let decodedImages = try? JSONDecoder().decode([[ProductImages]].self, from: data)
                        let finalImages = decodedImages.flatMap { $0 } ?? []
                        completion((decodedJson.first ?? []), finalImages.flatMap { $0 })
                    } else {
                        completion([], [])
                    }
                    return
                } catch {
                    completion([], [])
                }
            case .failure(let error):
                completion([], [])
            }
        }, activity: true)
    }
    
    var localProducts: [LocalProducts] = []
    func isCartAvaialbel() -> Int {
        var products: [LocalProducts] = []
        let fetchrequest = LocalProducts.fetchRequests()
        do {
            let data = try EcommerceModelSingleton.instance?.mainContaxt.fetch(fetchrequest)
            products = data ?? []
            localProducts = products
            return products.count
        } catch {
            return 0
        }
    }
}
