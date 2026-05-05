//
//  StoreShowAllProductViewModel.swift
//  Woloo
//
//  Created by CEPL on 15/04/25.
//

import Foundation

protocol StoreShowAllProductViewModelDelegate: NSObjectProtocol{
    
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper)
    
    func didReceievGetProductListAPIError(strError: String)
    
    func didReceieveFilteredProductAPISuccess(objResponse: ProductListWrapper)
    
    func didReceieveFilteredProductAPIError(strError: String)
}

struct StoreShowAllProductViewModel{
    
    var delegate: StoreShowAllProductViewModelDelegate?
    
    
    func getProductListAPI(strCollectionId: String?){
        
        ShopHostAPI().getProductListOnCollectionID(strCollectionId: strCollectionId ?? "") { objCommonWrapper in
            self.delegate?.didReceievGetProductListAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetProductListAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func getCategoriesProductListAPI(strCategoryId: String?){
        
        ShopHostAPI().getProductListOnCategoryID(strCategoryId: strCategoryId ?? "") { objCommonWrapper in
            self.delegate?.didReceievGetProductListAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetProductListAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func getFilteredProductAPIList(strCategoryID: String?,optionValue: String?){
        
        ShopHostAPI().getFilterProducts(strCategoryID: strCategoryID ?? "", optionValue: optionValue ?? "") { objCommonWrapper in
            self.delegate?.didReceieveFilteredProductAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceieveFilteredProductAPIError(strError: error?.localizedDescription ?? "")
        }

    }
}
