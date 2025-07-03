//
//  WolooDashBoardVWExtension.swift
//  Woloo
//
//  Created by CEPL on 03/05/25.
//

import Foundation
import UIKit
import STPopup

extension WolooDashBoardVC: UITableViewDelegate, UITableViewDataSource, BlogDetailVideoCellDelegate, BlogCommentPopUpVCDelegate, BlogAddCommentPopUpVCDelegate, WolooDashboardViewModelDelegate, TrendingListCellDelegate, BlogDetailPopUpVCDelegate{
    
    //MARK: - BlogDetailPopUpVCDelegate
    func didUpdatedCommentStatus() {
        self.getBlogsAndCategoryAPIV2(cat: "All")
    }
    
    
    //MARK: - TrendingListCellDelegate
    func didClickedCategory(id: Int?, listCategoryModel: [CategoryModel]?) {
        self.objBlogDetailModel.categories = listCategoryModel ?? [CategoryModel]()
        self.getBlogsAndCategoryAPIV2(cat: "\(id ?? 0)")
    }
    
    //MARK: - BlogAddCommentPopUpVCDelegate
    
    
    func didBockBlogs(objBlogModel: BlogModel?, currentIndexPath: IndexPath?) {
        DispatchQueue.main.async {
            
            
            let cell = self.tableView.cellForRow(at: currentIndexPath ?? IndexPath())
            let frm = self.tableView!.convert(cell!.frame, to: self.view)
            
            let objController = BlogsBlockPopupVC.init(nibName: "BlogsBlockPopupVC", bundle: nil)
            objController.hidesBottomBarWhenPushed = true
            objController.definesPresentationContext = true
            objController.modalPresentationStyle = .overCurrentContext
            objController.vwFrame = frm
            UIApplication.shared.delegate?.window??.rootViewController!.present(objController, animated: true, completion: nil)
            self.navigationController?.pushViewController(objController, animated: true)
        }
    }

    func didClickedShopNowBtn(objBlogModel: BlogModel?) {
        self.objBlogModel = objBlogModel ?? BlogModel()
        
        if Utility.isEmpty(self.objBlogModel.shop_map_id ?? ""){
            
        }
        else{
            let objController = StoreItemDetailsVC.init(nibName: "StoreItemDetailsVC", bundle: nil)
            objController.strProductID = self.objBlogModel.shop_map_id ?? ""
            
            self.navigationController?.pushViewController(objController, animated: true)
        }
    }
    
