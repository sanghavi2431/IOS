//
//  ReviewDetailViewController.swift
//  Woloo
//
//  Created by ideveloper2 on 15/06/21.
//

import UIKit

class ReviewDetailViewController: UIViewController {

    @IBOutlet weak var reviewDescription: UITextView!
    
    var reviewDetail: Review? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewDescription.text = reviewDetail?.reviewDescription ?? ""
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
