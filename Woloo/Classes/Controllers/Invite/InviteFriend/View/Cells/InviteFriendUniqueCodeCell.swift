//
//  InviteFriendUniqueCodeCell.swift
//  Woloo
//
//  Created by CEPL on 13/02/25.
//

import UIKit

class InviteFriendUniqueCodeCell: UITableViewCell {

    
    @IBOutlet weak var lblUniqueCode: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblUniqueCode.layoutIfNeeded()
        self.lblUniqueCode.addDashedBorder()
    }
    
    func configureInviteFriendUniqueCodeCell(strUniqueCode: String?){
        self.lblUniqueCode.text =  (UserDefaultsManager.fetchUserData()?.profile?.ref_code ?? "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
