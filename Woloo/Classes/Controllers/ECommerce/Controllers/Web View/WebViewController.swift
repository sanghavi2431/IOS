//
//  WebViewController.swift
//  Woloo
//
//  Created by Rahul Patra on 11/08/21.
//

import UIKit
import WebKit

public struct RzPay {
    var razorPayid: String
    var orderID: String
    var signature: String
}

class WebViewController: UIViewController {
    
    var webView: WKWebView = WKWebView()
    
    var amount: String = ""
    var mobilenumber: String = ""
    var email: String = ""
    var address: Address?
    var userId: String = ""
    var name: String = ""
    var webViewLink = "http://isntmumbai.in/woloo_shopping/app_api/payment_webview.php?"
    open var successCompletion: ((RzPay) -> Void)?
    open var faliurCompletion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        
        webViewLink += "amount=\(amount)&user_id=\(userId)&name=\(name)&mobile=\(mobilenumber)&address=\(self.address?.getAddress ?? "")"
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if let url = URL(string: webViewLink) {
            let req = URLRequest(url: url)
            webView.load(req)
        } else {
            self.showToast(message: "Something went wrong.")
            self.dismiss(animated: true, completion: nil)
        }
    }
}

import WebKit
extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        if let url = webView.url?.absoluteString{
            if url.contains("payment_success.php") {
                var razorpay_payment_id = url.components(separatedBy: "&").filter { $0.contains("razorpay_payment_id")}.first?.components(separatedBy: "=").last ?? ""
                var razorpay_order_id = url.components(separatedBy: "&").filter { $0.contains("razorpay_order_id")}.first?.components(separatedBy: "=").last ?? ""
                var razorpay_signature = url.components(separatedBy: "&").filter { $0.contains("razorpay_signature")}.first?.components(separatedBy: "=").last ?? ""
                self.dismiss(animated: true) {
                    self.successCompletion?(RzPay(razorPayid: razorpay_payment_id, orderID: razorpay_order_id, signature: razorpay_signature))
                }
            }
            
            
            if url.contains("payment_failure.php") {

                self.dismiss(animated: true) {
                    self.faliurCompletion?()
                }
            }
            
        }
    }
}
