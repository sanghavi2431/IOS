//
//  StoreSearchViewModel.swift
//  Woloo
//
//  Created by CEPL on 20/03/25.
//

import Foundation

protocol StoreSearchViewModelDelegate: NSObject{
    
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper)
    
    func didReceievGetProductListAPIError(strError: String)
}

struct StoreSearchViewModel{
    
    var delegate: StoreSearchViewModelDelegate?
    
    func getSearchProductListAPI(strSearchText: String?){
        
        ShopHostAPI().getSearchedProductList(strSearch: strSearchText ?? "") { objCommonWrapper in
            
            self.delegate?.didReceievGetProductListAPISuccess(objResponse: objCommonWrapper)
            
        } failure: { error in
            self.delegate?.didReceievGetProductListAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
}
