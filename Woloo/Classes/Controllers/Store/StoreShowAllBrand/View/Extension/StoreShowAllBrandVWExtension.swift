//
//  StoreShowAllBrandVWExtension.swift
//  Woloo
//
//  Created by CEPL on 15/04/25.
//

import Foundation
import UIKit
import STPopup

extension StoreShowAllBrandVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AllProductsCollectionCellDelegate, StoreHomePageViewModelDelegate, StoreShopCartVCDelegate, SelectAdressPopUpViewControllerDelegate, EditAddressPopUpViewControllerDelegate, StoreShowAllProductVCDelegate, DelegateForStoreAddressProtocol{
    
    
    
    func didRecieveCreateWishList(response: WishListWrapper) {
        //
    }
    
    func didRecieveCreateWishListError(error: String) {
        //
    }
    
    
    
    //MARK: - DelegateForStoreAddressProtocol
    func didSearchedPlace(strBuildingName: String?, strLocality: String?, strCity: String?, strState: String?, strPincode: String?, strFullAddress: String?) {
        self.objSelectedAddress.flatName = strBuildingName
        self.objSelectedAddress.locality = strLocality
        self.objSelectedAddress.city = strCity
        self.objSelectedAddress.state = strState
        self.objSelectedAddress.province = strState
        self.objSelectedAddress.postal_code = strPincode
        self.objSelectedAddress.address_1 = strFullAddress
        let objController = EditAddressPopUpViewController(nibName: "EditAddressPopUpViewController", bundle: nil)
        objController.delegate = self
        objController.isComeFrom = "Add_Address"
        objController.objEditAddressSave = self.objSelectedAddress

//        objController.objAddress = self.objCustomerInfo.addresses ??  [StoreAddress]()
        let popup = STPopupController(rootViewController: objController)
        popup.style = .bottomSheet
        popup.present(in: DELEGATE.window?.rootViewController ?? self)
        
    }
    
    
    //MARK: - DelegateForStoreAddressProtocol
    
    
    func didSearchAdressFromaAddAddress() {
        let objController = SearchLocationsViewController.init(nibName: "SearchLocationsViewController", bundle: nil)
        objController.delegateForStoreAddress = self
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    
    func addressUpdated(objAddress: StoreAddress?) {
        self.objSelectedAddress = objAddress ?? StoreAddress()
        self.lblAddress.text = "\(objAddress?.address_1 ?? "")\(objAddress?.address_2 ?? ""),\(objAddress?.city ?? ""),\(objAddress?.province ?? "")\(objAddress?.postal_code ?? "")"
        self.lblAdressType.text = objAddress?.address_name ?? ""
        
        if self.delegate != nil {
            self.addressUpdated(objAddress: objAddress)
        }
    }
    
  
    
    
    //MARK: - StoreShowAllProductVCDelegate
    func didChangeValues() {
        self.objStoreHomePageViewModel.getProductListAPI()
        self.objStoreHomePageViewModel.getCartListingsAPI()
    }
    
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
        if let objAddress = objAddress {
            UserDefaultsManager().saveAddressToUserDefaults(objAddress)
            
        }
        if self.delegate != nil{
            self.delegate?.addressUpdated(objAddress: self.objSelectedAddress)
        }
    }
    
    //MARK: - StoreShopCartVCDelegate
    func didUpdatedCart() {
        self.objStoreHomePageViewModel.getCartListingsAPI()
    }
    
    //MARK: - StoreHomePageViewModelDelegate
    func didReceievCustomerInfoAPISuccess(objResponse: CustomerCreationWrapper) {
        self.objCustomerInfo = objResponse.customer ?? CustomerCreate()
    }
    
    func didReceievGetCustomerInfoAPIError(strError: String) {
        //
    }
    
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper) {
        //
    }
    
    func didReceievGetProductListAPIError(strError: String) {
        //
    }
    
    func didReceievGetProductCategoriesAPISuccess(objResponse: ProductcategoryWrapper) {
        //
    }
    
    func didReceievGetProductcategoriesAPIError(strError: String) {
        //
    }
    
    func didReceievGetCartListAPISuccess(objResponse: CreateCart) {
        self.objCartItems = objResponse.cart ?? CreateCartDetails()
        self.listCartItems = self.objCartItems.items ?? [CartItems]()
        self.lblCartCount.text = "\(self.objCartItems.items?.count ?? 0)"
    }
    
    func didReceievGetcartListAPIError(strError: String) {
        //
    }
    
    func didReceievAddItemToCartAPISuccess(objResponse: CreateCart) {
        //
    }
    
    func didReceievAddItemToCartAPIError(strError: String) {
        //
    }
    
    func didReceievRemoveItemFromCartAPISuccess(objResponse: RemoveItem) {
        //
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
        self.listBrands = objWrapper?.collections ?? [ProductCollection]()
        self.collectionview.reloadData()
    }
    
    func didRecieveBrandListError(error: String) {
        //
    }
    
    func didRecieveRestockSubscriptionsAPIResponse(objWrapper: ListWrapperRestock<[RestockSubscriptions]>) {
        self.showToast(message: "Notified")
        self.objStoreHomePageViewModel.getBrandCollectionList()
    }
    
    func didRecieveRestockSubscriptionsError(error: String) {
        print("Restock Error", error)
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
            return self.listBrands.count
        }
        else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllProductsCollectionCell.identifier, for: indexPath) as? AllProductsCollectionCell ?? AllProductsCollectionCell()
            //fillCategoryCell(cell,indexPath.item)
            cell.lblTitle.text = "All Brands"
            cell.delegate = self
            return cell
        }
        else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreBrandCollectionViewCell.identifier, for: indexPath) as? StoreBrandCollectionViewCell ?? StoreBrandCollectionViewCell()
            
            cell.configureStoreBrandCollectionViewCell(objBrand: self.listBrands[indexPath.item])
//            cell.delegate = self
//            cell.configureAllProductCollectionCell(objProducts: self.listProducts[indexPath.row])
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreBlankHeaderCollectionCell.identifier, for: indexPath) as? StoreBlankHeaderCollectionCell ?? StoreBlankHeaderCollectionCell()
            //fillCategoryCell(cell,indexPath.item)
            cell.heightConstraint.constant = 61
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2{
            print("Clicked on branc collection id: ", self.listBrands[indexPath.item].id ?? "")
            let objController = StoreShowAllProductVC.init(nibName: "StoreShowAllProductVC", bundle: nil)
            objController.delegate = self
            objController.objSelectedAddress = self.objSelectedAddress
            objController.strIsComeFrom = "BRANDS"
            objController.listCategories = self.listCategories
            objController.objBrands = self.listBrands[indexPath.item]
            
            self.navigationController?.pushViewController(objController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 2{
            return CGSize(width: self.collectionview.frame.width/3, height: 126)
        }
        else if indexPath.section == 1{
            return CGSize(width: self.collectionview.frame.width, height: 53)
        }
        else{
            return CGSize(width: self.collectionview.frame.width/2, height: 61)
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

