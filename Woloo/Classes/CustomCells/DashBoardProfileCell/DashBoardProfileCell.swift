//
//  DashBoardProfileCell.swift
//  Woloo
//
//  Created on 29/07/21.
//

import UIKit

class DashBoardProfileCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var wolooPointLabel: UILabel!
    
    var cartAction: (() -> Void)?
    var profileAction: (() -> Void)?
    var notifyAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cartAction(_ sender: Any) {
        cartAction?()
    }
    
    @IBAction func  notificationAction(_ sender: Any) {
        notifyAction?()
    }
    @IBAction func profileAction(_ sender: Any) {
        profileAction?()
    }
}
