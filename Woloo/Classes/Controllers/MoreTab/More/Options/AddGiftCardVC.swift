//
//  AddGiftCardVC.swift
//  Woloo
//
//  Created on 15/06/21.
//

import UIKit
import Razorpay
import Alamofire


class AddGiftCardVC: UIViewController {
    
    @IBOutlet weak var point100Button: UIButton!//tag 0
    @IBOutlet weak var point500Button: UIButton!//tag 1
    @IBOutlet weak var point1000Button: UIButton!//tag 2
    @IBOutlet weak var pointsManuallyText: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var vwPaymentSuccess: UIView!
    var amount: Int?
//    var mobileNumber: String?
//    var message: String?
    var razorPay: RazorpayCheckout!
    var netcoreEvents = NetcoreEvents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        pointsManuallyText.delegate = self
        mobileNumberTextField.delegate = self
        messageTextField.delegate = self
        //messageTextField.text = "Add Message"
       // messageTextField.textColor = UIColor.lightGray
        
        print("Razorpay test key: \(UserDefaultsManager.fetchAppConfigData()?.RZ_CRED?.key ?? "")")
        
        razorPay = RazorpayCheckout.initWithKey(UserDefaultsManager.fetchAppConfigData()?.RZ_CRED?.key ?? "", andDelegateWithData: self)
    }
}

// MARK: - Action's
extension AddGiftCardVC {
    @IBAction func okayPaymentSuccessAction(_ sender: Any) {
        vwPaymentSuccess.isHidden = true
        self.navigationController?.popViewController(animated: true)
        DELEGATE.rootVC?.tabBarVc?.showTabBar()
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pointsAction(_ sender: UIButton) {
        self.point100Button.setBackgroundImage(point100Button.tag == sender.tag ? UIImage(named: "yellowPointbg") : UIImage(named: "pointBg"), for: .normal)
        self.point500Button.setBackgroundImage(point500Button.tag == sender.tag ? UIImage(named: "yellowPointbg") : UIImage(named: "pointBg"), for: .normal)
        self.point1000Button.setBackgroundImage(point1000Button.tag == sender.tag ? UIImage(named: "yellowPointbg") : UIImage(named: "pointBg"), for: .normal)
        switch sender.tag {
        case 0:
            amount = 100
        case 1:
            amount = 500
        case 2:
            amount = 1000
        default:
            break
        }
        self.pointsManuallyText.text = "\(amount ?? 0)"
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
       
        if !(Int(amount ?? 0) > 0 ){
            showToast(message: "Amount should be greater than 0")
            return
        }
        if (mobileNumberTextField.text?.count ?? 0) != 10 {
            showToast(message: "Enter 10 digit mobile")
            return
        }
       
        if !((messageTextField.text?.count ?? 0) > 0) {
            showToast(message: "Enter message")
            return
        }
        
        //addCoinsAPI()
        addCoinsApiV2()
    }
}

// MARK: - UITextFieldDelegate
extension AddGiftCardVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == pointsManuallyText {
            amount = Int(pointsManuallyText.text ?? "0")
        }
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == pointsManuallyText {
            if let text = textField.text,
               let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,
                                                           with: string)
                self.point100Button.setBackgroundImage(UIImage(named: "pointBg"), for: .normal)
                self.point500Button.setBackgroundImage(UIImage(named: "pointBg"), for: .normal)
                self.point1000Button.setBackgroundImage(UIImage(named: "pointBg"), for: .normal)
                if updatedText == "100" {
                    self.point100Button.setBackgroundImage(UIImage(named: "yellowPointbg"), for: .normal)
                } else if updatedText == "500" {
                    self.point500Button.setBackgroundImage(UIImage(named: "yellowPointbg"), for: .normal)
                } else if updatedText == "1000" {
                    self.point1000Button.setBackgroundImage(UIImage(named: "yellowPointbg"), for: .normal)
                }
                amount = Int(updatedText)
            }
        }
        return true
    }
    
}

// MARK: - UITextViewDelegate
extension AddGiftCardVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add Message"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

// MARK: - API Calling
extension AddGiftCardVC {
    
    func addCoinsAPI() {
        Global.addFirebaseEvent(eventName: "gift_amount_selected", param: ["amount":amount ?? 0])
        Global.addNetcoreEvent(eventname: self.netcoreEvents.giftAmountSelected, param: ["amount":amount ?? 0])
        let param = ["coins": amount ?? 0,
                     "mobile": self.mobileNumberTextField.text ?? "",
                     "message": self.messageTextField.text ?? ""] as [String : Any]
        Global.showIndicator()
        APIManager.shared.addCoinsPurchase(param: param) { [weak self] (result, errorMessage) in
            Global.hideIndicator()
            guard let self = self else { return }
            if let id = result?.orderId {
                self.showPaymentForm(id: id)
            }
            
        }
    }
    
    func addCoinsApiV2(){
        Global.addFirebaseEvent(eventName: "gift_amount_selected", param: ["amount":amount ?? 0])
        Global.addNetcoreEvent(eventname: self.netcoreEvents.giftAmountSelected, param: ["amount":amount ?? 0])
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        var mobile = self.mobileNumberTextField.text ?? ""
        var message = self.messageTextField.text ?? ""
        var coins = amount ?? 0
        //MARK: Network Call
        
        let data = ["mobile": mobile, "coins": coins, "message": message] as [String : Any]
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        Global.showIndicator()
        NetworkManager(data: data, headers: headers, url: nil, service: .addCoins, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<AddCoinsModel>, Error>) in
            switch result{
            case .success(let response):
                print("Add coins response: ", response)
                
                Global.hideIndicator()
                if let id = response.results.order_id{
                    print("order id: \(id)")
                    self.showPaymentForm(id: id)
                }
            case .failure(let error):
                print("Add coins error: ", error)
                self.showToast(message: "User Not Found")
                Global.hideIndicator()
            }
            
        }
    }
}

// MARK: - RazorpayProtocol
extension AddGiftCardVC: RazorpayPaymentCompletionProtocolWithData {
    
    func showPaymentForm(id: String){
        print("received order id: \(id)")
        let options: [String:Any] = [
            "name": "Woloo",
            // "image": "https://s3.amazonaws.com/rzp-mobile/images/rzp.png",
            "currency": "INR",
            "description": "Send Points",
            "prefill": [
                "contact": UserDefaultsManager.fetchUserMob() ?? "",
                "email": "",
            ],
            "order_id": id,
            "amount": amount ?? 0
        ]

        print(options)
        DELEGATE.rootVC?.tabBarVc?.hideTabBar()
        razorPay.open(options, displayController: self)
    }
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("error: ", response)
        print("description: ", str)
        DELEGATE.rootVC?.tabBarVc?.showTabBar()
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("success response: ",response)
        print("success: ", payment_id)
        //self.showToast(message: result?.message ?? "")
        self.vwPaymentSuccess.isHidden = false
    }
    
}

