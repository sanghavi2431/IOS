//
//  StoreShopCartVWExtension.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import Foundation
import UIKit
import STPopup
import Razorpay
import PassKit

extension StoreShopCartVC: UITableViewDelegate, UITableViewDataSource, OrderSummaryPopUpVCDelegate, ShopCheckoutPopUpVCDelegate , StoreShopCartViewModelDeleagte, CartListCellDelegate, SelectAdressPopUpViewControllerDelegate, EditAddressPopUpViewControllerDelegate, RazorpayPaymentCompletionProtocolWithData, RedeemWolooCellDelegate, CartPromoCodeCellDelegate, WolooAlertPopUpViewDelegate{
    
    //MARK: - WolooAlertPopUpViewDelegate
    func closePopUp() {
        //
    }
    
    
   
    //MARK: - RedeemWolooCellDelegate
    func didClickedApplyPointsBtn() {
        Global.showIndicator()
        self.objStoreShopCartViewModel.applyPromotionsAPI(strPromotionCode: "WOLOO_COINS", strCartID: UserDefaultsManager.fetchUserCartID())
    }
    
    func didPromocodeEntered(strPromocode: String) {
        self.objStoreShopCartViewModel.applyPromotionsAPI(strPromotionCode: strPromocode, strCartID: UserDefaultsManager.fetchUserCartID())
    }
    

    //MARK: - RazorpayPaymentCompletionProtocolWithData

    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("success: ", payment_id)
        
