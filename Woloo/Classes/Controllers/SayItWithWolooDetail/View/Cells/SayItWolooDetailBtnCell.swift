//
//  SayItWolooDetailBtnCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 05/02/25.
//

import UIKit

protocol SayItWolooDetailBtnCellDelegate: NSObjectProtocol{
    func didClickEditBtn()
    func didClickSendBtn()
}

class SayItWolooDetailBtnCell: UITableViewCell {

    weak var delegate: SayItWolooDetailBtnCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedBtnEdit(_ sender: UIButton) {
        if self.delegate != nil {
            self.delegate?.didClickEditBtn()
        }
        
    }
    
    @IBAction func clickedBtnSend(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didClickSendBtn()
        }
    }
    
    
}
