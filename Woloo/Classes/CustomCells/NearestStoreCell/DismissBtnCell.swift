//
//  DismissBtnCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 27/09/24.
//

import UIKit

class DismissBtnCell: UITableViewCell {

    
    @IBOutlet weak var btnDismiss: UIButton!
    
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
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