    func didAddComment(comment: String, blogID: Int) {
        
        self.objWolooDashboardViewModel.addBlogComment(blogID: blogID, strComment: comment)
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
    
   
    
    //MARK: - BlogDetailVideoCellDelegate
    func didClickedLikeBtn(objBlogModel: BlogModel?) {
        print("Call like blog api", objBlogModel?.id ?? 0)
       
        self.favouriteBLOGV2(objBlogModel?.id ?? 0)
    }
    
    func didClickedCommentBtn(objBlogModel: BlogModel?) {
        print("Call show comments api", objBlogModel?.id ?? 0)
        DispatchQueue.main.async {
            
            let objController = BlogCommentPopUpVC(nibName: "BlogCommentPopUpVC", bundle: nil)
           
            objController.delegate = self
            objController.objBlogModel = objBlogModel ?? BlogModel()
            objController.baseUrl = self.objBlogDetailModel.baseUrl ?? ""
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    func didClickedShareBtn(objBlogModel: BlogModel?, currentIndexPath: Int?) {
        print("Call share blog", objBlogModel?.id ?? 0)
        self.openshare(currentIndexPath ?? 0)
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
    
    func didReceievBlockBlogAPI(objResponse: BaseResponse<BlogWrapper>) {
        Global.hideIndicator()
        self.showToast(message: objResponse.results.message ?? "")
        getBlogsAndCategoryAPIV2(cat: "All")
        
    }
    
    func didReceievBlockBlogAPIError(strError: String) {
        Global.hideIndicator()
        print("Errror", strError)
    }
    
    
    //Item details API
    func didReceievProductDetailsAPISuccess(objResponse: ProductWrapper) {
        
    }
    
    func didReceieProductDetailsAPIError(strError: String) {
        //
    }
    
    
    //MARK: - UITableView Delegate and DataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return self.objBlogDetailModel.blogs.count
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if indexPath.section == 0{
            var cell: TrendingListCell? = tableView.dequeueReusableCell(withIdentifier: "TrendingListCell") as! TrendingListCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("TrendingListCell", owner: self, options: nil)?.last as? TrendingListCell)
            }
            cell?.delegate = self
            cell?.listOfCategoryV2 = self.objBlogDetailModel.categories
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 1{
            
            if self.objBlogDetailModel.blogs[indexPath.row].main_video?.count ?? 0 > 0{
                var cell: BlogDetailVideoCell? = tableView.dequeueReusableCell(withIdentifier: "BlogDetailVideoCell") as! BlogDetailVideoCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("BlogDetailVideoCell", owner: self, options: nil)?.last as? BlogDetailVideoCell)
                }
                
                cell?.delegate = self
                cell?.baseUrl = self.objBlogDetailModel.baseUrl
                //cell?.blockBtn.tag = indexPath.row
                //cell?.blockBtn.addTarget(self, action: #selector(threeDotButtonTapped(_:)), for: .touchUpInside)
                cell?.configureBlogDetailCell(objBlogModel: self.objBlogDetailModel.blogs[indexPath.row], parentVC: self, indexPath: indexPath)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else{
                if self.objBlogDetailModel.blogs[indexPath.row].mainImage?.count ?? 0 <= 1{
                    
                    print("show single image")
                    var cell: BlogDetailSingleImgCell? = tableView.dequeueReusableCell(withIdentifier: "BlogDetailSingleImgCell") as! BlogDetailSingleImgCell?
                    
                    if cell == nil {
                        cell = (Bundle.main.loadNibNamed("BlogDetailSingleImgCell", owner: self, options: nil)?.last as? BlogDetailSingleImgCell)
                    }
                    
                    cell?.delegate = self
                    cell?.baseUrl = self.objBlogDetailModel.baseUrl
                    //cell?.blockBtn.tag = indexPath.row
                    //cell?.blockBtn.addTarget(self, action: #selector(threeDotButtonTapped(_:)), for: .touchUpInside)
                   
                    cell?.configureBlogDetailSingleImgCell(objBlogModel: self.objBlogDetailModel.blogs[indexPath.row], currentIndexPath: indexPath)
                    
                    cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                    return cell!
                    
                }
                else if self.objBlogDetailModel.blogs[indexPath.row].mainImage?.count ?? 0 == 2{
                    print("show double image")
                    var cell: BlogDetailDoubleImgCell? = tableView.dequeueReusableCell(withIdentifier: "BlogDetailDoubleImgCell") as! BlogDetailDoubleImgCell?
                    
                    if cell == nil {
                        cell = (Bundle.main.loadNibNamed("BlogDetailDoubleImgCell", owner: self, options: nil)?.last as? BlogDetailDoubleImgCell)
                    }
                    
                    cell?.delegate = self
                    //cell?.blockBtn.tag = indexPath.row
                    cell?.baseUrl = self.objBlogDetailModel.baseUrl
                    //cell?.blockBtn.addTarget(self, action: #selector(threeDotButtonTapped(_:)), for: .touchUpInside)

                     cell?.configureBlogDetailDoubleImgCell(objBlogModel: self.objBlogDetailModel.blogs[indexPath.row], currentIndexPath: indexPath)
                    
                    cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                    return cell!
                }
                else if self.objBlogDetailModel.blogs[indexPath.row].mainImage?.count ?? 0 == 3{
                    print("show triple image")
                    var cell: BlogDetaiTripleImgCell? = tableView.dequeueReusableCell(withIdentifier: "BlogDetaiTripleImgCell") as! BlogDetaiTripleImgCell?
                    
                    if cell == nil {
                        cell = (Bundle.main.loadNibNamed("BlogDetaiTripleImgCell", owner: self, options: nil)?.last as? BlogDetaiTripleImgCell)
                    }
                    
                    cell?.delegate = self
                    //cell?.blockBtn.tag = indexPath.row
                    cell?.baseUrl = self.objBlogDetailModel.baseUrl
                    //cell?.blockBtn.addTarget(self, action: #selector(threeDotButtonTapped(_:)), for: .touchUpInside)

                     cell?.configureBlogDetailTripleImgCell(objBlogModel: self.objBlogDetailModel.blogs[indexPath.row], currentIndexPath: indexPath)
                    
                    cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                    return cell!
                }
                else if self.objBlogDetailModel.blogs[indexPath.row].mainImage?.count ?? 0 == 4{
                    print("show four image")
                    var cell: BlogDetaiFourImgCell? = tableView.dequeueReusableCell(withIdentifier: "BlogDetaiFourImgCell") as! BlogDetaiFourImgCell?
                    
                    if cell == nil {
                        cell = (Bundle.main.loadNibNamed("BlogDetaiFourImgCell", owner: self, options: nil)?.last as? BlogDetaiFourImgCell)
                    }
                    
                    cell?.delegate = self
                    ///cell?.blockBtn.tag = indexPath.row
                    cell?.baseUrl = self.objBlogDetailModel.baseUrl
                    //cell?.blockBtn.addTarget(self, action: #selector(threeDotButtonTapped(_:)), for: .touchUpInside)

                     cell?.configureBlogDetailFourImgCell(objBlogModel: self.objBlogDetailModel.blogs[indexPath.row], currentIndexPath: indexPath)
                    
                    cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                    return cell!
                    
                }
                else if self.objBlogDetailModel.blogs[indexPath.row].mainImage?.count ?? 0 > 4{
                    print("show more than four image")
                    var cell: BlogDetaiFiveImgCell? = tableView.dequeueReusableCell(withIdentifier: "BlogDetaiFiveImgCell") as! BlogDetaiFiveImgCell?
                    
                    if cell == nil {
                        cell = (Bundle.main.loadNibNamed("BlogDetaiFiveImgCell", owner: self, options: nil)?.last as? BlogDetaiFiveImgCell)
                    }
                    
                    cell?.delegate = self
                    //cell?.blockBtn.tag = indexPath.row
                    cell?.baseUrl = self.objBlogDetailModel.baseUrl
                    //cell?.blockBtn.addTarget(self, action: #selector(threeDotButtonTapped(_:)), for: .touchUpInside)

                     cell?.configureBlogDetailFiveImgCell(objBlogModel: self.objBlogDetailModel.blogs[indexPath.row], currentIndexPath: indexPath)
                    
                    cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                    return cell!
                }
                
            }
        }
        else{
            
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
     func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? BlogDetailVideoCell {
            videoCell.pauseVideo()
        }
    }
    
    
    @objc func threeDotButtonTapped(_ sender: UIButton) {
        let row = sender.tag
        let blogId = self.objBlogDetailModel.blogs[row].id // Or use your actual data model

        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let anchorFrame = sender.convert(sender.bounds, to: window)

        let overlay = TweetContextMenuOverlay(anchor: anchorFrame, in: window) { action in
            print("Selected: \(action)")
            print("Perform action for blogId: \(blogId ?? 0)")

            // You can now route actions here
            if action == "Block" {
                self.dismissContextMenu()
                Global.showIndicator()
                self.objWolooDashboardViewModel.blockBlogs(blogID: blogId ?? 0)
            }         }

        window.addSubview(overlay)
    }
    
    func dismissContextMenu() {
        contextMenuOverlay?.removeFromSuperview()
        contextMenuOverlay = nil
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
            print("open blog details page")
            DispatchQueue.main.async{
                self.blogIndex = indexPath.row
                if self.objBlogDetailModel.blogs[indexPath.row].isBlogRead == 0{
                    self.blogReadV2(index: self.objBlogDetailModel.blogs[indexPath.row].id ?? 0)
                }
                else{
                    let objController = BlogDetailPopUpVC(nibName: "BlogDetailPopUpVC", bundle: nil)
                    objController.delegate = self
                    if self.objBlogDetailModel.blogs[indexPath.row].main_video?.count ?? 0 > 0{
                        objController.detailType = "VIDEO"
                    }
                    objController.objBlogModel = self.objBlogDetailModel.blogs[indexPath.row]
                    objController.baseUrl = self.objBlogDetailModel.baseUrl
                    
                    self.navigationController?.pushViewController(objController, animated: true)
                }
            }
        }
    }
    
    func showPopupMenu(from button: UIView) {
            let menu = TweetContextMenu()
            menu.actionHandler = { action in
                print("Selected: \(action)")
            }

            // Position relative to button
            let frame = button.convert(button.bounds, to: self.view)
            menu.frame = CGRect(x: frame.maxX - 150, y: frame.maxY + 5, width: 131, height: 40)

            // Optional: Dismiss existing
            self.view.subviews.forEach {
                if $0 is TweetContextMenu { $0.removeFromSuperview() }
            }

            self.view.addSubview(menu)
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.subviews.forEach {
            if $0 is TweetContextMenu {
                $0.removeFromSuperview()
            }
        }
    }
}
