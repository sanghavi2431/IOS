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
    
    var objTermsViewModel = TermsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objTermsViewModel.delegate = self
        
        self.objTermsViewModel.getTermsAndConditionsAPI()
        webView.navigationDelegate = self
//        if let url = URL(string: UserDefaultsManager.fetchAppConfigData()?.URLS?.terms_url ?? "") {
//            // Safe to use 'url' here
//            webView.load(URLRequest(url: url))
//            webView.allowsBackForwardNavigationGestures = true
//            
//        } else {
//            // Handle invalid URL
//            print("Invalid URL")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//            DELEGATE.rootVC?.tabBarVc?.showTabBar()
//            DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
//            DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
    
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

extension TermsVC: TermsViewModelDelegate{
    
    //MARK: - TermsViewModelDelegate
    func didRecieveTermsSucess(objResponse: BaseResponse<TermsModel>)
    {
        print("Api Success", objResponse.results.description ?? "")
        
       let htmlString = objResponse.results.description ?? ""
    
        self.webView.loadHTMLString(htmlString, baseURL: nil)
        
    }

    
    func didRecieveTermsError(strError: String) {
        print("Api failure", strError)
    }

}
