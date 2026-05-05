//
//  PreviewDocumentPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 21/02/25.
//

import UIKit

class PreviewDocumentPopUpVC: UIViewController {

    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    
    var imageAspectRatio: CGFloat = 0.6460
    var imgSelected: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }


    func loadInitialSettings(){
        
        var popupViewHeight : CGFloat = 0.0
        popupViewHeight = (SCREENWIDTH() - 64.0) * imageAspectRatio
        self.imgHeight.constant = popupViewHeight
        self.contentSizeInPopup = CGSize(width: SCREENWIDTH() - 32.0, height: popupViewHeight + 127.0)
        self.popupController?.containerView.layer.cornerRadius = 8.0
        self.popupController?.navigationBarHidden = true
        
        self.imgView.image = self.imgSelected ?? UIImage(named: "icon_gallery")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
}
