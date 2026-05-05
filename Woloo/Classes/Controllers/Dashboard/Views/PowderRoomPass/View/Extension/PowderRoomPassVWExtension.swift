//
//  PowderRoomPassVWExtension.swift
//  Woloo
//
//  Created by CEPL on 07/10/25.
//

import Foundation
import Razorpay
import STPopup

extension PowderRoomPassVC: UITableViewDelegate, UITableViewDataSource, BuyPassBtnCellDelegate, PowderRoomPassViewModelProtocol, RazorpayPaymentCompletionProtocolWithData, DashboardViewModelDelegate, PowderRoomPassCardDelegate{
   
    
    //MARK: - PowderRoomPassCardDelegate
    func didClickedContactHelp() {
        print("clicked contact support")
        print("call woloo support")

        self.sosBottomVW.isHidden = false
        
        self.isSOSOptionSelected = "Woloo"
        self.sosBottomVwTitlelbl.text = "Call Support"
        
    }
    
    
    //MARK: - DashboardViewModelDelegate
    func didReceievGetUserProfile(objResponse: BaseResponse<UserProfileModel>) {
        //
    }
    
    func didReceievGetUserProfileError(strError: String) {
        //
    }
    
    func didReceiveWahCertificateResponse(objResponse: BaseResponse<WahCertificate>) {
        Global.hideIndicator()
        self.openWahCerificateVC(store: objResponse.results)
    }
    
    func didReceiceWahCertificateError(strError: String) {
        Global.hideIndicator()
        self.showToast(message: strError)
    }
    
    func didReceiveCreditUserCoinsResponse(objResponse: CoinsWrapper) {
        //
    }
    
    func didReceiceCreditUserCoinsError(strError: String) {
        //
    }
    
    //MARK: - Open wah certificate
    func openWahCerificateVC(store: WahCertificate) {
        let vc = ScanHostReviewVC(nibName: "ScanHostReviewVC", bundle: nil)
      //vc.store = store
      vc.objWahCertificate = store
      self.navigationController?.pushViewController(vc, animated: true)
  }
    
    //MARK: - DashboardViewModelDelegate
    
    
    //MARK: RazorpayPaymentCompletionProtocolWithData
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        //
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        
        
        DispatchQueue.main.async {
            let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Okay", title: "Congratulations", message: UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.paymentSuccessDialogText ?? "", image: UIImage(named: "icon_check"), controller: self)
            alert.cancelTappedAction = {
                DispatchQueue.main.async{
                    Global.showIndicator()
                    self.wahCertificateAPICall()
                }
                alert.removeFromSuperview()
            }
            self.view.addSubview(alert)
            self.view.bringSubviewToFront(alert)
        }
        
        
        
    }
    
    
    func wahCertificateAPICall(){
        
        self.objDashboardViewModel.wahCertificateAPI(wolooID: UserDefaultsManager.fetchWahCode())
    }
    
    func showPaymentForm(id: String){
        print("received order id: \(id)")
        
        print("Contact info", UserDefaultsManager.fetchUserData()?.profile?.mobile ?? 0)
        let options: [String:Any] = [
            "name": "Woloo",
            // "image": "https://s3.amazonaws.com/rzp-mobile/images/rzp.png",
            "currency": "INR",
            "description": "One time pass",
            "prefill": [
                "contact": UserDefaultsManager.fetchUserData()?.profile?.mobile ?? 0,
                "email": "",
            ],
            "order_id": id,
            "amount": (UserDefaultsManager.fetchAppConfigData()?.powder_room_usage_charge ?? "0")
        ]

        print(options)
       // DELEGATE.rootVC?.tabBarVc?.hideTabBar()
        razorPay.open(options, displayController: self)
    }
    
    //MARK: - PowderRoomPassViewModelProtocol
    func didReceievPowderRoomPaymentSuccess(objResponse: BaseResponse<PowderRoomPass>) {
        print("open  razorpay")
        self.showPaymentForm(id: objResponse.results.order_id ?? "")
        
        
    }
    
    func didReceivePowderRoomPaymentError(strError: String) {
        print("unable to open razorpay")
    }

    
    
    //MARK: - BuyPassBtnCellDelegate
    func didClickedBuyPassbtn() {

        self.objPowderRoomPassViewModel.getpowderRoomPassPaymentID(powderRoomID: Int(UserDefaultsManager.fetchWahCode()), amount: Int(UserDefaultsManager.fetchAppConfigData()?.powder_room_usage_charge ?? "0"))
    }

    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            var cell: PowderRoomPassCardCell? = tableView.dequeueReusableCell(withIdentifier: "PowderRoomPassCardCell") as! PowderRoomPassCardCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("PowderRoomPassCardCell", owner: self, options: nil)?.last as? PowderRoomPassCardCell)
            }
            
            cell?.delegate = self
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 1{
            
            var cell: BuyPassBtnCell? = tableView.dequeueReusableCell(withIdentifier: "BuyPassBtnCell") as! BuyPassBtnCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("BuyPassBtnCell", owner: self, options: nil)?.last as? BuyPassBtnCell)
            }
            
            cell?.delegate = self
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else{
            
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            cell?.vwback.backgroundColor = .clear
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
    }

    
}
