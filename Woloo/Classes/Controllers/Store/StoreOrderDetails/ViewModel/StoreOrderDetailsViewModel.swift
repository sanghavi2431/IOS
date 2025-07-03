//
//  StoreOrderDetails.swift
//  Woloo
//
//  Created by CEPL on 02/04/25.
//

import Foundation

protocol StoreOrderDetailsViewModelDelegate: NSObject{
    
    func didReceievGetOrderListingAPISuccess(objResponse: OrderListingsWrapper)
    
    func didReceievGetOrderListingAPIError(strError: String)
}

struct StoreOrderDetailsViewModel{
    
    var delegate: StoreOrderDetailsViewModelDelegate?
    
    func getOrderListingAPI(strOrderID: String?){
        
        ShopHostAPI().getOrderListingsAPI(strOrderID: strOrderID ?? "") { objCommonWrapper in
            self.delegate?.didReceievGetOrderListingAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetOrderListingAPIError(strError: error?.localizedDescription ?? "")
        }

        
    }
    
}
