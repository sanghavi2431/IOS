//
//  StoreHomePageViewModel.swift
//  Woloo
//
//  Created by CEPL on 18/03/25.
//

import Foundation

protocol StoreHomePageViewModelDelegate: NSObject{
    
    func didReceievCustomerInfoAPISuccess(objResponse: CustomerCreationWrapper)
    
    func didReceievGetCustomerInfoAPIError(strError: String)
    
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper)
    
    func didReceievGetProductListAPIError(strError: String)
    
    func didReceievGetProductCategoriesAPISuccess(objResponse: ProductcategoryWrapper)
    
    func didReceievGetProductcategoriesAPIError(strError: String)
    
    func didReceievGetCartListAPISuccess(objResponse: CreateCart)
    
    func didReceievGetcartListAPIError(strError: String)
    
    func didReceievAddItemToCartAPISuccess(objResponse: CreateCart)
    
    func didReceievAddItemToCartAPIError(strError: String)
    
    func didReceievRemoveItemFromCartAPISuccess(objResponse: RemoveItem)
    
    func didRecieveemailpassResponse(response: UserRegisterWrapper)
    func didRecieveemailpassError(error: String)
    
    func didRecieveGetWishListResponse(response: WishListWrapper)
    func didRecievegetWishListError(error: String)
    
    func didRecieveBrandListResponse(objWrapper: ProductCollectionsWrapper?)
    func didRecieveBrandListError(error: String)
}

struct StoreHomePageViewModel{
    
    var delegate: StoreHomePageViewModelDelegate?
    
    
    func getCustomerInfo(){
        
        ShopHostAPI().getCustomerInfo { objCommonWrapper in
            self.delegate?.didReceievCustomerInfoAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetCustomerInfoAPIError(strError: error?.localizedDescription ?? "")
        }

        
    }
    
    func getProductListAPI(){
        
        ShopHostAPI().getProductList { objCommonWrapper in
            self.delegate?.didReceievGetProductListAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetProductListAPIError(strError: error?.localizedDescription ?? "")
        }
    }
    
    func getProductCategoriesListAPI(){
        
        ShopHostAPI().getProductCategories { objCommonWrapper in
            self.delegate?.didReceievGetProductCategoriesAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetProductcategoriesAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
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
    
    func emailPassAPI(strMail: String?, strPwd: String?){
    
        AuthHostAPI().emailPassAPI(strMail: strMail ?? "", strPassword: strPwd ?? "") { objCommonWrapper in
            self.delegate?.didRecieveemailpassResponse(response: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveemailpassError(error: error?.localizedDescription ?? "")
        }
    }
    
    func getCustomerWishListAPICall(){
        
        ShopHostAPI().getWishListAPI { objCommonWrapper in
            self.delegate?.didRecieveGetWishListResponse(response: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecievegetWishListError(error: error?.localizedDescription ?? "")
        }
    }
    
    
    func getBrandCollectionList(){
        ShopHostAPI().getBrandList { objCommonWrapper in
            self.delegate?.didRecieveBrandListResponse(objWrapper: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveBrandListError(error: error?.localizedDescription ?? "")
        }

    }
}
