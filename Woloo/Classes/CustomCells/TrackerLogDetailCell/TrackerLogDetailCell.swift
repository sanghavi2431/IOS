//
//  TrackerLogDetailCell.swift
//  Woloo
//
//  Created on 10/08/21.
//

import UIKit

class TrackerLogDetailCell: UICollectionViewCell {

    @IBOutlet weak var logImageView: UIImageView!
    @IBOutlet weak var logTitleLabel: UILabel!
    @IBOutlet weak var plusImage: UIImageView!
    
    @IBOutlet weak var plusImageLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        plusImageLbl.layer.cornerRadius = 13.0
        plusImageLbl.layer.masksToBounds = true
    }

}
