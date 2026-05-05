//
//  HygieneServicesHomeViewModel.swift
//  Woloo
//
//  Created by CEPL on 09/07/25.
//

import Foundation

protocol HygieneServicesHomeViewModelDelegate: NSObject{
    
    func didReceievGetHygieneCategoriesAPISuccess(objResponse: ProductcategoryWrapper)
    
    func didReceievGetHygieneCategoriesAPIError(strError: String)
    
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper)
    
    func didReceievGetProductListAPIError(strError: String)
}

struct HygieneServicesHomeViewModel{
    
    var delegate: HygieneServicesHomeViewModelDelegate?
    
    func getProductCategoriesListAPI(){
        
        HygieneServicesHostAPI().getServiceCategories { objCommonWrapper in
            self.delegate?.didReceievGetHygieneCategoriesAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetHygieneCategoriesAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func getProductCategoryAPI(strCategoryId: String?){
        HygieneServicesHostAPI().getProductListOnCategoryID(strCategoryId: strCategoryId ?? "") { objCommonWrapper in
            self.delegate?.didReceievGetProductListAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetProductListAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
}
