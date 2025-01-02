//
//  QRCodeScanViewController.swift
//  Woloo
//
//  Created by ideveloper1 on 24/04/21.
//

import UIKit
import WebKit
import Firebase
import swiftScan

class QRCodeScanViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupBg: UIView!
    @IBOutlet weak var lblSuccess: UILabel! //QRCodeScanningSuccessDialog
    var isScaned = false
    var netcoreEvent = NetcoreEvents()
    var objQRCodeScanViewMdoel = QRCodeScanViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //self.objQRCodeScanViewMdoel.delegate = self
        
        let controller = LBXScanViewController()
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.scanStyle?.colorRetangleLine = .yellow
        controller.scanStyle?.anmiationStyle = .LineMove
        controller.scanResultDelegate = self
        controller.isSupportContinuous = true
        containerView.addSubview(controller.view)
       // controller.handleCodeResult(arrayResult: [LBXScanResult.init(str: "", img: nil, barCodeType: nil, corner: [])])
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        controller.didMove(toParent: self)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - API Call Wah certificate
    
    func getWahCertificateAPICall(wolooId: String?){
        self.objQRCodeScanViewMdoel.wahCertificateAPI(wolooID: wolooId)
    }
     
}

// MARK: - Delegate
extension QRCodeScanViewController: LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        Global.addFirebaseEvent(eventName: "scan_qr_click", param:["result":scanResult.strScanned ?? ""])
        Global.addNetcoreEvent(eventname: self.netcoreEvent.scanQrClick, param: ["result":scanResult.strScanned ?? ""])
        
        
        if self.isScaned == false{
            self.isScaned = true
            print("Scan code: ",scanResult.strScanned ?? "")
            let fullUrl = scanResult.strScanned ?? ""
            let prefix = "https://woloo.page.link/?link="
            
            // Remove the prefix and any parameters
            if let cleanedUrl = fullUrl.replacingOccurrences(of: prefix, with: "").split(separator: "&").first {
                
                if cleanedUrl.contains("wahcertificate") {
                    
                    print("URL contains wahcertificate")
                    let code = cleanedUrl.split(separator: "/").last ?? "No code"
                    print("URL contains wahcertificate with code: \(code)")
                    UserDefaultsManager.storeWahCode(value: "\(code)")
                    NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["wahcertificate": "\(code)"])
                   self.navigationController?.popViewController(animated: true)
                    return
                } else if cleanedUrl.contains("voucher") {
                    print("URL contains voucher")
                    self.navigationController?.popViewController(animated: true)
                    return
                } else {
                    print("URL does not contain wahcertificate or voucher")
                    self.navigationController?.popViewController(animated: true)
                    return
                }
            }
        }
//        if isScaned == false {
//            isScaned = true
//            let urlString = scanResult.strScanned ?? ""
//            if let url = URL(string: urlString) {
//                let pathComponents = url.pathComponents
//                if pathComponents.contains("wahcertificate"), let codeIndex = pathComponents.last {
//                    print("Wahcertificate Code: \(codeIndex)")
//                }
//            }
//            callWebViewAndGetLongLink(scanResult.strScanned ?? "") { [weak self] longLink in
//                guard let weakSelf = self else { return }
//                guard let `longLink` = longLink else { return }
//                if longLink.contains("voucher") {
//                    let slashComponenets = longLink.components(separatedBy: "/")
//                    guard let getIndex = slashComponenets.firstIndex(where: { $0.lowercased() == "voucher"}) else { return }
//                    let voucher = slashComponenets[getIndex + 1]
//                    if UserModel.getAuthorizedUserInfo() == nil {
//                        UserDefaults.voucherCode = voucher
//                        return
//                    }
//                    UserDefaults.voucherCode = nil
//                    NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["voucher": voucher])
//                    weakSelf.navigationController?.popViewController(animated: true)
//                } else if longLink.contains("wahcertificate") {
//                    let slashComponenets = longLink.components(separatedBy: "/")
//                    guard let getIndex = slashComponenets.firstIndex(where: { $0.lowercased() == "wahcertificate"}) else { return }
//                    let voucher = slashComponenets[getIndex + 1]
//                    if UserModel.getAuthorizedUserInfo() == nil {
//                        UserDefaults.certificatCode = voucher
//                        return
//                    }
//                    UserDefaults.certificatCode = nil
//                    NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["wahcertificate": voucher])
//                    weakSelf.navigationController?.popViewController(animated: true)
//                }  else {
//                    weakSelf.scanWolooQR(name: scanResult.strScanned ?? "")
//                }
//            }
//        }
    }
}

// MARK: - API
extension QRCodeScanViewController: QRCodeScanViewModelDelegate {

    func didReceiveWahCertificateResponse(objResponse: BaseResponse<WahCertificate>) {
        
        NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["wahcertificate": objResponse.results.id ?? 0])
       self.navigationController?.popViewController(animated: true)
    }
    
    func didReceiceWahCertificateError(strError: String) {
        //
    }
    
    //MARK: - QRCodeScanViewModelDelegate
    
    
    
    func scanWolooQR(name: String) {
        APIManager.shared.scanWolooQR(param: [Key.name: name]) { (isSuccess, message) in
            if isSuccess {
                DispatchQueue.main.async {
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Okay", title: "Thank you", message: AppConfig.getAppConfigInfo()?.customMessage?.QRCodeScanningSuccessDialog, image: nil, controller: self)
                    alert.cancelTappedAction = {
                        alert.removeFromSuperview()
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
                }
            } else {
                self.showToast(message: message)
            }
        }
    }
    
    func scanWolooQRV2(name: String){
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        var data = ["name": name ?? ""]
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .scanWoloo, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<StatusSuccessResponseModel>, Error>) in
            switch result {
                
            case .success(let response):
                print("scan woloo response: \(response)")
                
                
            case .failure(let error):
                print("scan woloo error: \(error)")
            }
        }
        
    }
}

// MARK: - WebView Logics for Short Link
extension QRCodeScanViewController {
    /// Get short link and convert it to long link with the help of webview.
    /// - Parameters:
    ///   - shortLink: Short Link **URL**
    ///   - completion: Long Link**URL**
    private func callWebViewAndGetLongLink(_ shortLink: String,_ completion: @escaping(_ link: String?) -> Void) {
        
        let url = URL(string: shortLink)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "HEAD"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if let expandedURL = urlResponse?.url?.absoluteString {
                    completion(expandedURL)
                    print("expandedURL HEAD: \(expandedURL)")
                    return
                }
                completion(nil)
            }
        }.resume()
    }
}
