//
//  SubmitButtonCell.swift
//  Woloo
//
//  Created by CEPL on 27/02/25.
//

import UIKit


class SubmitButtonCell: UITableViewCell {

    @IBOutlet weak var btnSubmit: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnSubmit.titleLabel?.font = UIFont(name: "CenturyGothic-Bold", size: 18) // Bold
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
