//
//  InterestedTopicViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 11/09/24.
//

import Foundation

protocol InterestedTopicViewModelDelegate{
    
    func didRecieveGetCategoryResponse(objWraper: BaseResponse<[CategoryModel]>)
    func didReceiveGetCategoryError(strError: String?)
    
    func didRecieveSaveCategorySuccess(objWrapper: BaseResponse<StatusSuccessResponseModel>)
    func didRecieveSaveCategoryError(strError: String?)
    
}
 
struct InterestedTopicViewModel {
    
    
    var delegate : InterestedTopicViewModelDelegate?
    
    
    func getCategoryAPI(){
        
        BlogAPI().getCategories { objCommonWrapper in
            self.delegate?.didRecieveGetCategoryResponse(objWraper: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiveGetCategoryError(strError: error?.localizedDescription ?? "")
        }

    }
    
    
    func saveBlogCategoryAPI(arrInt: [Int]){
        
        BlogAPI().saveBlogCategory(arrInt: arrInt) { objCommonWrapper in
            self.delegate?.didRecieveSaveCategorySuccess(objWrapper: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiveGetCategoryError(strError: error?.localizedDescription ?? "")
        }


    }
}
