//
//  InviteContactButtonCell.swift
//  Woloo
//
//  Created by CEPL on 13/02/25.
//

import UIKit
 
protocol InviteContactButtonCellDelegate: NSObjectProtocol {
    
    func didClickeBtnInviteContact()
    func didClickeBtnWhatsApp()
    func didClickeBtnShare()
    
}

class InviteContactButtonCell: UITableViewCell {

    @IBOutlet weak var btnInviteContact: ShadowViewButton!
    @IBOutlet weak var btnWhatsApp: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    weak var delegate: InviteContactButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clickedBtnInviteContct(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didClickeBtnInviteContact()
        }
    }
    
    
    @IBAction func clickedBtnWhatsApp(_ sender: UIButton) {
        if self.delegate != nil {
            self.delegate?.didClickeBtnWhatsApp()
        }
    }
    
    
    
    @IBAction func clickedBtnShare(_ sender: UIButton) {
        if self.delegate != nil {
            self.delegate?.didClickeBtnShare()
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
