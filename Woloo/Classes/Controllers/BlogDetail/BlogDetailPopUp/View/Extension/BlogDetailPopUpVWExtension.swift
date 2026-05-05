//
//  BlogDetailPopUpVWExtension.swift
//  Woloo
//
//  Created by CEPL on 03/05/25.
//

import Foundation
import UIKit
import STPopup


extension BlogDetailPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BlogCommentPopUpVCDelegate, BlogAddCommentPopUpVCDelegate, WolooDashboardViewModelDelegate,BlogsPointsPopUpVCDelegate {
    
    
    func didReceievProductDetailsAPISuccess(objResponse: ProductWrapper) {
        //
    }
    
    func didReceieProductDetailsAPIError(strError: String) {
        //
    }
    
    
    
    //MARK: - BlogsPointsPopUpVCDelegate
    func didMNavigateToStore() {
        DispatchQueue.main.async {
            
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    //MARK: - WolooDashboardViewModelDelegate
    func didReceievGetBlogsCommentAPI(objResponse: BaseResponse<[GetBlogComments]>) {
        //
    }
    
    func didReceievGetBlogsCommentAPIError(strError: String) {
        //
    }
    
    func didReceievAddBlogCommentAPI(objResponse: BaseResponse<BlogAddComment>) {
        print("Blogs coment successfully added")
        DispatchQueue.main.async {

            let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                
            objController.isComeFrom = "BlogComments"
            //objController.delegate = self
          
            let popup = STPopupController.init(rootViewController: objController)
            popup.present(in: self)
            
        }
    }
    
    func didReceievAddBlogAPIError(strError: String) {
        print("Blogs successfully added error")
    }
    
    //MARK: - BlogAddCommentPopUpVCDelegate
    func didAddComment(comment: String, blogID: Int) {
        self.objWolooDashboardViewModel.addBlogComment(blogID: blogID, strComment: comment)
    }
    
    func didReceievBlockBlogAPI(objResponse: BaseResponse<BlogWrapper>) {
//        Global.hideIndicator()
//        
    }
    
    func didReceievBlockBlogAPIError(strError: String) {
        //
    }
    
   
    
    
    
    //MARK: - BlogCommentPopUpVCDelegate
    func clickedAddCommentBtn(objBlogModel: BlogModel?) {
        DispatchQueue.main.async {
            let objController = BlogAddCommentPopUpVC(nibName: "BlogAddCommentPopUpVC", bundle: nil)
             objController.delegate = self
            let popup = STPopupController(rootViewController: objController)
            objController.objBlogModel = objBlogModel ?? BlogModel()
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    
    //MARK: - UICollectionview delegate and datasource methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Image count: ")
        return self.objBlogModel.mainImage?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductItemImageCollectionCell.identifier, for: indexPath) as? ProductItemImageCollectionCell ?? ProductItemImageCollectionCell()
        
        if self.objBlogModel.mainImage?.count ?? 0 > 0 {
            cell.configureBlogDetailMultipleImageCell(blogImg: self.objBlogModel.mainImage?[indexPath.item], baseUrl: self.baseUrl)
            
        }
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        indexOfItem = indexPath.item
        pageController.currentPage = indexPath.item
    }
}
