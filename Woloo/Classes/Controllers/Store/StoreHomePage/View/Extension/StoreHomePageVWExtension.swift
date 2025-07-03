//
//  StoreHomePageVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 29/01/25.
//

import Foundation
import UIKit
import STPopup


 
extension StoreHomePageVC: UITableViewDelegate, UITableViewDataSource, StoreMostPurchaseTblCellDelegate, StoreHomePageViewModelDelegate, SelectAdressPopUpViewControllerDelegate, EditAddressPopUpViewControllerDelegate, EditProfileViewModelDelegate, StoreShopCartVCDelegate, OrderFavouritesCellDelegate, StoreItemDetailsVCDelegate, StoreBrandCellDelegate, StoreCategoriesTblCellDelegate, ServicesPopUpVCDeleate, StoreShowAllProductVCDelegate{
    
    
    //MARK: - StoreShowAllProductVCDelegate
    func didChangeValues() {
        self.objStoreHomePageViewModel.getCartListingsAPI()
    }
    
    //MARK: - ServicesPopUpVCDeleate
    func didClickedStoreBtn() {
        DispatchQueue.main.async {
            
            self.tabBarController?.selectedIndex = 1
        }
    }
        
    func didClickedHygieneServicesBtn() {
        DispatchQueue.main.async {
            let objController = HygieneServicesHomePageVC.init(nibName: "HygieneServicesHomePageVC", bundle: nil)
            
            self.navigationController?.pushViewController(objController, animated: true)
        }
    }
    
    
    
