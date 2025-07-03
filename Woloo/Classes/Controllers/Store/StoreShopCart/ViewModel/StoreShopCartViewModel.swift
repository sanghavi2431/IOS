//
//  StoreShopCartViewModel.swift
//  Woloo
//
//  Created by CEPL on 26/03/25.
//

import Foundation

protocol StoreShopCartViewModelDeleagte: NSObject{
    func didReceievGetCartListAPISuccess(objResponse: CreateCart)
    
    func didReceievGetcartListAPIError(strError: String)
    
    func didReceievAddItemToCartAPISuccess(objResponse: CreateCart)
    
    func didReceievAddItemToCartAPIError(strError: String)
    
    func didReceievRemoveItemFromCartAPISuccess(objResponse: RemoveItem)
    
    func didRecieveSetShippingAndBillingAddressAPISuccess(objResponse: CreateCart)
    func didReceievSetShippingAndBillingAddressAPIError(strError: String)
    
    func didRecieveGetShippingOptionsAPISuccess(objResponse: ShippingOptionsWrapper)
    func didReceievGetShippingOptionsAPIPIError(strError: String)
    
    func didRecieveSelectShippingMethodAPISuccess(objResponse: CreateCart)
    func didRecieveSelectShippingMethodError(strError: String)
    
    
    //Payment Providers API
    func didRecievePaymentProviderAPISuccess(objResponse: PaymentProviderWrapper)
    func didRecievePaymentProviderError(strError: String)
    
    func didRecievePaymentCollectionAPISuccess(objResponse: PaymentCollectionsWrapper?)
    func didRecievePaymentCollectionAPIError(strError: String)
    
    func didRecievePaymentSessionAPISuccess(objResponse: PaymentCollectionsWrapper)
    func didRecievePaymentSessionAPIError(strError: String)
    
    func didRecieveCompleteCartAPISuccess(objResponse: CompleteCart)
    func didRecieveCompleteCartAPIError(strError: String)
    
    func didRecieveCreateResponse(response: CreateCart)
    func didRecieveCreateCartError(error: String)
    
    func didRecieveCalculateShippingOptionsAPISuccess(response: CalculateShippingOptionWrapper)
    func didRecieveCalculateShippingOptionsAPIError(error: String)
    
    func didRecieveDeletePaymentSessionAPI(objWrapper: DeletePaymentSessionWrapper)
    func didRecieveDeletePaymentSessionErrorAPI(error: String)
    
    func didRecieveApplyPromotionsAPI(objWrapper: CreateCart)
    func didRecieveApplyPromotionErrorAPI(error: String)
    
    func didReceievEcomCoinUpdateAPISuccess(objResponse: BaseResponse<StatusSuccessResponseModel>)
    
    func didReceievEcomCoinUpdateAPIAPIError(strError: String)
    
}

struct StoreShopCartViewModel{
    
    weak var delegate: StoreShopCartViewModelDeleagte?
    
