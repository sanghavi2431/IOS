//
//  ShopHostAPI.swift
//  Woloo
//
//  Created by CEPL on 13/03/25.
//

import Foundation
import Alamofire

class ShopHostAPI: NSObject{
    
    
    func getCustomerInfo(success: @escaping (_ objCommonWrapper: CustomerCreationWrapper)->Void,
                         failure: @escaping (Error?)-> Void){
        
        
        let parameters = NSMutableDictionary()
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .customerMe, endValue1: "", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : CustomerCreationWrapper? = CustomerCreationWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    func getProductList(success: @escaping (_ objCommonWrapper: ProductListWrapper)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue("*variants.calculated_price, variants.inventory_quantity", forKey: "fields")
        parameters.setValue("reg_01JPH693TAM20TXZEJNBJ5QBV4", forKey: "region_id")
        
       
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getProducList, endValue1: "", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : ProductListWrapper? = ProductListWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    
    func getBrandList(success: @escaping (_ objCommonWrapper: ProductCollectionsWrapper)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue("id,title,metadata", forKey: "fields")
        
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getBrandList, endValue1: "", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : ProductCollectionsWrapper? = ProductCollectionsWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    
    
    func getProductCategories(success: @escaping (_ objCommonWrapper: ProductcategoryWrapper)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getProductCategories, endValue1: "", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : ProductcategoryWrapper? = ProductcategoryWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    
    func getSearchedProductList(strSearch: String?,success: @escaping (_ objCommonWrapper: ProductListWrapper)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue("*variants.calculated_price", forKey: "fields")
        parameters.setValue("reg_01JPH693TAM20TXZEJNBJ5QBV4", forKey: "region_id")
        parameters.setValue(strSearch ?? "", forKey: "q")
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getProducList, endValue1: "", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : ProductListWrapper? = ProductListWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    func customerCreationAPI(strMail: String?, strPhone: String?, success: @escaping (_ objCommonWrapper: CustomerCreationWrapper)->Void,
                         failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(strMail ?? "", forKey: "email")
        parameters.setValue(strPhone ?? "", forKey: "phone")
        
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTActionUserRegister(action: .customerCreation, endValue1: "", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CustomerCreationWrapper? = CustomerCreationWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func addAddress(objAddress: StoreAddress?, success: @escaping (_ objCommonWrapper: CustomerCreationWrapper)->Void,
                    failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(objAddress?.first_name ?? "", forKey: "first_name")
        parameters.setValue(objAddress?.last_name ?? "", forKey: "last_name")
        parameters.setValue(objAddress?.address_1 ?? "", forKey: "address_1")
        parameters.setValue(objAddress?.company ?? "", forKey: "company")
        parameters.setValue(objAddress?.postal_code ?? "", forKey: "postal_code")
        parameters.setValue(objAddress?.city ?? "", forKey: "city")
        parameters.setValue(objAddress?.country_code ?? "", forKey: "country_code")
        parameters.setValue(objAddress?.province ?? "", forKey: "province")
        parameters.setValue(objAddress?.phone ?? "", forKey: "phone")
        parameters.setValue(objAddress?.address_name ?? "", forKey: "address_name")
        
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .addAddress, endValue1: "", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CustomerCreationWrapper? = CustomerCreationWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
   
    func editAddress(objAddress: StoreAddress?, success: @escaping (_ objCommonWrapper: CustomerCreationWrapper)->Void,
                    failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(objAddress?.first_name ?? "", forKey: "first_name")
        parameters.setValue(objAddress?.last_name ?? "", forKey: "last_name")
        parameters.setValue(objAddress?.address_1 ?? "", forKey: "address_1")
        parameters.setValue(objAddress?.company ?? "", forKey: "company")
        parameters.setValue(objAddress?.postal_code ?? "", forKey: "postal_code")
        parameters.setValue(objAddress?.city ?? "", forKey: "city")
        parameters.setValue(objAddress?.country_code ?? "", forKey: "country_code")
        parameters.setValue(objAddress?.province ?? "", forKey: "province")
        parameters.setValue(objAddress?.phone ?? "", forKey: "phone")
         
        let addId = objAddress?.id ?? ""
        let api = ShopHostRouterAPI(params: parameters)
        print("Address ID: \(addId)")
        api.POSTAction(action: .editAddress, endValue1: "\(addId)", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CustomerCreationWrapper? = CustomerCreationWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func deleteAddress(objAddress: StoreAddress?, success: @escaping (_ objCommonWrapper: DeleteAddress)->Void,
                    failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let addId = objAddress?.id ?? ""
        let api = ShopHostRouterAPI(params: parameters)
        print("Address ID: \(addId)")
        api.DELETEAction(action: .editAddress, endValue1: "\(addId)", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : DeleteAddress? = DeleteAddress.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
  
    func createCartAPI(strRegionID: String?, success: @escaping (_ objCommonWrapper: CreateCart)->Void,
                       failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(strRegionID ?? "", forKey: "region_id")
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .carts, endValue1: "", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CreateCart? = CreateCart.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    
    func getCartListings(success: @escaping (_ objCommonWrapper: CreateCart)->Void,
                         failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue("items.variant.*,items.variant.options.*, items.product.*,items.product.images.*", forKey: "fields")
        
        let api = ShopHostRouterAPI(params: parameters)
        let strCartID = UserDefaultsManager.fetchUserCartID()
        api.GETAction(action: .getCartListings, endValue1: "\(strCartID)", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CreateCart? = CreateCart.decode(data){
                            success(objParsed!)
                        }
                    }
                }
        
    }
    
    
    func addItemsTocart(strVariantID: String?, quantity: Int?,success: @escaping (_ objCommonWrapper: CreateCart)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(strVariantID ?? "", forKey: "variant_id")
        parameters.setValue(quantity ?? 0, forKey: "quantity")
        let strCartID = UserDefaultsManager.fetchUserCartID()
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .addItemsToCart, endValue1: "\(strCartID)", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CreateCart? = CreateCart.decode(data){
                            success(objParsed!)
                        }
                    }
                }
        
    }
    
    func removeItemsTocart(strItemID: String?,quantity: Int?,success: @escaping (_ objCommonWrapper: RemoveItem)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(quantity ?? 0, forKey: "quantity")
        
        let strCartID = UserDefaultsManager.fetchUserCartID()
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .removeItemsFromCart, endValue1: "\(strCartID)", endValue2: "\(strItemID ?? "")") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : RemoveItem? = RemoveItem.decode(data){
                            success(objParsed!)
                        }
                    }
                }
        
    }
    
    func deleteItemsTocart(strItemID: String?,success: @escaping (_ objCommonWrapper: RemoveItem)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
       
        let strCartID = UserDefaultsManager.fetchUserCartID()
        let api = ShopHostRouterAPI(params: parameters)
        
        api.DELETEAction(action: .removeItemsFromCart, endValue1: "\(strCartID)", endValue2: "\(strItemID ?? "")") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : RemoveItem? = RemoveItem.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    func getProductReviews(strProductId: String?,success: @escaping (_ objCommonWrapper: ProductReviewWrapper)->Void,
                      failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        
        let api = ShopHostRouterAPI(params: parameters)
        api.GETAction(action: .getProductReviews, endValue1: "\(strProductId ?? "")", endValue2: "all") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : ProductReviewWrapper? = ProductReviewWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
        
    }
    
    
    func addProductReview(strProductId: String?, rating: Int?, strComment: String?,success: @escaping (_ objCommonWrapper: ProductReviewWrapper)->Void,
                          failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(strProductId ?? "", forKey: "product_id")
        parameters.setValue(rating ?? 0, forKey: "rating")
        parameters.setValue(strComment ?? "", forKey: "comment")
        let api = ShopHostRouterAPI(params: parameters)
        
        
        api.POSTAction(action: .addReviewProduct, endValue1: "", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : ProductReviewWrapper? = ProductReviewWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func setShippingAndBillingAddress(strCartID: String?,objAddress: StoreAddress? ,success: @escaping (_ objCommonWrapper: CreateCart)->Void,
                                      failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        
        let paramShippingAdddress = NSMutableDictionary()
        
        paramShippingAdddress.setValue(UserDefaultsManager.fetchUserData()?.profile?.name ?? "", forKey: "first_name")
        paramShippingAdddress.setValue(objAddress?.last_name ?? "", forKey: "last_name")
        paramShippingAdddress.setValue(objAddress?.address_1 ?? "", forKey: "address_1")
        paramShippingAdddress.setValue(objAddress?.postal_code ?? "", forKey: "postal_code")
        paramShippingAdddress.setValue(objAddress?.city ?? "", forKey: "city")
        paramShippingAdddress.setValue("in", forKey: "country_code")
        paramShippingAdddress.setValue(UserDefaultsManager.fetchUserMob(), forKey: "phone")
        parameters.setValue(paramShippingAdddress, forKey: "shipping_address")
        
        let paramBillingAdddress = NSMutableDictionary()
        paramBillingAdddress.setValue(UserDefaultsManager.fetchUserData()?.profile?.name ?? "", forKey: "first_name")
        paramBillingAdddress.setValue(objAddress?.last_name ?? "", forKey: "last_name")
        paramBillingAdddress.setValue(objAddress?.address_1 ?? "", forKey: "address_1")
        paramBillingAdddress.setValue(objAddress?.postal_code ?? "", forKey: "postal_code")
        paramBillingAdddress.setValue(objAddress?.city ?? "", forKey: "city")
        paramBillingAdddress.setValue("in", forKey: "country_code")
        paramBillingAdddress.setValue(UserDefaultsManager.fetchUserMob(), forKey: "phone")
        parameters.setValue(paramBillingAdddress, forKey: "billing_address")
        
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .setShippingAndBillingSameAddress, endValue1: "\(strCartID ?? "")", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CreateCart? = CreateCart.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func getShippingOptions(strCartID: String?,success: @escaping (_ objCommonWrapper: ShippingOptionsWrapper)->Void,
                            failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
       
        parameters.setValue(strCartID ?? "", forKey: "cart_id")
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getShippingOptions, endValue1: "", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : ShippingOptionsWrapper? = ShippingOptionsWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func selectShippingMethods(strCartId: String?,strOptionId: String?, success: @escaping (_ objCommonWrapper: CreateCart)->Void,
                            failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        
        let arrValue = NSMutableArray()
        let parametersVal = NSMutableDictionary()
        parametersVal.setValue(strOptionId ?? "", forKey: "id")
        arrValue.add(parametersVal)
        
        parameters.setValue(arrValue, forKey: "options")
        
        let api = ShopHostRouterAPI(params: parameters)
        api.POSTAction(action: .selectShippingMethods, endValue1: "\(strCartId ?? "")", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CreateCart? = CreateCart.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    
    func getPaymentProviders(strRegionID: String?, success: @escaping (_ objCommonWrapper: PaymentProviderWrapper)->Void,
                             failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(strRegionID ?? "", forKey: "region_id")
        
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getPaymentProviders, endValue1: "", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : PaymentProviderWrapper? = PaymentProviderWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    
    func paymentCollectionsAPI(strCartId: String?, success: @escaping (_ objCommonWrapper: PaymentCollectionsWrapper)->Void,
                               failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(strCartId ?? "", forKey: "cart_id")
        
        let api = ShopHostRouterAPI(params: parameters)
        api.POSTAction(action: .paymentCollections, endValue1: "", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : PaymentCollectionsWrapper? = PaymentCollectionsWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func paymentSessionsAPI(strPayCollectionID: String?,strProviderId: String?, success: @escaping (_ objCommonWrapper: PaymentCollectionsWrapper)->Void,
                         failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(strProviderId ?? "", forKey: "provider_id")
        print("payment collection ID: \(strPayCollectionID ?? "")")
        let api = ShopHostRouterAPI(params: parameters)
        api.POSTAction(action: .paymentSessions, endValue1: "\(strPayCollectionID ?? "")", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : PaymentCollectionsWrapper? = PaymentCollectionsWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func completeCartAPI(strCartID: String?, success: @escaping (_ objCommonWrapper: CompleteCart)->Void,
                         failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .completeCart, endValue1: "\(strCartID ?? "")", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CompleteCart? = CompleteCart.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func getOrderListingsAPI(strOrderID: String? , success: @escaping (_ objCommonWrapper: OrderListingsWrapper)->Void,
                             failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .orders, endValue1: "\(strOrderID ?? "")", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : OrderListingsWrapper? = OrderListingsWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
        
    }
    
    func calculateShippingOptionsAPI(strCartID: String?,strOptionsID: String? ,success: @escaping (_ objCommonWrapper: CalculateShippingOptionWrapper)->Void,
                                     failure: @escaping (Error?)-> Void){
        
        
        let parameters = NSMutableDictionary()
        parameters.setValue(strCartID ?? "", forKey: "cart_id")
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .calculateShippingOptions, endValue1: "\(strOptionsID ?? "")", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CalculateShippingOptionWrapper? = CalculateShippingOptionWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    
    func createWishListAPI(success: @escaping (_ objCommonWrapper: WishListWrapper)->Void,
                           failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .createCustomerWishlist, endValue1: "", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : WishListWrapper? = WishListWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    
    func addWishListItemAPI(strVariant_id: String?, success: @escaping (_ objCommonWrapper: WishListWrapper)->Void,
                           failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(strVariant_id ?? "", forKey: "variant_id")
        
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .addWishListItems, endValue1: "", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : WishListWrapper? = WishListWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    
    func deleteItemFromWishListAPI(strVariant_id: String?, success: @escaping (_ objCommonWrapper: WishListWrapper)->Void,
                                   failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let api = ShopHostRouterAPI(params: parameters)
        
        api.DELETEAction(action: .deleteItemFromWishList, endValue1: "\(strVariant_id ?? "")", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : WishListWrapper? = WishListWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func getWishListAPI(success: @escaping (_ objCommonWrapper: WishListWrapper)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getWishList, endValue1: "", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : WishListWrapper? = WishListWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    
    func deletePaymentSession(strPaymentID: String?, success: @escaping (_ objCommonWrapper: DeletePaymentSessionWrapper)->Void,
                              failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue([strPaymentID ?? ""], forKey: "ids")
        
        
        let api = ShopHostRouterAPI(params: parameters)
        
        api.DELETEAction(action: .delete_payment, endValue1: "", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : DeletePaymentSessionWrapper? = DeletePaymentSessionWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func getProductListOnCollectionID(strCollectionId: String?,success: @escaping (_ objCommonWrapper: ProductListWrapper)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue("*variants.calculated_price, variants.inventory_quantity", forKey: "fields")
        parameters.setValue(strCollectionId ?? "", forKey: "collection_id")
        
       
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getProducList, endValue1: "", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : ProductListWrapper? = ProductListWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    func getProductListOnCategoryID(strCategoryId: String?,success: @escaping (_ objCommonWrapper: ProductListWrapper)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue("*variants.calculated_price, variants.inventory_quantity", forKey: "fields")
        parameters.setValue(strCategoryId ?? "", forKey: "category_id")
        
       
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getProducList, endValue1: "", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : ProductListWrapper? = ProductListWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    func applyWolooCoinsAPI(strPromoCode: String?,strCartID: String?,success: @escaping (_ objCommonWrapper: CreateCart)->Void,
                            failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue([strPromoCode ?? ""], forKey: "promo_codes")
        
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .promotions, endValue1: "\(strCartID ?? "")", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CreateCart? = CreateCart.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func completeVendorAPI(strCartID: String?, success: @escaping (_ objCommonWrapper: CompleteCart)->Void,
                           failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let api = ShopHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .complete_vendor, endValue1: "\(strCartID ?? "")", endValue2: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : CompleteCart? = CompleteCart.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    
    func getProductDetails(strProductID: String?,success: @escaping (_ objCommonWrapper: ProductWrapper)->Void,
                           failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue("*variants.calculated_price, variants.inventory_quantity", forKey: "fields")
        parameters.setValue("reg_01JPH693TAM20TXZEJNBJ5QBV4", forKey: "region_id")
        
        
        let api = ShopHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getStoreProductDetails, endValue1: "\(strProductID ?? "")", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : ProductWrapper? = ProductWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
}
