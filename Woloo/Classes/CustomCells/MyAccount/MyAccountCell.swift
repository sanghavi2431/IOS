//
//  MyAccountCell.swift
//  Woloo
//
//  Created on 22/04/21.
//

import UIKit

class MyAccountCell: UITableViewCell {

    @IBOutlet weak var lblWolooPoints: UILabel!
    @IBOutlet weak var lblGiftPoints: UILabel!
    @IBOutlet weak var btnShop: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
