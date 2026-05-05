//
//  ProductDetailspersistance.swift
//  Woloo
//
//  Created by Rahul Patra on 06/08/21.
//

import Foundation


class ProductDetailspersistance {
    
    //MARK:- Variables
    var product: Product?
    var mainProductDetails: MainProductDetail?
    var profileDetails = ProfileMoreResponse()
    var productImages: [String] = []
    var mainQtyCompletion: (() -> Void)?
    var isProductAvaiable: Int = 0
    
    //MARK:- Init
    init() { }
    
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
    
    func isUserhasPoints() -> Int {
        var products: [LocalProducts] = []
        let fetchrequest = LocalProducts.fetchRequests()
        do {
            let data = try EcommerceModelSingleton.instance?.mainContaxt.fetch(fetchrequest)
            products = data ?? []
            let coins = products.map { $0.getFinalusedCoins }.reduce(0, +)
            return (profileDetails.totalCoins?.totalCoins ?? 0) - Int(coins)
        } catch {
            return 0
        }
    }
    
    ///getting quantity of the product
    func getQuantutyOfProduct() -> Int {
        let products = LocalProducts.fetchRequests()
        do {
            let data = try EcommerceModelSingleton.instance?.mainContaxt.fetch(products)
            
            let product_ = data?.filter { "\($0.product_id)" == product?.id ?? "-1" }.first
            return Int(product_?.qty ?? 0)
        } catch {
            return 0
        }
    }
    