        self.objStoreShopCartViewModel.completeCart(strCartID: UserDefaultsManager.fetchUserCartID())
        DispatchQueue.main.async {

            let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                
            objController.isComeFrom = "OrderPlaced"
            objController.delegate = self
          
            let popup = STPopupController.init(rootViewController: objController)
            popup.present(in: self)
            
        }
        
        
//        self.objStoreShopCartViewModel.completevendor(strCartID: UserDefaultsManager.fetchUserCartID())
//        
        self.objStoreShopCartViewModel.ecomCoinUpdateAPI(strOrderID: UserDefaultsManager.fetchOrderID())
    }
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("error: ", code)
        
        self.objStoreShopCartViewModel.deletePaymentSessionsAPI(strPaymentSessionID: self.objPaymentSessionID)
    }
    
    
    func didRecieveDeletePaymentSessionAPI(objWrapper: DeletePaymentSessionWrapper) {
        print("payment session deleted")
    }
    
    func didRecieveDeletePaymentSessionErrorAPI(error: String) {
        print("payment session errorr")
    }
    
    //ecomcoinupdate api success
    func didReceievEcomCoinUpdateAPISuccess(objResponse: BaseResponse<StatusSuccessResponseModel>) {
        print("ecomcoinupdate api success")
    }
    
    func didReceievEcomCoinUpdateAPIAPIError(strError: String) {
        print("ecomcoinupdate api error")
    }
    
   
    
    
    //MARK: - EditAddressPopUpViewControllerDelegate
    func didAddressUpdated() {
      //  self.objStoreHomePageViewModel.getCustomerInfo()
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
        //
    }
    
    func didAddressDeleted() {
        //
    }
    
    
    func showPaymentForm(id: String) {
        
        let userInfo = UserDefaultsManager.fetchUserData()
        
        let options: [String:Any] = [
            "order_id": id,
            "name": "Woloo Store",
            // "image": "https://s3.amazonaws.com/rzp-mobile/images/rzp.png",
            "currency": "INR",
            "description": "Store ID",
            "prefill": [
                "contact": String(userInfo?.profile?.mobile ?? 0),
                "email": userInfo?.profile?.email ?? "",
            ],
        ]
        //        DELEGATE.rootVC?.tabBarVc?.hideTabBar()
        razorpay.open(options, displayController: self)
    }
    
    func didSelectadress(objAddress: StoreAddress?) {
        self.objSelectedAddress = objAddress ?? StoreAddress()
        self.tableView.reloadData()
        
        self.objStoreShopCartViewModel.setShippingAndBillingAddressAPI(strCartId: UserDefaultsManager.fetchUserCartID(), objAddress: self.objSelectedAddress)
        
        DispatchQueue.main.async {
            let objController = OrderSummaryPopUpVC(nibName: "OrderSummaryPopUpVC", bundle: nil)
            objController.delegate = self
            objController.objSelectedAddress = objAddress ?? StoreAddress()
            objController.objCartItems = self.objCartItems
            objController.listAddress = self.listAddress
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    
    
    //MARK: - CartListCellDelegate
    func didUpdateProductQuantity(objCartItems: CartItems?, strType: String?) {
        if strType == "Add"{
            objCartItems?.quantity = (objCartItems?.quantity ?? 0) + 1
            self.objStoreShopCartViewModel.addItemsToCart(strVariantID: (objCartItems?.variant_id ?? ""), quantity: 1)
        }
        else{
            
            if ( objCartItems?.quantity ?? 1 > 1) {
                objCartItems?.quantity = (objCartItems?.quantity ?? 1) - 1
                
                self.objStoreShopCartViewModel.removeItemsFromCart(strItemID: objCartItems?.id ?? "", quantity: objCartItems?.quantity)
            }
            else if (objCartItems?.quantity == 1){
                self.objStoreShopCartViewModel.deleteItemsFromCart(strItemID: objCartItems?.id ?? "")
                if self.delegate != nil {
                    self.delegate?.didUpdatedCart()
                }
            }
            
        }
        
        
        
        if let objproduct = objCartItems {
            for i in 0..<(self.objCartItems.items?.count ?? 0) {

                if self.objCartItems.items?[i].id == objproduct.id {
                    self.objCartItems.items?[i] = objproduct
                }
                
            }
        }
       
        self.tableView.reloadData()
    }
    
    func didDeleteFromCart(objCartItems: CartItems?) {
    
        self.objStoreShopCartViewModel.deleteItemsFromCart(strItemID: objCartItems?.id ?? "")
        if self.delegate != nil {
            self.delegate?.didUpdatedCart()
        }
        
    }
    
    
    
    func didReceievGetCartListAPISuccess(objResponse: CreateCart) {
        
        self.objCartItems = objResponse.cart ?? CreateCartDetails()
        if self.objCartItems.items?.count ?? 0 > 0{
            self.tableView.isHidden = false
            self.vwBottom.isHidden = false
        }
        else{
            self.tableView.isHidden = true
            self.vwBottom.isHidden = true
        }
        
        Global.hideIndicator()
        self.tableView.reloadData()
    }
    
    func didReceievGetcartListAPIError(strError: String) {
        //
    }
    
    func didReceievAddItemToCartAPISuccess(objResponse: CreateCart) {
        self.objStoreShopCartViewModel.getCartListingsAPI()
        
        if self.delegate != nil {
            self.delegate?.didUpdatedCart()
        }
    }
    
    func didReceievAddItemToCartAPIError(strError: String) {
        //
    }
    
    func didReceievRemoveItemFromCartAPISuccess(objResponse: RemoveItem) {
        self.objStoreShopCartViewModel.getCartListingsAPI()
        if self.delegate != nil {
            self.delegate?.didUpdatedCart()
        }
    }
    
    //did set shipping and billing address
    func didRecieveSetShippingAndBillingAddressAPISuccess(objResponse: CreateCart) {
        print("Shipping And billing address set: \(objResponse)")
        
    }
    
    func didReceievSetShippingAndBillingAddressAPIError(strError: String) {
        print("Set shipping and billing address error: \(strError)")
    }
    
    func didRecieveGetShippingOptionsAPISuccess(objResponse: ShippingOptionsWrapper) {
        self.objShippingOptions = objResponse.shipping_options ?? [ShippingOptions]()
        
        //self.objStoreShopCartViewModel.calculateShippingOptionsAPI(strCartID: UserDefaultsManager.fetchUserCartID(), strOptionsID: self.objShippingOptions[0].id ?? "")
        if self.objShippingOptions.count > 0{
            print("self.objShippingOptions[0].id ??", self.objShippingOptions[0].id ?? "")
            self.objStoreShopCartViewModel.selectShippingMethodsAPI(strCartId: UserDefaultsManager.fetchUserCartID(), strOptionId: self.objShippingOptions[0].id ?? "")
        }
       
        
        
        self.tableView.reloadData()
        
    }
    
    func didReceievGetShippingOptionsAPIPIError(strError: String) {
        //
    }
    
    
    func didRecieveSelectShippingMethodAPISuccess(objResponse: CreateCart) {
        self.objSelectShippingOption = objResponse.cart ?? CreateCartDetails()
        print("Select shipping options: \(objResponse)")
        
        self.tableView.reloadData()
    }
    
    func didRecieveSelectShippingMethodError(strError: String) {
        //
    }
    
    
    func didRecieveCalculateShippingOptionsAPISuccess(response: CalculateShippingOptionWrapper) {
        print("Calculate shipping options: \(response)")
        self.objCalculateShippingOption = response.shipping_option ?? ShippingOptions()
        self.objCartItems.deliveryCharges = self.objCalculateShippingOption.amount ?? 0.0
        
       
    }
    
    func didRecieveCalculateShippingOptionsAPIError(error: String) {
        print("Calculate shipping options: error: ")
    }
    
    //MARK: - ShopCheckoutPopUpVCDelegate
    func didClickedReviewOrder() {
        DispatchQueue.main.async {
            let objController = OrderSummaryPopUpVC(nibName: "OrderSummaryPopUpVC", bundle: nil)
            objController.delegate = self
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    //Get payment methods API
    func didRecievePaymentProviderAPISuccess(objResponse: PaymentProviderWrapper) {
        Global.hideIndicator()
        self.objPaymentProviderWrapper = objResponse
        
        print("payment_providers id", objResponse.payment_providers?[0].id ?? "")
        self.tableView.reloadData()
        self.objStoreShopCartViewModel.paymentCollectionsAPI(strCartId: UserDefaultsManager.fetchUserCartID())
    }
    
    func didRecievePaymentProviderError(strError: String) {
        //
    }
    
    
    //Apply Promotions API
    func didRecieveApplyPromotionsAPI(objWrapper: CreateCart) {
        Global.hideIndicator()
        self.objCartItems = objWrapper.cart ?? CreateCartDetails()
        
        DispatchQueue.main.async {

            let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                
            objController.isComeFrom = "CoinsApplied"
            objController.delegate = self
          
            let popup = STPopupController.init(rootViewController: objController)
            popup.present(in: self)
            
        }
        
        self.tableView.reloadData()
    }
    
    func didRecieveApplyPromotionErrorAPI(error: String) {
        Global.hideIndicator()
        //
    }
    

    
    //get payment collection ID
    func didRecievePaymentCollectionAPISuccess(objResponse: PaymentCollectionsWrapper?) {
        Global.hideIndicator()
        self.objPaymentCollectionId = objResponse?.payment_collection ?? PaymentCollections()
        
      
        
        self.tableView.reloadData()
       
    }
    
    func didRecievePaymentCollectionAPIError(strError: String) {
        //
    }
    
    //initialise payment session
    func didRecievePaymentSessionAPISuccess(objResponse: PaymentCollectionsWrapper) {
        Global.hideIndicator()
        print("objResponse: id", objResponse.payment_collection?.payment_sessions?[0].data?.id ?? "")
        self.objPaymentSessionID = objResponse.payment_collection?.payment_sessions?[0].id ?? ""
        
        self.showPaymentForm(id: objResponse.payment_collection?.payment_sessions?[0].data?.id ?? "")
        self.tableView.reloadData()
    }
    
    func didRecievePaymentSessionAPIError(strError: String) {
        //
    }
    
    
    func didRecieveCompleteCartAPISuccess(objResponse: CompleteCart) {
        print("complete order", objResponse.order?.id ?? "")
        let objController = StoreOrderDetailsVC.init(nibName: "StoreOrderDetailsVC", bundle: nil)
        objController.orderId = objResponse.order?.id ?? ""
        UserDefaultsManager.storeOrderID(value: objResponse.order?.id ?? "")
        
        self.objStoreShopCartViewModel.createCartAPI(strRegionID: "reg_01JPH693TAM20TXZEJNBJ5QBV4")
        self.navigationController?.pushViewController(objController, animated: true)
        
    }
    
    func didRecieveCompleteCartAPIError(strError: String) {
        print("complete cart error: \(strError)")
    }
    
    func didRecieveCreateResponse(response: CreateCart) {
        UserDefaultsManager.storeCartID(value: response.cart?.id ?? "")
        if self.delegate != nil {
            self.delegate?.didUpdatedCart()
        }
    }
    
    func didRecieveCreateCartError(error: String) {
        //
    }
    
    
    
    
    //MARK: - OrderSummaryPopUpVCDelegate
    //Open paymennt screen
    func didClickedPayViaBtn() {
        Global.showIndicator()
        self.objStoreShopCartViewModel.paymentSessionsAPI(strPayCollectionID: self.objPaymentCollectionId.id ?? "", strProviderId: self.objPaymentProviderWrapper.payment_providers?[0].id ?? "")
    }
    
    //Open Address PopUp
    func didClickedEditAddressCartBtn(objAddress: StoreAddress?) {
        DispatchQueue.main.async {
            
            let objController = SelectAdressPopUpViewController(nibName: "SelectAdressPopUpViewController", bundle: nil)
            objController.delegate = self
            objController.objSelectedAddress = objAddress ?? StoreAddress()
            objController.objAddress = self.objSelectedAddress
            objController.listAddress = self.listAddress
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

    
    //MARK: - UITableView Delegate and Datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return self.objCartItems.items?.count ?? 0
        }
        else if section == 2{
            return 2
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            if indexPath.row == 0{
                var cell: CartHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "CartHeaderCell") as! CartHeaderCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("CartHeaderCell", owner: self, options: nil)?.last as? CartHeaderCell)
                }
                
                cell?.configureCartHeaderCell()
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
           
        }else if indexPath.section == 1{
            var cell: CartListCell? = tableView.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("CartListCell", owner: self, options: nil)?.last as? CartListCell)
            }
            
            cell?.delegate = self
            cell?.configureCartListCell(objCartItems: self.objCartItems.items?[indexPath.row])
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 2{
            if indexPath.row == 0{
                
                var cell: RedeemWolooCell? = tableView.dequeueReusableCell(withIdentifier: "RedeemWolooCell") as! RedeemWolooCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("RedeemWolooCell", owner: self, options: nil)?.last as? RedeemWolooCell)
                }
                
                cell?.delegate = self
                cell?.configureCartPromoCodeCell(objCoins: self.objUserCoinModel)
                
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else{
                
                var cell: CartPromoCodeCell? = tableView.dequeueReusableCell(withIdentifier: "CartPromoCodeCell") as! CartPromoCodeCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("CartPromoCodeCell", owner: self, options: nil)?.last as? CartPromoCodeCell)
                }
                
                cell?.delegate = self
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }

        }
        else if indexPath.section == 3{
            var cell: CartTotalCell? = tableView.dequeueReusableCell(withIdentifier: "CartTotalCell") as! CartTotalCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("CartTotalCell", owner: self, options: nil)?.last as? CartTotalCell)
            }
            
            cell?.configureCartTotalCell(objcart: self.objCartItems)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 4{
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
        return UITableViewCell()
    }
    
}
