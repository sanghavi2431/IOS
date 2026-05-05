//
//  WriteAReviewPopViewModel.swift
//  Woloo
//
//  Created by CEPL on 29/03/25.
//

import Foundation

protocol WriteAReviewPopViewModelDelegate: NSObjectProtocol{
    
    func didRecieveAddreviewSuccess(objWrapper: ProductReviewWrapper?)
    
    func didRecieveAddreviewAPIError(strError: String?)
}

struct WriteAReviewPopViewModel{
    
    var delegate: WriteAReviewPopViewModelDelegate?
    

    func addReviewAPI(strProductId: String?, rating: Int?, strComment: String?){
        
        ShopHostAPI().addProductReview(strProductId: strProductId ?? "", rating: rating ?? 0, strComment: strComment ?? "") { objCommonWrapper in
            self.delegate?.didRecieveAddreviewSuccess(objWrapper: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveAddreviewAPIError(strError: error?.localizedDescription ?? "")
        }

    }
}
