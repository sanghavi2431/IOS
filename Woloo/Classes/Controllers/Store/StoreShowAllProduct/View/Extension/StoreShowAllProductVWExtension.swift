//
//  StoreShowAllProductVWExtension.swift
//  Woloo
//
//  Created by CEPL on 07/03/25.
//

import Foundation
import UIKit
import STPopup

extension StoreShowAllProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AllProductsCollectionCellDelegate, StoreMostPurchaseCollectionCellDelegate, StoreShowAllProductViewModelDelegate, StoreItemDetailsVCDelegate , StoreShopCartVCDelegate, StoreHomePageViewModelDelegate, SelectAdressPopUpViewControllerDelegate, EditAddressPopUpViewControllerDelegate {
    
    //MARK: - EditAddressPopUpViewControllerDelegate
    func didAddressUpdated() {
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
    }
    
    func didSelectadress(objAddress: StoreAddress?) {
        self.objSelectedAddress = objAddress ?? StoreAddress()
        self.lblAddress.text = "\(objAddress?.address_1 ?? "")\(objAddress?.address_2 ?? ""),\(objAddress?.city ?? ""),\(objAddress?.province ?? "")\(objAddress?.postal_code ?? "")"
        self.lblAdressType.text = objAddress?.address_name ?? ""
        
//        self.objUserProfile.address = objAddress?.address_1 ?? ""
//        self.objUserProfile.city = objAddress?.city ?? ""
//        self.objUserProfile.pincode = objAddress?.postal_code ?? ""
//        
//        self.objEditProfileViewModel.updateShopAddressAPI(objProfile: self.objUserProfile)
    }
    
    
    
    //MARK: - StoreHomePageViewModelDelegate
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
       
