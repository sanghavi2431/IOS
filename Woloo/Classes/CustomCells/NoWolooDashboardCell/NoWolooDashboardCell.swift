//
//  NoWolooDashboardCell.swift
//  Woloo
//
//  Created on 31/05/21.
//

import UIKit

class NoWolooDashboardCell: UITableViewCell {
    
    @IBOutlet weak var searchButton: UIButton!
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
