//
//  HygieneServicesHomePageVWExtension.swift
//  Woloo
//
//  Created by CEPL on 26/04/25.
//

import Foundation
import STPopup


extension HygieneServicesHomePageVC: UITableViewDelegate, UITableViewDataSource, HygieneServicesHomeViewModelDelegate, AllServicesTableCellDelegate, SelectAdressPopUpViewControllerDelegate, EditAddressPopUpViewControllerDelegate, DelegateForStoreAddressProtocol, EditProfileViewModelDelegate{
    
    //MARK: - EditProfileViewModelDelegate
    func didReceiveEditProfileResponse(objResponse: BaseResponse<Profile>) {
        print("Edit profile response success")
    }
    
    func didReceiceEditProfileError(strError: String) {
        print("Edit profile response error")
    }
    
    
    //MARK: DelegateForStoreAddressProtocol
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
    
    
    //MARK: - EditAddressPopUpViewControllerDelegate
    func didSelectadress(objAddress: StoreAddress?) {
        self.objSelectedAddress = objAddress ?? StoreAddress()
        self.lblAddress.text = "\(objAddress?.address_1 ?? "")\(objAddress?.address_2 ?? ""),\(objAddress?.city ?? ""),\(objAddress?.province ?? "")\(objAddress?.postal_code ?? "")"
        self.lblAdressType.text = objAddress?.address_name ?? ""
        
        self.objUserProfile.address = objAddress?.address_1 ?? ""
        self.objUserProfile.city = objAddress?.city ?? ""
        self.objUserProfile.pincode = objAddress?.postal_code ?? ""
        
        if let objAddress = objAddress {
            UserDefaultsManager().saveAddressToUserDefaults(objAddress)
            
        }
        
        self.objEditProfileViewModel.updateShopAddressAPI(objProfile: self.objUserProfile)
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
        //self.objStoreHomePageViewModel.getCustomerInfo()
        DispatchQueue.main.async {

            let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                
            objController.isComeFrom = "AddressDeleted"
            //objController.delegate = self
          
            let popup = STPopupController.init(rootViewController: objController)
            popup.present(in: self)
            
        }
    }
    
    func didAddressUpdated() {
        DispatchQueue.main.async {

            let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                
            objController.isComeFrom = "AddressUpdated"
            //objController.delegate = self
          
            let popup = STPopupController.init(rootViewController: objController)
            popup.present(in: self)
            
        }
        
        //self.objStoreHomePageViewModel.getCustomerInfo()
    }
    
    func didSearchAdressFromaAddAddress() {
        let objController = SearchLocationsViewController.init(nibName: "SearchLocationsViewController", bundle: nil)
        objController.delegateForStoreAddress = self
        self.navigationController?.pushViewController(objController, animated: true)
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
    
    
    //MARK: - AllServicesTableCellDelegate
    func didSelectAllServiceCategory(objCategory: StoreProductCategories?) {
        print("Call the product api for selected category: \(objCategory?.id ?? "")")
        self.objHygieneServicesHomeViewModel.getProductCategoryAPI(strCategoryId: objCategory?.id ?? "")
        self.tableView.reloadData()
    }
    
    //MARK: - Product Cat API
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper) {
        self.listProducts = objResponse.products ?? [Products]()
        print("product point list count: \(self.listProducts.count)")
        if self.listProducts.count > 1 {
            print("Go to listing screen")
        }
        else{
            print("Go to product details screen")
            
            if self.listProducts.count == 1{
                let objController = HygieneServiceDetailsVC.init(nibName: "HygieneServiceDetailsVC", bundle: nil)
                //objController.delegate = self
                objController.objProduct = self.listProducts[0]
    //            objController.listAddress = self.objCustomerInfo.addresses ??  [StoreAddress]()
    //            objController.objSelectedAddress = self.objSelectedAddress
                self.navigationController?.pushViewController(objController, animated: true)
            }
            else{
                showToast(message: "Something went wrong")
            }
            
           
        }
        
        self.tableView.reloadData()
    }
    
    func didReceievGetProductListAPIError(strError: String) {
        print("Get product details error: \(strError)")
    }
    
    //MARK: - HygieneServicesHomeViewModelDelegate
    func didReceievGetHygieneCategoriesAPISuccess(objResponse: ProductcategoryWrapper) {
        self.listServicesCategories.removeAll()
        self.categoriesVideosList.removeAll()

        for objCategory in objResponse.categories ?? [] {
            if let parentCategoryID = objCategory.parent_category_id,
               !parentCategoryID.isEmpty,
               let parentName = objCategory.parent_category?.name?.trimmingCharacters(in: .whitespacesAndNewlines),
               parentName.lowercased().contains("hygiene") {

                self.listServicesCategories.append(objCategory)

                // ✅ Collect video URL if available
                if let videoUrl = objCategory.metadata?.videos,
                   !videoUrl.isEmpty {
                    let item = TakeSneakPeekServiceItem(videoUrl: videoUrl)
                    self.categoriesVideosList.append(item)
                    print("✅ Video URL from metadata: \(videoUrl)")
                }
            }
        }

        self.tableView.reloadData()
    }
    
    func didReceievGetHygieneCategoriesAPIError(strError: String) {
        print(strError)
    }
   
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
            var cell: AllServicesTableCell? = tableView.dequeueReusableCell(withIdentifier: "AllServicesTableCell") as! AllServicesTableCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AllServicesTableCell", owner: self, options: nil)?.last as? AllServicesTableCell)
            }
            
            cell?.delegate = self
            cell?.configureAllServicesTableCell(listServiceCategories: self.listServicesCategories)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 2{
            var cell: ExpressBookingTblCell? = tableView.dequeueReusableCell(withIdentifier: "ExpressBookingTblCell") as! ExpressBookingTblCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("ExpressBookingTblCell", owner: self, options: nil)?.last as? ExpressBookingTblCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 3{
            var cell: TakeASneakPeakTblCell? = tableView.dequeueReusableCell(withIdentifier: "TakeASneakPeakTblCell") as! TakeASneakPeakTblCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("TakeASneakPeakTblCell", owner: self, options: nil)?.last as? TakeASneakPeakTblCell)
            }
            
            cell?.configureTakeASneakPeakTblCell(objVideo: categoriesVideosList)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        return UITableViewCell()
    }

}
