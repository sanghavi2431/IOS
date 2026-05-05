//
//  TableHeaderView.swift
//  KinoClub
//
//  Created by Ashish.Khobragade on 08/10/19.
//  Copyright © 2019 Jetsynthesys. All rights reserved.
//

import UIKit

protocol TableHeaderViewDelegate:class {
   func didTapViewAllButton(sender:UIButton)
}

extension TableHeaderViewDelegate {
    func didTapViewAllButton(sender:UIButton){}
}


class TableHeaderView: UIView {

   weak var delegate:TableHeaderViewDelegate?
  
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var viewAllArrow: UIImageView!
    
    var section:Int!
    
    @IBOutlet weak var headerTitleLabel: UILabel!
  
    var categoryDO:Category? {
        didSet {
            /*  headerTitleLabel.text =  LanguageManager.shared.localizedCategory(title: categoryDO?.categoryTitle ?? "")//.uppercased()
          
            if let response = categoryDO?.portletDetailsResponseDO {
                if (response.contentDataArray?.count ?? 0) > 3 {
                    viewAllLabel.isHidden = false
                    viewAllButton.isHidden = false
                }else {
                    viewAllLabel.isHidden = true
                    viewAllButton.isHidden = true
                }
            }else if let socialContentArray = categoryDO?.categoryResponseDO?.socialContent?.contentArray {
                if  socialContentArray.count > 3 {
                    viewAllLabel.isHidden = false
                    viewAllButton.isHidden = false
                }else {
                    viewAllLabel.isHidden = true
                    viewAllButton.isHidden = true
                }
            }
            else if let response = categoryDO?.categoryResponseDO {
                if  (response.categoryContentData?.count ?? 0) > 3 {
                    
                    viewAllLabel.isHidden = false
                    viewAllButton.isHidden = false
                }else {
                    viewAllLabel.isHidden = true
                    viewAllButton.isHidden = true
                }
            }*/
        }
    }
   
    class func instanceFromNib() -> UIView {
       
        return UINib(nibName: "TableHeaderView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func configureUI(section:Int) {
        self.section = section
        
    }
    
    @IBAction func didTapViewAllButton(_ sender: UIButton) {
        
        sender.tag = self.section
        
        delegate?.didTapViewAllButton(sender: sender)
    }
}

