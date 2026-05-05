//
//  InviteFriendImageCell.swift
//  Woloo
//
//  Created by CEPL on 13/02/25.
//

import UIKit

class InviteFriendImageCell: UITableViewCell {

    
    @IBOutlet weak var imgVwRefer: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgVwRefer.image = UIImage.gifFromAsset(named: "ReferFriend")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
