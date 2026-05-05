//
//  OtherItemsTitleCell.swift
//  Woloo
//
//  Created by CEPL on 12/05/25.
//

import UIKit

class OtherItemsTitleCell: UITableViewCell {

    @IBOutlet weak var lblCartCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCartItemCount(count: Int?){
        self.lblCartCount.text = String(format: "%@ : %d %@","Total Items", count ?? 0, "Units")
    }
    
    func configureOrderSetTitle(strID: String?){
        self.lblCartCount.text = strID ?? "-"
    }
    
}
