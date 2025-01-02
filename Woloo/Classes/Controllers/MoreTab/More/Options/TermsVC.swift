//
//  TermsVC.swift
//  Woloo
//
//  Created on 25/04/21.
//

import UIKit
import WebKit

class TermsVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        if let url = URL(string: UserDefaultsManager.fetchAppConfigData()?.URLS?.terms_url ?? "") {
            // Safe to use 'url' here
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
            
        } else {
            // Handle invalid URL
            print("Invalid URL")
        }
        
       
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