    func getCartListingsAPI(){
        ShopHostAPI().getCartListings { objCommonWrapper in
            self.delegate?.didReceievGetCartListAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetcartListAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func addItemsToCart(strVariantID: String?, quantity: Int?){
        
        ShopHostAPI().addItemsTocart(strVariantID: strVariantID ?? "", quantity: quantity ?? 0) { objCommonWrapper in
            self.delegate?.didReceievAddItemToCartAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievAddItemToCartAPIError(strError: error?.localizedDescription ?? "")
        }

        
    }
    
    
    func removeItemsFromCart(strItemID: String?,quantity: Int?){
        ShopHostAPI().removeItemsTocart(strItemID: strItemID ?? "", quantity: quantity ?? 0) { objCommonWrapper in
            self.delegate?.didReceievRemoveItemFromCartAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievAddItemToCartAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func deleteItemsFromCart(strItemID: String?){
        ShopHostAPI().deleteItemsTocart(strItemID: strItemID ?? "") { objCommonWrapper in
            self.delegate?.didReceievRemoveItemFromCartAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievAddItemToCartAPIError(strError: error?.localizedDescription ?? "")
        }
    }
    
    func setShippingAndBillingAddressAPI(strCartId: String?,objAddress: StoreAddress?){
        ShopHostAPI().setShippingAndBillingAddress(strCartID: strCartId ?? "", objAddress: objAddress ?? StoreAddress()) { objCommonWrapper in
            self.delegate?.didRecieveSetShippingAndBillingAddressAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievSetShippingAndBillingAddressAPIError(strError: error?.localizedDescription ?? "")
        }
    }
    
    func getShippingOptions(strCartId: String?){
        
        ShopHostAPI().getShippingOptions(strCartID: strCartId ?? "") { objCommonWrapper in
            self.delegate?.didRecieveGetShippingOptionsAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            
            self.delegate?.didReceievGetShippingOptionsAPIPIError(strError: error?.localizedDescription ?? "")
        }
    }
    
    
    func selectShippingMethodsAPI(strCartId: String?,strOptionId: String?){
        
        ShopHostAPI().selectShippingMethods(strCartId: strCartId ?? "", strOptionId: strOptionId ?? "") { objCommonWrapper in
            self.delegate?.didRecieveSelectShippingMethodAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveSelectShippingMethodError(strError: error?.localizedDescription ?? "")
        }
    }
    
    func getPaymentProviders(strRegionID: String?){
        
        ShopHostAPI().getPaymentProviders(strRegionID: strRegionID ?? "") { objCommonWrapper in
            self.delegate?.didRecievePaymentProviderAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecievePaymentProviderError(strError: error?.localizedDescription ?? "")
        }

    }
    
    
    func paymentCollectionsAPI(strCartId: String?){
        
        ShopHostAPI().paymentCollectionsAPI(strCartId: strCartId ?? "") { objCommonWrapper in
            self.delegate?.didRecievePaymentCollectionAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecievePaymentCollectionAPIError(strError: error?.localizedDescription ?? "")
        }

    }
       
    func paymentSessionsAPI(strPayCollectionID: String?, strProviderId: String?){
        
        ShopHostAPI().paymentSessionsAPI(strPayCollectionID: strPayCollectionID ?? "", strProviderId: strProviderId ?? "") { objCommonWrapper in
            self.delegate?.didRecievePaymentSessionAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecievePaymentSessionAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func completeCart(strCartID: String?){
        
        ShopHostAPI().completeCartAPI(strCartID: strCartID ?? "") { objCommonWrapper in
            self.delegate?.didRecieveCompleteCartAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveCompleteCartAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func calculateShippingOptionsAPI(strCartID: String?, strOptionsID: String?){
        
        ShopHostAPI().calculateShippingOptionsAPI(strCartID: strCartID ?? "", strOptionsID: strOptionsID ?? "") { objCommonWrapper in
            self.delegate?.didRecieveCalculateShippingOptionsAPISuccess(response: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveCalculateShippingOptionsAPIError(error: error?.localizedDescription ?? "")
        }


    }
    
    
    func createCartAPI(strRegionID: String?){
    
        ShopHostAPI().createCartAPI(strRegionID: strRegionID ?? "") { objCommonWrapper in
            self.delegate?.didRecieveCreateResponse(response: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveCreateCartError(error: error?.localizedDescription ?? "")
        }


    }
    
    func deletePaymentSessionsAPI(strPaymentSessionID: String?){
        
        ShopHostAPI().deletePaymentSession(strPaymentID: strPaymentSessionID ?? "") { objCommonWrapper in
            self.delegate?.didRecieveDeletePaymentSessionAPI(objWrapper: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveDeletePaymentSessionErrorAPI(error: error?.localizedDescription ?? "")
        }

    }
    
    func applyPromotionsAPI(strPromotionCode: String?, strCartID: String?){
        
        ShopHostAPI().applyWolooCoinsAPI(strPromoCode: strPromotionCode ?? "", strCartID: strCartID ?? "") { objCommonWrapper in
            self.delegate?.didRecieveApplyPromotionsAPI(objWrapper: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveApplyPromotionErrorAPI(error: error?.localizedDescription ?? "")
        }

    }
    
    func ecomCoinUpdateAPI(strOrderID: String?){
        
        BlogAPI().ecomcoinUpdateAPI(strOrderID: strOrderID ?? "") { objCommonWrapper in
            self.delegate?.didReceievEcomCoinUpdateAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievEcomCoinUpdateAPIAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func completevendor(strCartID: String?){
        
        ShopHostAPI().completeVendorAPI(strCartID: strCartID ?? "") { objCommonWrapper in
            self.delegate?.didRecieveCompleteCartAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveCompleteCartAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
}
