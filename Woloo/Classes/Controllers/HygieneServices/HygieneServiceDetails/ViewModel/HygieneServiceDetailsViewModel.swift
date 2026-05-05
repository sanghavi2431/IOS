//
//  HygieneServiceDetailsViewModel.swift
//  Woloo
//
//  Created by CEPL on 26/07/25.
//

import Foundation

protocol HygieneServiceDetailsViewModelDelegate: NSObjectProtocol {
    func didRecieveProductReviewsAPISuccess(objResponse: ProductReviewWrapper)
    func didRecieveProductReviewsAPIError(strError: String)
    
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper)
    
    func didReceievGetProductListAPIError(strError: String)
}

struct HygieneServiceDetailsViewModel{
    
    var delegate: HygieneServiceDetailsViewModelDelegate?
    
    func getProductReviews(strProductID: String?){
        HygieneServicesHostAPI().getProductReviews(strProductId: strProductID ?? "") { objCommonWrapper in
            self.delegate?.didRecieveProductReviewsAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveProductReviewsAPIError(strError: error?.localizedDescription ?? "")
        }
    }
    
    func getProductListOnCategoryID(strCategoryId: String?){
        HygieneServicesHostAPI().getProductListOnCategoryID(strCategoryId: strCategoryId ?? "") { objCommonWrapper in
            self.delegate?.didReceievGetProductListAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetProductListAPIError(strError: error?.localizedDescription ?? "")
        }
        
    }
}
