//
//  DashBoardLocationCell.swift
//  Woloo
//
//  Created on 29/07/21.
//

import UIKit

class DashBoardLocationCell: UITableViewCell {

    @IBOutlet weak var locationDescLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    var locationHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func locationAction(_ sender: Any) {
        locationHandler?()
    }
}