    //MARK:- Custom functions
    ///getting product detaisl
    func getproductDetails(_ completion: @escaping FinalCompletion) {
        let pincode = UserDefaults.standard.value(forKey: "zip_code") as? String ?? ""
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getProductDetails((product?.id ?? "0"), "customer", pincode), params: [:], headers: [:], method: .post, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let isProductAvailabe_ = Int((jsonData as? [[String:Any]])?.first?["is_pincode_available"] as? String ?? "0") ?? 0
                    self.isProductAvaiable = isProductAvailabe_
                    let decodedJson = try JSONDecoder().decode(MainProductDetails.self, from: data)
                    self.mainProductDetails = decodedJson.first
                    self.mainProductDetails?.localQty = self.getQuantutyOfProduct()
                    print(String(data: data, encoding: .utf8) ?? "")
                    completion(true, "Success")
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
    
    func getproductDetailsDashboard(prodId: String,_ completion: @escaping FinalCompletion) {
        let pincode = UserDefaults.standard.value(forKey: "zip_code") as? String ?? ""
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getProductDetails((prodId), "customer", pincode), params: [:], headers: [:], method: .post, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let isProductAvailabe_ = Int((jsonData as? [[String:Any]])?.first?["is_pincode_available"] as? String ?? "0") ?? 0
                    self.isProductAvaiable = isProductAvailabe_
                    let decodedJson = try JSONDecoder().decode(MainProductDetails.self, from: data)
                    self.mainProductDetails = decodedJson.first
                    self.mainProductDetails?.localQty = self.getQuantutyOfProduct()
                    print(String(data: data, encoding: .utf8) ?? "")
                    completion(true, "Success")
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
    
    /// Functon used to get user profile data
    func getUserData(_ completion: @escaping FinalCompletion) {
        UserModel.apiMoreProfileDetails { [weak self] (response) in
            guard let self = self else { return }
            if let result = response {
                DispatchQueue.main.async {
                    self.profileDetails = result
                    completion(true, "Success")
                }
            } else {
                completion(false, "No Data found.")
            }
        }
    }
    
    ///checking product validations
    func checkForProductValidation() {
        if Int(mainProductDetails?.stock ?? "0") ?? 0 == 0{
            print("Out Of Stock")
            return
        }
    }
    
    func addProductToLocal(isPointsused: Bool = false) {
        
        var products: [LocalProducts] = []
        let fetchrequest = LocalProducts.fetchRequests()
        
        do {
            let data = try EcommerceModelSingleton.instance?.mainContaxt.fetch(fetchrequest)
            products = data ?? []
        } catch {
            print(error.localizedDescription)
        }
        
        if let index = products.firstIndex(where: {$0.product_id == Int32(mainProductDetails?.id ?? "0") ?? 0}) {
            let innerProduct = products[index]
            
            var price = (Double(mainProductDetails?.price ?? 0.0)).rounded() * Double(mainProductDetails?.localQty ?? 0)
            let productPrice = Double(mainProductDetails?.price ?? 0.0)
            var usedCoin = 0
            let productCoin = mainProductDetails?.getCustomerMargin ?? 0
            if isPointsused {
                var userCoins = isUserhasPoints()
                
                for _ in (0..<Int(mainProductDetails?.localQty ?? 0)) {
                    if userCoins > Int(productCoin) {
                        price -= Double(productCoin)
                        usedCoin += Int(productCoin)
                        userCoins -= usedCoin
                    } else {
                        //                        price += productPrice
                    }
                }
                
                var allPrice = ((Double(mainProductDetails?.localQty ?? 0)) * Double(productPrice))
                var allPointsPrice = ((Double(mainProductDetails?.localQty ?? 0)) * Double(productCoin))
                
                price = allPrice - allPointsPrice
                usedCoin = Int(allPointsPrice)
                //
                //                while allPointsPrice <=
                
            } else {
                price = ((Double(mainProductDetails?.localQty ?? 0)) * Double(productPrice))
            }
            
            innerProduct.price = price
            innerProduct.name = mainProductDetails?.name ?? ""
            innerProduct.desc = mainProductDetails?.desc ?? ""
            innerProduct.vendorName = mainProductDetails?.vendorName ?? ""
            innerProduct.product_id = Int32(mainProductDetails?.id ?? "0") ?? 0
            innerProduct.vendor_id = Int32(mainProductDetails?.vendorID ?? "0") ?? 0
            innerProduct.odderPrice = Double(mainProductDetails?.getCustomerMargin ?? 0)
            innerProduct.points = Double(mainProductDetails?.getCustomerMargin ?? 0)
            innerProduct.offPoints = Double(usedCoin)
            innerProduct.qty = Int32(mainProductDetails?.localQty ?? 0)
            
            if (product?.image ?? "").contains("http") {
                innerProduct.productImage = self.product?.image ?? ""
            } else {
                innerProduct.productImage = ShoppingApisEndPoint.IMAGE_URL(self.product?.image ?? "").getDescription
                
            }
            innerProduct.isPointsUsed = isPointsused
            innerProduct.stock = Int32(mainProductDetails?.stock ?? "0") ?? 0
            innerProduct.productPrice = Double(mainProductDetails?.price ?? 0.0)
            innerProduct.coupon_value = 0.0
            innerProduct.coupon_applied = false
            innerProduct.coupon_code = ""
            innerProduct.is_pincod_availabel = isProductAvaiable == 0 ? false : true
            EcommerceModelSingleton.instance?.saveContext()
            
        } else {
            let product = LocalProducts(context: EcommerceModelSingleton.instance!.mainContaxt)
            
            var price = (Double(mainProductDetails?.price ?? 0.0) ?? 0.0).rounded() * Double(mainProductDetails?.localQty ?? 0)
            let productPrice = Double(mainProductDetails?.price ?? 0.0) ?? 0.0
            var usedCoin = 0
            if isPointsused {
                var userCoins = isUserhasPoints()//profileDetails.totalCoins?.totalCoins ?? 0
                let productCoin = mainProductDetails?.getCustomerMargin ?? 0
                
                for _ in (0..<Int(mainProductDetails?.localQty ?? 0)) {
                    if userCoins > Int(productCoin) {
                        price -= Double(productCoin)
                        usedCoin += Int(productCoin)
                        userCoins -= usedCoin
                    } else {
                        //                        price += productPrice
                    }
                }
                
                var allPrice = ((Double(mainProductDetails?.localQty ?? 0)) * Double(productPrice))
                var allPointsPrice = ((Double(mainProductDetails?.localQty ?? 0)) * Double(productCoin))
                
                price = allPrice - allPointsPrice
                usedCoin = Int(allPointsPrice)
                
            } else {
                price = ((Double(mainProductDetails?.localQty ?? 0)) * Double(productPrice))
            }
            
            product.price = price
            product.name = mainProductDetails?.name ?? ""
            product.desc = mainProductDetails?.desc ?? ""
            product.vendorName = mainProductDetails?.vendorName ?? ""
            product.product_id = Int32(mainProductDetails?.id ?? "0") ?? 0
            product.vendor_id = Int32(mainProductDetails?.vendorID ?? "0") ?? 0
            product.odderPrice = Double(usedCoin)
            product.points = Double(mainProductDetails?.getCustomerMargin ?? 0)
            product.offPoints = Double(usedCoin)
            product.qty = Int32(mainProductDetails?.localQty ?? 0)
            
            if (self.product?.image ?? "").contains("http") {
                product.productImage = self.product?.image ?? ""
            } else {
                product.productImage = ShoppingApisEndPoint.IMAGE_URL(self.product?.image ?? "").getDescription
                
            }
            
            product.isPointsUsed = isPointsused
            product.stock = Int32(mainProductDetails?.stock ?? "0") ?? 0
            product.productPrice = Double(mainProductDetails?.price ?? 0.0)
            product.coupon_value = 0.0
            product.coupon_applied = false
            product.coupon_code = ""
            product.is_pincod_availabel = isProductAvaiable == 0 ? false : true
            EcommerceModelSingleton.instance?.saveContext()
        }
    }
}
