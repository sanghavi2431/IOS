//
//  OrderHistoryTitleCell.swift
//  Woloo
//
//  Created by CEPL on 02/07/25.
//

import UIKit

class OrderHistoryTitleCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureOrderSetTitle(strID: String?){
        self.lblTitle.text = strID ?? "-"
    }
    
}
