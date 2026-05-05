//
//  RateYourExperienceCell.swift
//  Woloo
//
//  Created by CEPL on 08/03/25.
//

import UIKit

protocol RateYourExperienceCellDelegate: NSObjectProtocol {
    func didClickedWriteAReview()
}

class RateYourExperienceCell: UITableViewCell {

    weak var delegate: RateYourExperienceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedWriteAReview(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didClickedWriteAReview()
        }
    }
    
}
