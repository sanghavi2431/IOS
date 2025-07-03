//
//  ShopHostRouterAPI.swift
//  Woloo
//
//  Created by CEPL on 13/03/25.
//

import Foundation
import Alamofire

class ShopHostRouterAPI: ShopBaseAPI {
    var baseComponent: String {
        return "store"
    }
    
    func POSTAction(action : APIRestAction, endValue1:String,endValue2:String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        self.setupPathComponents(action, strVal1: endValue1, strVal2: endValue2)
        super.POSTAction(completion: completion)
    }
    
    func POSTActionUserRegister(action : APIRestAction, endValue1:String,endValue2:String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        self.setupPathComponents(action, strVal1: endValue1, strVal2: endValue2)
        super.POSTActionUserRegister(completion: completion)
    }
    
    func PUTAction(action : APIRestAction, endValue1:String,endValue2:String, multipartFormData: @escaping (MultipartFormData) -> Void, completion: @escaping (AFDataResponse<Any>)  -> Void) {
        self.setupPathComponents(action, strVal1: endValue1, strVal2: endValue2)
        super.PUTAction(multipartFormDataBlock: multipartFormData, completion: completion)
    }
    
    func GETAction(action : APIRestAction, endValue1:String,endValue2:String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        self.setupPathComponents(action, strVal1: endValue1, strVal2: endValue2)
        super.GETAction(completion: completion)
    }
    
    func DELETEAction(action : APIRestAction, endValue1:String,endValue2:String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        self.setupPathComponents(action, strVal1: endValue1, strVal2: endValue2)
        super.DELETEAction(completion: completion)
    }
    
    func POSTAction(action : APIRestAction, endValue1:String,endValue2:String, multipartFormData: @escaping (MultipartFormData) -> Void, completion: @escaping (AFDataResponse<Any>)  -> Void) {
        self.setupPathComponents(action, strVal1: endValue1, strVal2: endValue2)
        super.upload(multipartFormDataBlock: multipartFormData, completion: completion)
    }
 
    func setupPathComponents(_ action: APIRestAction, strVal1:String, strVal2: String) {
        var subPath: NSArray?

        if action == .getProducList{
            subPath = ["\(baseComponent)/products"]
        }
        
        if action == .getProductCategories{
            subPath = ["\(baseComponent)/product-categories"]
        }
        
        if action == .getProductCategories{
            subPath = ["\(baseComponent)/product-categories"]
        }
        
        
        if action == .customerCreation{
            subPath = ["\(baseComponent)/customers"]
        }
        
        if action == .customerMe{
            subPath = ["\(baseComponent)/customers/me"]
        }
        
        if action == .addAddress{
            subPath = ["\(baseComponent)/customers/me/addresses"]
        }
        
        if action == .editAddress{
            subPath = ["\(baseComponent)/customers/me/addresses/\(strVal1)"]
        }
        
        if action == .carts{
            subPath = ["\(baseComponent)/carts"]
        }
        
        if action == .getCartListings{
            subPath = ["\(baseComponent)/carts/\(strVal1)"]
        }
        
        if action == .addItemsToCart{
            subPath = ["\(baseComponent)/carts/\(strVal1)/line-items"]
        }
        
        if action == .removeItemsFromCart{
            subPath = ["\(baseComponent)/carts/\(strVal1)/line-items/\(strVal2)"]
        }
        
        if action == .addReviewProduct{
            subPath = ["\(baseComponent)/reviews"]
        }
        
        if action == .getProductReviews{
            subPath = ["\(baseComponent)/products/\(strVal1)/reviews?\(strVal2)=1"]
        }
        
        if action == .setShippingAndBillingSameAddress{
            subPath = ["\(baseComponent)/carts/\(strVal1)"]
        }
        
        if action == .getShippingOptions{
            subPath = ["\(baseComponent)/shipping-options/address"]
        }
        
        if action == .selectShippingMethods{
            subPath = ["\(baseComponent)/carts/\(strVal1)/add-shipping-methods"]
        }
        
        if action == .getPaymentProviders{
            subPath = ["\(baseComponent)/payment-providers"]
        }
        
        
        if action == .paymentCollections{
            subPath = ["\(baseComponent)/payment-collections"]
        }
        
        
        if action == .paymentSessions{
            subPath = ["\(baseComponent)/payment-collections/\(strVal1)/payment-sessions"]
        }
        
        if action == .completeCart{
            subPath = ["\(baseComponent)/carts/\(strVal1)/split-and-complete-cart"]
        }
        
        if action == .orders{
            subPath = ["\(baseComponent)/order-sets"]
        }
        
       
        if action == .calculateShippingOptions{
            subPath = ["\(baseComponent)/shipping-options/\(strVal1)/calculate"]
        }
        
        if action == .createCustomerWishlist{
            subPath = ["\(baseComponent)/customers/me/wishlists"]
        }
      
        
        if action == .addWishListItems{
            subPath = ["\(baseComponent)/customers/me/wishlists/items"]
        }
        
        if action == .deleteItemFromWishList{
            subPath = ["\(baseComponent)/customers/me/wishlists/items/\(strVal1)"]
        }
        
        if action == .getWishList{
            subPath = ["\(baseComponent)/customers/me/wishlists"]
        }
        
        if action == .getBrandList{
            subPath = ["\(baseComponent)/collections"]
        }
       
        if action == .delete_payment{
            subPath = ["\(baseComponent)/payment/delete-payment"]
        }
        
        if action == .promotions{
            subPath = ["\(baseComponent)/carts/\(strVal1)/promotions"]
        }
        
        //complete_vendor
        if action == .complete_vendor{
            subPath = ["\(baseComponent)/carts/\(strVal1)/complete-vendor"]
        }
        
        if action == .getStoreProductDetails{
            subPath = ["\(baseComponent)/products/\(strVal1)"]
        }
        
        if (subPath?.count)! > 0 {
            pathComponents.addObjects(from: subPath as! [Any])
        }
    }
}
