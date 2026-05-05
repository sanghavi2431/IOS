//
//  LogDetailCell.swift
//  Woloo
//
//  Created on 03/08/21.
//

import UIKit

class LogDetailCell: UICollectionViewCell {

    @IBOutlet weak var logTitleLabel: UILabel!
    @IBOutlet weak var logImageView: UIImageView!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var vwImgBack: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vwImgBack.layer.cornerRadius = self.vwImgBack.frame.width / 2
    }

}
