//
//  StoreItemDetailViewModel.swift
//  Woloo
//
//  Created by CEPL on 04/04/25.
//

import Foundation
 
protocol StoreItemDetailViewModelDelegate: NSObjectProtocol {
    
    
    func didReceievAddItemToCartAPISuccess(objResponse: CreateCart)
    
    func didReceievAddItemToCartAPIError(strError: String)
    
    func didReceievRemoveItemFromCartAPISuccess(objResponse: RemoveItem)
    
    func didReceievAddItemToWishListAPISuccess(objResponse: WishListWrapper)
    func didReceievAddItemToWishListAPIError(strError: String)
    
    func didReceievDeleteItemFromWishListAPISuccess(objResponse: WishListWrapper)
    func didReceievDeleteItemFromWishListAPIError(strError: String)
    
    func didReceievProductDetailsAPISuccess(objResponse: ProductWrapper)
    func didReceieProductDetailsAPIError(strError: String)
    
    
    func didRecieveProductReviewsAPISuccess(objResponse: ProductReviewWrapper)
    func didRecieveProductReviewsAPIError(strError: String)
    
}

struct StoreItemDetailViewModel{
    
    var delegate: StoreItemDetailViewModelDelegate?
    
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
    
    
    func addItemToWishListAPI(strVariantID: String?){
        ShopHostAPI().addWishListItemAPI(strVariant_id: strVariantID ?? "") { objCommonWrapper in
            self.delegate?.didReceievAddItemToWishListAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievAddItemToWishListAPIError(strError: error?.localizedDescription ?? "")
        }
    }
    
    func deleteItemFromWishList(strVariantID: String?){
        ShopHostAPI().deleteItemFromWishListAPI(strVariant_id: strVariantID ?? "") { objCommonWrapper in
            self.delegate?.didReceievDeleteItemFromWishListAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievDeleteItemFromWishListAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func getStoreItemDetails(strProductID: String?){
        ShopHostAPI().getProductDetails(strProductID: strProductID ?? "") { objCommonWrapper in
            self.delegate?.didReceievProductDetailsAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceieProductDetailsAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func getProductReviews(strProductID: String?){
        ShopHostAPI().getProductReviews(strProductId: strProductID ?? "") { objCommonWrapper in
            self.delegate?.didRecieveProductReviewsAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveProductReviewsAPIError(strError: error?.localizedDescription ?? "")
        }
    }
   
}