        self.collectionview.reloadData()
    }
    
    func didReceievGetCustomerInfoAPIError(strError: String) {
        //
    }
    
    func didReceievGetProductCategoriesAPISuccess(objResponse: ProductcategoryWrapper) {
        //
    }
    
    func didReceievGetProductcategoriesAPIError(strError: String) {
        //
    }
    
    func didReceievGetCartListAPISuccess(objResponse: CreateCart) {
        print("Cart List Called successfully")
        self.objCartItems = objResponse.cart ?? CreateCartDetails()
        self.listCartItems = self.objCartItems.items ?? [CartItems]()
        self.lblCartCount.text = "\(self.objCartItems.items?.count ?? 0)"
        
        for listCart in self.listCartItems{
            print("self.listProducts count", self.listProducts.count)
            for listProd in self.listProducts{
                print("listProd.id", listProd.id ?? "")
                print("listCart.product_id", listCart.product_id ?? "")
                if listCart.product_id == listProd.id{
                    print("Product id matches")
                    listProd.prodQuantity = listCart.quantity
                }
            }
            
        }
        
        
        self.collectionview.reloadData()
    }
    
    func didReceievGetcartListAPIError(strError: String) {
        print("Cart list error: ",strError)
    }
    
    func didReceievAddItemToCartAPISuccess(objResponse: CreateCart) {
        self.objStoreHomePageViewModel.getCartListingsAPI()
        if self.delegate != nil {
            self.delegate?.didChangeValues()
        }
       // self.collectionview.reloadData()
    }
    
    func didReceievAddItemToCartAPIError(strError: String) {
        //
    }
    
    func didReceievRemoveItemFromCartAPISuccess(objResponse: RemoveItem) {
        self.objStoreHomePageViewModel.getCartListingsAPI()
        if self.delegate != nil {
            self.delegate?.didChangeValues()
        }
        //self.collectionview.reloadData()
    }
    
    func didRecieveemailpassResponse(response: UserRegisterWrapper) {
        //
    }
    
    func didRecieveemailpassError(error: String) {
        //
    }
    
    func didRecieveGetWishListResponse(response: WishListWrapper) {
        //
    }
    
    func didRecievegetWishListError(error: String) {
        //
    }
    
    func didRecieveBrandListResponse(objWrapper: ProductCollectionsWrapper?) {
        //
    }
    
    func didRecieveBrandListError(error: String) {
        //
    }
    
    
  
    //MARK: - StoreShopCartVCDelegate
    func didUpdatedCart() {
        self.objStoreHomePageViewModel.getCartListingsAPI()
        
    }
    
    
   
    //MARK: - StoreItemDetailsVCDelegate
    func didPartItemUpdated() {
        self.objStoreHomePageViewModel.getCartListingsAPI()
    }
    
    func didWishListUpdated() {
        self.objStoreHomePageViewModel.getCustomerWishListAPICall()
    }
    
    
    
    //MARK: - StoreShowAllProductViewModelDelegate
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper) {
        self.listProducts = objResponse.products ?? [Products]()
        self.objStoreHomePageViewModel.getCartListingsAPI()
        self.collectionview.reloadData()
    }
    
    func didReceievGetProductListAPIError(strError: String) {
        //
    }
    
    
    //MARK: - StoreMostPurchaseCollectionCellDelegate
    func didUpdateProductQuantity(objproduct: Products?, strType: String?) {
        if strType == "Add"{
            objproduct?.prodQuantity  = (objproduct?.prodQuantity ?? 0) + 1
            
            self.objStoreHomePageViewModel.addItemsToCart(strVariantID: objproduct?.variants?[0].id ?? "", quantity: 1)
            
        }
        else{
            if (objproduct?.prodQuantity ?? 1 > 1) {
                objproduct?.prodQuantity = (objproduct?.prodQuantity ?? 0) - 1
                
                for list in self.listCartItems{
                    if list.product_id == objproduct?.id ?? ""{
                        print("remove item: ", list.id ?? "")
                        self.objStoreHomePageViewModel.removeItemsFromCart(strItemID: list.id ?? "", quantity: objproduct?.prodQuantity)
                    }
                }
                
                
            }
            else if (objproduct?.prodQuantity == 1){
                objproduct?.prodQuantity = 0
                for list in self.listCartItems{
                    if list.product_id == objproduct?.id ?? ""{
                        
                        print("Delete item: ", list.id ?? "")
                        
                        self.objStoreHomePageViewModel.deleteItemsFromCart(strItemID: list.id ?? "")
                    }
                }
            }
        }
        
        if let objproduct = objproduct {
            for i in 0..<(self.listProducts.count) {
                if self.listProducts[i].id == objproduct.id {
                    self.listProducts[i] = objproduct
                }
            }
        }
        
        //self.collectionview.reloadData()
        //self.objStoreHomePageViewModel.getCartListingsAPI()
        //self.objStoreHomePageViewModel.getProductListAPI()
    }
    
    func didWishlishedItem(objProduct: Products?, strType: String?) {
        //
    }
    
    
    
 
   
    //MARK: - AllProductsCollectionCellDelegate
    func didClickedBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UIcollection view delegate and datasource methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 2{
            return self.listProducts.count
        }
        else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllProductsCollectionCell.identifier, for: indexPath) as? AllProductsCollectionCell ?? AllProductsCollectionCell()
            //fillCategoryCell(cell,indexPath.item)
            cell.delegate = self
            return cell
        }
        else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreMostPurchaseCollectionCell.identifier, for: indexPath) as? StoreMostPurchaseCollectionCell ?? StoreMostPurchaseCollectionCell()
            cell.delegate = self
            cell.configureAllProductCollectionCell(objProducts: self.listProducts[indexPath.row], listCartItems: self.listCartItems)
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreBlankHeaderCollectionCell.identifier, for: indexPath) as? StoreBlankHeaderCollectionCell ?? StoreBlankHeaderCollectionCell()
            //fillCategoryCell(cell,indexPath.item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.section == 2){
            let objController = StoreItemDetailsVC.init(nibName: "StoreItemDetailsVC", bundle: nil)
            objController.delegate = self
            objController.objProduct = self.listProducts[indexPath.item]
            objController.listAddress = self.objCustomerInfo.addresses ??  [StoreAddress]()
            objController.objSelectedAddress = self.objSelectedAddress
            self.navigationController?.pushViewController(objController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 2{
            return CGSize(width: self.collectionview.frame.width/3, height: 200)
        }
        else if indexPath.section == 1{
            return CGSize(width: self.collectionview.frame.width, height: 53)
        }
        else{
            return CGSize(width: self.collectionview.frame.width/2, height: 128)
        }
       
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
}
