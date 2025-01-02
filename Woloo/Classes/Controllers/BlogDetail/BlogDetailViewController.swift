//
//  BlogDetailViewController.swift
//  Woloo
//
//  Created on 24/08/21.
//

import UIKit
import WebKit
import Firebase

class BlogDetailViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var blogTitleLabel: UILabel!
    @IBOutlet var blogImageView: UIImageView!
    @IBOutlet var coinLabel: UIButton!
    @IBOutlet var blogDescriptionLabel: UILabel!
    @IBOutlet var blogShortDescriptionLabel: UILabel!
    @IBOutlet var viaWolooLabel: UILabel!
    @IBOutlet var webView: WKWebView!
    
    var detailBLogLink = ""
    var detailBlogTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blogTitleLabel.text = detailBlogTitle

        guard let url = URL(string: detailBLogLink ?? "") else { return  }
        let handled = DynamicLinks.dynamicLinks()
            .handleUniversalLink(url) { [self] dynamiclink, error in
              if let link = dynamiclink?.url {
                  print(link)
                  webView.navigationDelegate = self
                  webView.load(URLRequest(url: link))
                  webView.allowsBackForwardNavigationGestures = true
                  
              } else {
                  print(error?.localizedDescription)
              }
          }
    //snehal
    /*
        webView.navigationDelegate = self
        guard let url = URL(string: detailBLogLink ?? "") else { return  }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
*/
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
