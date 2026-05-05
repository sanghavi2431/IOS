//
//  WolooDashboardViewModel.swift
//  Woloo
//
//  Created by CEPL on 06/05/25.
//

import Foundation

protocol WolooDashboardViewModelDelegate: NSObjectProtocol{
    
    func didReceievGetBlogsCommentAPI(objResponse: BaseResponse<[GetBlogComments]>)
    
    func didReceievGetBlogsCommentAPIError(strError: String)
    
    func didReceievAddBlogCommentAPI(objResponse: BaseResponse<BlogAddComment>)
    
    func didReceievAddBlogAPIError(strError: String)
    
    func didReceievBlockBlogAPI(objResponse: BaseResponse<BlogWrapper>)
    
    func didReceievBlockBlogAPIError(strError: String)
    
    func didReceievProductDetailsAPISuccess(objResponse: ProductWrapper)
    func didReceieProductDetailsAPIError(strError: String)
    
}

struct WolooDashboardViewModel {
    
    var delegate: WolooDashboardViewModelDelegate?
    
    func getBlogsCommentAPI(blogID: Int?){
        BlogAPI().getBlogCommentsAPI(strBlogID: blogID ?? 0) { objCommonWrapper in
            self.delegate?.didReceievGetBlogsCommentAPI(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetBlogsCommentAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func addBlogComment(blogID: Int?, strComment: String?){
        
        BlogAPI().addBlogComments(blogID: blogID ?? 0, strComment: strComment ?? "") { objCommonWrapper in
            self.delegate?.didReceievAddBlogCommentAPI(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievAddBlogAPIError(strError: error?.localizedDescription ?? "")
        }
    }
    
    func blockBlogs(blogID: Int?){
        BlogAPI().blockBlogs(blogID: blogID ?? 0) { objCommonWrapper in
            self.delegate?.didReceievBlockBlogAPI(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievBlockBlogAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
    
    func getStoreItemDetails(strProductID: String?){
        ShopHostAPI().getProductDetails(strProductID: strProductID ?? "") { objCommonWrapper in
            self.delegate?.didReceievProductDetailsAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceieProductDetailsAPIError(strError: error?.localizedDescription ?? "")
        }

    }
    
}