    //MARK: - StoreCategoriesTblCellDelegate
    func didSelectedCategories(objCategory: StoreProductCategories?) {
        let objController = StoreShowAllProductVC.init(nibName: "StoreShowAllProductVC", bundle: nil)
        objController.delegate = self
        objController.strIsComeFrom = "CATEGORIES"
        objController.objStoreProductCategories = objCategory ?? StoreProductCategories()
        
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
   
    //MARK: - StoreBrandCellDelegate
    func didClickedSeeMoreBrand() {
        print("Show more brand screen")
        let objController = StoreShowAllBrandVC.init(nibName: "StoreShowAllBrandVC", bundle: nil)
        
        objController.listBrands = self.lisBrand
        
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    func didClickedBrand(objBrand: ProductCollection) {
        let objController = StoreShowAllProductVC.init(nibName: "StoreShowAllProductVC", bundle: nil)
        objController.delegate = self
        objController.strIsComeFrom = "BRANDS"
        objController.objBrands = objBrand
        
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
   
    //MARK: - StoreItemDetailsVCDelegate
    func didPartItemUpdated() {
        self.objStoreHomePageViewModel.getCartListingsAPI()
    }
    
    func didWishListUpdated() {
        self.objStoreHomePageViewModel.getCustomerWishListAPICall()
    }
    
    
    func didRecieveemailpassResponse(response: UserRegisterWrapper) {
        print("Received Token: \(response.token ?? "nil")") // Debugging

        // Check if token exists before storing it
        guard let token = response.token, !token.isEmpty else {
            print("Error: Token is nil or empty")
            return
        }
        self.objStoreHomePageViewModel.getCustomerInfo()
       // UserDefaultsManager.storeEmailPassToken(value: token)
    }
    
    func didRecieveemailpassError(error: String) {
        print("Error Email Pass: ", error)
    }
    
    
    //MARK: - OrderFavouritesCellDelegate
    func didClickedBtnOrder() {
        let objController = StoreOrderDetailsVC.init(nibName: "StoreOrderDetailsVC", bundle: nil)
        
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    func didClickedBtnFavourite() {
        let objController = StoreShowAllProductVC.init(nibName: "StoreShowAllProductVC", bundle: nil)
        objController.strIsComeFrom = "FAVOURITES"
        objController.listProducts = self.listProducts.filter { $0.isLiked == true }
        objController.listCategories = self.listProductCategories
        
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    //MARK: - StoreShopCartVCDelegate
    func didUpdatedCart() {
        self.objStoreHomePageViewModel.getCartListingsAPI()
        self.objStoreHomePageViewModel.getProductListAPI()
    }
    
   
   
    func didReceiveEditProfileResponse(objResponse: BaseResponse<Profile>) {
        print("Edit profile response success")
    }
    
    func didReceiceEditProfileError(strError: String) {
        print("Edit profile response error")
    }
    
   
    //MARK: - EditAddressPopUpViewControllerDelegate
    
    //Select Default Address
    func didSelectadress(objAddress: StoreAddress?) {
        self.objSelectedAddress = objAddress ?? StoreAddress()
        self.lblAddress.text = "\(objAddress?.address_1 ?? "")\(objAddress?.address_2 ?? ""),\(objAddress?.city ?? ""),\(objAddress?.province ?? "")\(objAddress?.postal_code ?? "")"
        self.lblAdressType.text = objAddress?.address_name ?? ""
        
        self.objUserProfile.address = objAddress?.address_1 ?? ""
        self.objUserProfile.city = objAddress?.city ?? ""
        self.objUserProfile.pincode = objAddress?.postal_code ?? ""
        
        self.objEditProfileViewModel.updateShopAddressAPI(objProfile: self.objUserProfile)
    }
    

    func didAddressUpdated() {
       // self.objEditProfileViewModel.updateShopAddressAPI(objProfile: <#T##UserProfileModel.Profile?#>)
        
        
        DispatchQueue.main.async {

            let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                
            objController.isComeFrom = "AddressUpdated"
            //objController.delegate = self
          
            let popup = STPopupController.init(rootViewController: objController)
            popup.present(in: self)
            
        }
        
        self.objStoreHomePageViewModel.getCustomerInfo()
    }
    
    //MARK: - SelectAdressPopUpViewControllerDelegate
    func didChangesAdress(objAddress: StoreAddress?) {
        print("Open Edit address screen")
        DispatchQueue.main.async {
            let objController = EditAddressPopUpViewController(nibName: "EditAddressPopUpViewController", bundle: nil)
            objController.delegate = self
            objController.objEditAddressSave = objAddress ?? StoreAddress()

    //        objController.objAddress = self.objCustomerInfo.addresses ??  [StoreAddress]()
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    
    func didAddAddress() {
        DispatchQueue.main.async {
            let objController = EditAddressPopUpViewController(nibName: "EditAddressPopUpViewController", bundle: nil)
            objController.delegate = self
            objController.isComeFrom = "Add_Address"
    //        objController.objAddress = self.objCustomerInfo.addresses ??  [StoreAddress]()
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
     
    func didAddressDeleted() {
        self.objStoreHomePageViewModel.getCustomerInfo()
        DispatchQueue.main.async {

            let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                
            objController.isComeFrom = "AddressDeleted"
            //objController.delegate = self
          
            let popup = STPopupController.init(rootViewController: objController)
            popup.present(in: self)
            
        }
    }
    
    
  
    
    //MARK: - StoreHomePageViewModelDelegate
    
    //Customer Info
    
    func didReceievCustomerInfoAPISuccess(objResponse: CustomerCreationWrapper) {
        print("Customer Info API Success")
        self.objCustomerInfo = objResponse.customer ?? CustomerCreate()
        
        if self.objCustomerInfo.addresses?.count ?? 0 > 0{
            let objAddress = self.objCustomerInfo.addresses?[0]
            
            self.lblAddress.text = "\(objAddress?.address_1 ?? "")\(objAddress?.address_2 ?? ""),\(objAddress?.city ?? ""),\(objAddress?.province ?? "")\(objAddress?.postal_code ?? "")"
        }
        else{
            self.lblAddress.text = "Please Select or Add address"
        }
       
        self.tableView.reloadData()
    }
    
    func didReceievGetCustomerInfoAPIError(strError: String) {
        //
    }
    
    
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper) {
        self.listProducts = objResponse.products ?? [Products]()

        if let products = objResponse.products {
            // Store only the first 6 in cpyListProducts
            let topProducts = Array(products.prefix(9))
            self.cpyListProducts = topProducts
        } else {
            self.cpyListProducts = [Products]()
        }

        if let products = objResponse.products {
            // Reverse and take first 6
            let reversedTopProducts = Array(products.reversed().prefix(6))
            self.newBrandList = reversedTopProducts
        } else {
            self.newBrandList = [Products]()
        }
        
        print("Product list count: ", self.cpyListProducts.count)

        self.objStoreHomePageViewModel.getCustomerWishListAPICall()
        self.tableView.reloadData()
    }
    
    func didRecieveBrandListResponse(objWrapper: ProductCollectionsWrapper?) {
        self.lisBrand = objWrapper?.collections ?? [ProductCollection]()
        if let brands = objWrapper?.collections {
            // Store only the first 6 in cpyListProducts
            let topProducts = Array(brands.prefix(6))
            self.cpyLisBrand = topProducts
        } else {
            self.cpyLisBrand = [ProductCollection]()
        }

        
        self.tableView.reloadData()
    }
    
    func didRecieveBrandListError(error: String) {
        //
    }

    
    func didReceievGetProductListAPIError(strError: String) {
        print(strError)
    }
    
    //Product categories
    func didReceievGetProductCategoriesAPISuccess(objResponse: ProductcategoryWrapper) {
        
       
        for objCategory in objResponse.categories ?? [] {
            if (Utility.isEmpty(objCategory.parent_category_id ?? "") ){
                
                self.listProductCategories.append(objCategory)
            }
            else{
                self.listPeriodessentials.append(objCategory)
            }
        }
        
        print("self.listProductCategories.count", self.listProductCategories.count)
        
       // self.listProductCategories = objResponse.product_categories ?? [StoreProductCategories]()
        self.tableView.reloadData()
    }
    
    func didReceievGetProductcategoriesAPIError(strError: String) {
        print(strError)
    }
    
    //Get cart listings
    func didReceievGetCartListAPISuccess(objResponse: CreateCart) {
        print("Cart List Called successfully")
        self.objCartItems = objResponse.cart ?? CreateCartDetails()
        self.listCartItems = self.objCartItems.items ?? [CartItems]()
        self.lblCartCount.text = "\(self.objCartItems.items?.count ?? 0)"
        
        
        for listCart in self.listCartItems{
            
            for listProd in self.cpyListProducts{
                
                if listCart.product_id == listProd.id{
                    print("Product id matches")
                    listProd.prodQuantity = listCart.quantity
                }
            }
            
        }
        
        self.tableView.reloadData()
    }
    
    func didReceievGetcartListAPIError(strError: String) {
        print("Cart list error: ",strError)
    }
    
    //adding product to carts
    func didReceievAddItemToCartAPISuccess(objResponse: CreateCart) {
        self.objStoreHomePageViewModel.getCartListingsAPI()
        self.tableView.reloadData()
    }
    
    func didReceievAddItemToCartAPIError(strError: String) {
        print("Add product to cart error: ",strError)
    }
    
    
    //removing or substracting quantity from carts
    func didReceievRemoveItemFromCartAPISuccess(objResponse: RemoveItem) {
        self.objStoreHomePageViewModel.getCartListingsAPI()
        self.tableView.reloadData()
    }
    
    
  

    //get wishlist listings
    func didRecieveGetWishListResponse(response: WishListWrapper) {
        print("wishList API success: ", response.wishlist?.items?.count ?? 0)
        self.listWishList = response.wishlist ?? CreateCustomerWishList()
        
        print("prodlist count  ", self.listProducts.count)

        let wishListProductIDs = Set(self.listWishList.items?.compactMap { $0.product_variant_id } ?? [])

        for prodList in self.listProducts {
            let variantID = prodList.variants?.first?.id ?? ""
            prodList.isLiked = wishListProductIDs.contains(variantID)
        }

        self.tableView.reloadData()
    }

    
    func didRecievegetWishListError(error: String) {
        print("wishList API error")
    }
    
    
    
    
    //MARK: - StoreMostPurchaseTblCellDelegate
    
    //call the product api
    func didUpdateProductQuantity(objproduct: Products?, strType: String?) {
       
        
        if strType == "Add"{
            objproduct?.prodQuantity  = (objproduct?.prodQuantity ?? 0) + 1
            
            self.objStoreHomePageViewModel.addItemsToCart(strVariantID: objproduct?.variants?[0].id ?? "", quantity: 1)
            
        }
        else{
            if (objproduct?.prodQuantity ?? 1 > 1) {
                objproduct?.prodQuantity = (objproduct?.prodQuantity ?? 0) - 1

                self.objStoreHomePageViewModel.removeItemsFromCart(strItemID: objproduct?.variants?[0].id ?? "", quantity: objproduct?.prodQuantity)
            }
            else if (objproduct?.prodQuantity == 1){
                objproduct?.prodQuantity = 0
                for list in self.listCartItems{
                    if list.product_id == objproduct?.id ?? ""{
                        self.objStoreHomePageViewModel.deleteItemsFromCart(strItemID: list.id ?? "")
                    }
                }
            }
        }
        
        if let objproduct = objproduct {
            for i in 0..<(self.cpyListProducts.count) {
                if self.cpyListProducts[i].id == objproduct.id {
                    self.cpyListProducts[i] = objproduct
                }
            }
        }
        self.objStoreHomePageViewModel.getCartListingsAPI()
        self.objStoreHomePageViewModel.getProductListAPI()
        
       // self.tableView.reloadData()
    }
    
   

    func didOpenAllRecentSearches() {
        let objController = StoreShowAllProductVC.init(nibName: "StoreShowAllProductVC", bundle: nil)
        objController.delegate = self
        objController.objCustomerInfo = self.objCustomerInfo
        objController.objSelectedAddress = self.objSelectedAddress
        objController.listProducts = self.listProducts
        objController.listCategories = self.listProductCategories
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    func openProductDetailView(objProduct: Products?) {
        print("Open product detail view")
        let objController = StoreItemDetailsVC.init(nibName: "StoreItemDetailsVC", bundle: nil)
        objController.delegate = self
        objController.objProduct = objProduct
         ?? Products()
        objController.listAddress = self.objCustomerInfo.addresses ??  [StoreAddress]()
        objController.objSelectedAddress = self.objSelectedAddress
        self.navigationController?.pushViewController(objController, animated: true)

    }
    
   
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.showAllProductList == false{
            return 7
        }
        else{
            return 7
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 1{
            
            var cell: StoreCategoriesTblCell? = tableView.dequeueReusableCell(withIdentifier: "StoreCategoriesTblCell") as! StoreCategoriesTblCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreCategoriesTblCell", owner: self, options: nil)?.last as? StoreCategoriesTblCell)
            }
            
            cell?.delegate = self
            cell?.configureStoreCategoriesTblCell(listProductCategories: self.listProductCategories)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 2{
            
            var cell: OrderFavouritesCell? = tableView.dequeueReusableCell(withIdentifier: "OrderFavouritesCell") as! OrderFavouritesCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("OrderFavouritesCell", owner: self, options: nil)?.last as? OrderFavouritesCell)
            }
            
            cell?.delegate = self
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 3{
            
            var cell: StoreBrandCell? = tableView.dequeueReusableCell(withIdentifier: "StoreBrandCell") as! StoreBrandCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreBrandCell", owner: self, options: nil)?.last as? StoreBrandCell)
            }
            
            cell?.delegate = self
            cell?.configureStoreBrandCell(listBrand: self.cpyLisBrand)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 4{
            
            var cell: StoreMostPurchaseTblCell? = tableView.dequeueReusableCell(withIdentifier: "StoreMostPurchaseTblCell") as! StoreMostPurchaseTblCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreMostPurchaseTblCell", owner: self, options: nil)?.last as? StoreMostPurchaseTblCell)
            }
            cell?.delegate = self
            cell?.confgureStoreMostPurchaseTblCell(listProducts: self.cpyListProducts, listCartItems: self.listCartItems)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 5{
            
            var cell: StoreNewBrandCell? = tableView.dequeueReusableCell(withIdentifier: "StoreNewBrandCell") as! StoreNewBrandCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreNewBrandCell", owner: self, options: nil)?.last as? StoreNewBrandCell)
            }
            
            cell?.configureStoreNewBrandCell(listProducts: self.newBrandList)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 6{
            
            var cell: PeriodEssentialsCell? = tableView.dequeueReusableCell(withIdentifier: "PeriodEssentialsCell") as! PeriodEssentialsCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("PeriodEssentialsCell", owner: self, options: nil)?.last as? PeriodEssentialsCell)
            }
            
            cell?.delegate = self
            cell?.configurePeriodEssentialsCell(listPeriodEssentials: self.listPeriodessentials)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 7{
            
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 3{
//            let objController = StoreItemDetailsVC.init(nibName: "StoreItemDetailsVC", bundle: nil)
//            
//            self.navigationController?.pushViewController(objController, animated: true)
//        }
//    }
//    
    
}
