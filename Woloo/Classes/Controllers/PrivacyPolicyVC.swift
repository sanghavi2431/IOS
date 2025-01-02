//
//  PrivacyPolicyVC.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 21/08/23.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController {

    
    @IBOutlet weak var backNavigationBtn: UIButton!
    
    @IBOutlet weak var privacyPolicyWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url=URL(string: "https://api.woloo.in/WolooTermsofUse.html")
        privacyPolicyWebView.load(URLRequest(url: url!))
    }
    

    @IBAction func backNavigatiobBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PrivacyPolicyVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
