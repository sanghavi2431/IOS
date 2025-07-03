//
//  AboutVC.swift
//  Woloo
//
//  Created on 25/04/21.
//

import UIKit
import WebKit

class AboutVC: UIViewController , WKNavigationDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    
    var objAboutViewModel = AboutViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.objAboutViewModel.delegate = self
        self.objAboutViewModel.getAboutAPI()
        webView.navigationDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//            DELEGATE.rootVC?.tabBarVc?.showTabBar()
//            DELEGATE.roofttVC?.tabBarVc?.showPopUpVC(vc: self)
//            DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
    
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AboutVC: AboutViewModelDelegate{
    
    //MARK: AboutViewModelDelegate
    func didRecieveAboutSucess(objResponse: BaseResponse<TermsModel>) {
        let htmlString = objResponse.results.description ?? ""
     
         self.webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    func didRecieveAboutError(strError: String) {
        print("Api failure", strError)
    }
    
    
}
