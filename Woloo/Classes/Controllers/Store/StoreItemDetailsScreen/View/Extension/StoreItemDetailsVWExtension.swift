//
//  StoreItemDetailsVWExtension.swift
//  Woloo
//
//  Created by CEPL on 05/03/25.
//

import Foundation
import STPopup

extension StoreItemDetailsVC: UITableViewDelegate, UITableViewDataSource, ShopCartPopUpVCDelegate, ShopCheckoutPopUpVCDelegate, OrderSummaryPopUpVCDelegate, ProductRatingCartCellDelegate, StoreItemDetailViewModelDelegate, ProductItemInfoCellDelegate, ProductItemImageCellDelegate, ProductItemColorCellProtocol{
    
    //MARK: - ProductItemColorCellProtocol
    func didSelectItem(objProductOptionValue: ProductOptionValue?) {
        for opt in self.objProduct.options ?? [ProductOptions](){
            
            if opt.title == "Color"{
                for val in opt.values ?? [ProductOptionValue](){
                    
                    if val.id == objProductOptionValue?.id{
                        val.isSelected = true
                    }
                    else{
                        val.isSelected = false
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
   
   
    //MARK: - ProductItemImageCellDelegate
    func didWishlishedItem(objProduct: Products?, strType: String?) {
        self.objProduct = objProduct ?? Products()
        
        if strType == "Add"{
            print("call add item API")
            self.objStoreItemDetailViewModel.addItemToWishListAPI(strVariantID: self.objProduct.variants?[0].id ?? "")
        }else{
            print("call remove item API")
            self.objStoreItemDetailViewModel.deleteItemFromWishList(strVariantID: self.objProduct.variants?[0].id ?? "")
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: - ProductItemInfoCellDelegate
    func didClickedBuyNowBtn(objProduct: Products?) {
        let objController = StoreShopCartVC.init(nibName: "StoreShopCartVC", bundle: nil)
       // objController.delegate = self
        objController.listAddress = self.listAddress
        objController.objSelectedAddress = self.objSelectedAddress
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    //MARK: - StoreItemDetailViewModelDelegate
    
    
    func didReceievProductDetailsAPISuccess(objResponse: ProductWrapper) {
        print("product id",objResponse.product?.id ?? "")
        self.tableView.isHidden = false
        self.objProduct = objResponse.product ?? Products()
        
        self.lblPrice.text = String(format: "%@%d/-","\u{20B9}",self.objProduct.variants?[0].calculated_price?.calculated_amount ?? 0)
        let originalAmount = self.objProduct.variants?.first?.calculated_price?.original_amount ?? 0
        self.lblVariant.text = self.objProduct.variants?.first?.options?.first?.value ?? ""
        
        Global.hideIndicator()
        self.tableView.reloadData()
    }
    
    func didReceieProductDetailsAPIError(strError: String) {
        //
    }
    
    func didRecieveProductReviewsAPISuccess(objResponse: ProductReviewWrapper) {
        print("Get reviews success", objResponse.data?.product_id ?? "")
        self.listProductReviews = objResponse.data?.reviews ?? [ProductReview]()
        self.tableView.reloadData()
    }
    
    func didRecieveProductReviewsAPIError(strError: String) {
        print("Get reviews error")
    }
    
    
   
    
    
    func didReceievAddItemToCartAPISuccess(objResponse: CreateCart) {
        let objController = StoreShopCartVC.init(nibName: "StoreShopCartVC", bundle: nil)
       // objController.delegate = self
        objController.listAddress = self.listAddress
        objController.objSelectedAddress = self.objSelectedAddress
        self.navigationController?.pushViewController(objController, animated: true)
        if self.delegate != nil{
            self.delegate?.didPartItemUpdated()
        }
    }
    
    func didReceievAddItemToCartAPIError(strError: String) {
        print("Add items Error")
    }
    
    func didReceievRemoveItemFromCartAPISuccess(objResponse: RemoveItem) {
        if self.delegate != nil{
            self.delegate?.didPartItemUpdated()
        }
    }
    
    //add item to wishlist
    func didReceievAddItemToWishListAPISuccess(objResponse: WishListWrapper) {
        print("Add item to wishlist API success")
        print("item added", objResponse.wishlist?.id ?? "")
        self.objCustomerWishList = objResponse.wishlist ?? CreateCustomerWishList()
        if self.delegate != nil{
            self.delegate?.didWishListUpdated()
        }
        
        self.tableView.reloadData()
    }
    
    func didReceievAddItemToWishListAPIError(strError: String) {
        print("Add item to wishlist API error")
    }
    
    //Delete Item From Wishlist
    func didReceievDeleteItemFromWishListAPISuccess(objResponse: WishListWrapper) {
        print("delete item to wishlist API success")
        print("item removed", objResponse.wishlist?.id ?? "")
        self.objCustomerWishList = objResponse.wishlist ?? CreateCustomerWishList()
        if self.delegate != nil{
            self.delegate?.didWishListUpdated()
        }
        self.tableView.reloadData()
    }
    
    func didReceievDeleteItemFromWishListAPIError(strError: String) {
        print("delete item to wishlist API error")
    }
    
    
    
 
    //MARK: - ProductRatingCartCellDelegate
    
    func didUpdateProductQuantity(objproduct: Products?, strType: String?) {
       
        if strType == "Add"{
            objproduct?.quantity  = (objproduct?.quantity ?? 0) + 1
            self.objStoreItemDetailViewModel.addItemsToCart(strVariantID: objproduct?.variants?[0].id ?? "", quantity: 1)
        }
        else{
            self.objStoreItemDetailViewModel.removeItemsFromCart(strItemID: objproduct?.id ?? "", quantity: 1)
        }
        self.objProduct = objproduct ?? Products()
        self.tableView.reloadData()
    }
    
    
    
    func didClickedEditAddressCartBtn(objAddress: StoreAddress?) {
        //
    }
    
    func didClickedEditAddressCartBtn() {
        //
    }
    
    
    //MARK: OrderSummaryPopUpVCDelegate
    func didClickedPayViaBtn() {
        DispatchQueue.main.async {
            let objController = StoreOrderDetailsVC.init(nibName: "StoreOrderDetailsVC", bundle: nil)
          
            self.navigationController?.pushViewController(objController, animated: true)
        }
    }
    
    func didClickedEditAddresssBtn() {
        DispatchQueue.main.async {
            
            let objController = SelectAdressPopUpViewController(nibName: "SelectAdressPopUpViewController", bundle: nil)
           // objController.delegate = self
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    func didChangePaymentType() {
        DispatchQueue.main.async {
            
            let objController = ShopCheckoutPopUpVC(nibName: "ShopCheckoutPopUpVC", bundle: nil)
            objController.delegate = self
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    
    
    func didClickedReviewOrder() {
        DispatchQueue.main.async {
            let objController = OrderSummaryPopUpVC(nibName: "OrderSummaryPopUpVC", bundle: nil)
            objController.delegate = self
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    
    //MARK: - ShopCartPopUpVCDelegate
    func didClickedCheckOutBtn() {
        DispatchQueue.main.async {
            
            let objController = ShopCheckoutPopUpVC(nibName: "ShopCheckoutPopUpVC", bundle: nil)
            objController.delegate = self
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    func didClickedKeepShoppingBtn() {
        DispatchQueue.main.async {
            
            let objController = ShopCheckoutPopUpVC(nibName: "ShopCheckoutPopUpVC", bundle: nil)
            objController.delegate = self
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    
   
    
    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            
            return 4
            
        }else if section == 1{
            
            return self.objProduct.options?.count ?? 0
            
        }
        else if section == 2{
            
            return 2
            
        }
        else if section == 4{
            
            return self.listProductReviews.count
            
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            if indexPath.row == 0{
                var cell: ProductItemImageCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemImageCell") as! ProductItemImageCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductItemImageCell", owner: self, options: nil)?.last as? ProductItemImageCell)
                }
                
                cell?.delegate = self
                cell?.configureProductItemImageCell(objProduct: self.objProduct)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else  if indexPath.row == 1{//ProductRatingCartCell
                var cell: ProductRatingCartCell? = tableView.dequeueReusableCell(withIdentifier: "ProductRatingCartCell") as! ProductRatingCartCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductRatingCartCell", owner: self, options: nil)?.last as? ProductRatingCartCell)
                }
                
                cell?.delegate = self
                cell?.configureProductRatingCartCell(objProducts: self.objProduct)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else  if indexPath.row == 2{//ProductItemInfoCell
                var cell: ProductItemInfoCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemInfoCell") as! ProductItemInfoCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductItemInfoCell", owner: self, options: nil)?.last as? ProductItemInfoCell)
                }
                cell?.delegate = self
                cell?.configureProductItemInfoCell(objProduct: self.objProduct)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else  if indexPath.row == 3{//ProductItemInfoCell
                var cell: ProductItemDescCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemDescCell") as! ProductItemDescCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductItemDescCell", owner: self, options: nil)?.last as? ProductItemDescCell)
                }
               
                cell?.configureProductItemDescCell(objProduct: self.objProduct)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else{
                return UITableViewCell()
            }
        } // section 0 ends
        else if indexPath.section == 1{
            //color cell
           
                var cell: ProductItemColorCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemColorCell") as! ProductItemColorCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductItemColorCell", owner: self, options: nil)?.last as? ProductItemColorCell)
                }
            
            cell?.delegate = self
            cell?.configureOptions(objProductOptions: self.objProduct.options?[indexPath.row])
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
 
        }
        else if indexPath.section == 2{
        if indexPath.row == 0{
                var cell: ProductItemAddressCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemAddressCell") as! ProductItemAddressCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductItemAddressCell", owner: self, options: nil)?.last as? ProductItemAddressCell)
                }
                
                cell?.configureProductItemAddressCell(objAddress: self.objSelectedAddress)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            //Recent Search Cell
            else  if indexPath.row == 1{
                var cell: ProductItemRecentSearchCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemRecentSearchCell") as! ProductItemRecentSearchCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductItemRecentSearchCell", owner: self, options: nil)?.last as? ProductItemRecentSearchCell)
                }
                
               
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
        }
        
        if indexPath.section == 3{
            var cell: RatingsAndReviewCell? = tableView.dequeueReusableCell(withIdentifier: "RatingsAndReviewCell") as! RatingsAndReviewCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("RatingsAndReviewCell", owner: self, options: nil)?.last as? RatingsAndReviewCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 4{
            
            var cell: RatingsAndReviewListCell? = tableView.dequeueReusableCell(withIdentifier: "RatingsAndReviewListCell") as! RatingsAndReviewListCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("RatingsAndReviewListCell", owner: self, options: nil)?.last as? RatingsAndReviewListCell)
            }
            
            cell?.configureRatingsAndReviewListCell(objProductReview: self.listProductReviews[indexPath.row])
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 5{
            
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }

        else{
            return UITableViewCell()
        }
        
    }
    
    
    
}
