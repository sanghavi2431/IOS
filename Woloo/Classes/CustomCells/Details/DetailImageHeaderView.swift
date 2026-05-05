//
//  DetailImageHeaderView.swift
//  JetLive
//
//  Created by Ashish Khobragade on 20/10/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import UIKit

class DetailImageHeaderView: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> UIView {
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
