//
//  BlogCommentPopUpVWExtension.swift
//  Woloo
//
//  Created by CEPL on 05/05/25.
//

import Foundation
import UIKit

extension BlogCommentPopUpVC: UITableViewDelegate, UITableViewDataSource, WolooDashboardViewModelDelegate{
    func didReceievProductDetailsAPISuccess(objResponse: ProductWrapper) {
        //
    }
    
    func didReceieProductDetailsAPIError(strError: String) {
        //
    }
    
    
   
    //MARK: - WolooDashboardViewModelDelegate
    func didReceievGetBlogsCommentAPI(objResponse: BaseResponse<[GetBlogComments]>) {
        self.listBlogsComment = objResponse.results
        if self.listBlogsComment.count == 0{
            self.lblNoComment.isHidden = false
        }
        else{
            self.lblNoComment.isHidden = true
        }
        self.tableView.reloadData()
        
    }
    
    func didReceievGetBlogsCommentAPIError(strError: String) {
        //
    }
    
    
    
    func didReceievAddBlogCommentAPI(objResponse: BaseResponse<BlogAddComment>) {
        //
    }
    
    func didReceievAddBlogAPIError(strError: String) {
        //
    }
    
    func didReceievBlockBlogAPI(objResponse: BaseResponse<BlogWrapper>) {
        //
    }
    
    func didReceievBlockBlogAPIError(strError: String) {
        //
    }
    
   
    
    
    
    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.listBlogsComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BlogCommentTableCell? = tableView.dequeueReusableCell(withIdentifier: "BlogCommentTableCell") as! BlogCommentTableCell?
        
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("BlogCommentTableCell", owner: self, options: nil)?.last as? BlogCommentTableCell)
        }
        
        cell?.configureBlogCommentTableCell(objGetBlogComments: self.listBlogsComment[indexPath.row], baseUrl: self.baseUrl)
        
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    
}
