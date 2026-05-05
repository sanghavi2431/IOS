//
//  HelpAndSupportBtnCell.swift
//  Woloo
//
//  Created by CEPL on 08/03/25.
//

import UIKit

protocol HelpAndSupportBtnCellDelegate: NSObjectProtocol{
    func didClickedHelpAndSupportBtn()
}

class HelpAndSupportBtnCell: UITableViewCell {

    weak var delegate: HelpAndSupportBtnCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func clickedHelpAndSupportBtn(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didClickedHelpAndSupportBtn()
            
        }
    }
    
}
