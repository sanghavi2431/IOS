//
//  BlogsBlockPopupVC.swift
//  Woloo
//
//  Created by CEPL on 06/05/25.
//

import UIKit

class BlogsBlockPopupVC: UIViewController {

    
    @IBOutlet weak var yHeight: NSLayoutConstraint!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var lblVwBack: UIView!
    
    @IBOutlet weak var lblVwBacktop: NSLayoutConstraint!
    
    var vwFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.lblVwBack.layer.cornerRadius = 10
    
        cellHeight.constant = ((vwFrame?.height)!) - 103.0
        yHeight.constant = (vwFrame?.origin.y)!
        print(yHeight.constant)
        
        var bottomViewHeight : CGFloat = 0.0
        
        print(UIScreen.main.bounds.height - (yHeight.constant + cellHeight.constant))
        
        bottomViewHeight = UIScreen.main.bounds.height - (yHeight.constant + cellHeight.constant - 103.0)
        
        if (bottomViewHeight > yHeight.constant){
            print("Bottom view greater")
            lblVwBacktop.constant = yHeight.constant + cellHeight.constant + 30.0
        }else{
            print("Top View Greater")
            lblVwBacktop.constant = 44
        }
        
        view.isUserInteractionEnabled = true
        
        self.lblVwBack.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    @IBAction func handleTap(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.dismiss(animated: false)
        }
        
    }
}
