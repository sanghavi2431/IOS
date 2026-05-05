//
//  PowderRoomPassCardCell.swift
//  Woloo
//
//  Created by CEPL on 07/10/25.
//

import UIKit

protocol PowderRoomPassCardDelegate: NSObjectProtocol{
    
    func didClickedContactHelp()
}

class PowderRoomPassCardCell: UITableViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!
    
    
    @IBOutlet weak var lblAffordableaccess: UILabel!
    
    weak var delegate: PowderRoomPassCardDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblPrice.text = "\u{20B9}\(UserDefaultsManager.fetchAppConfigData()?.powder_room_usage_charge ?? "0")"
        
        self.lblAffordableaccess.text = "Affordable Access at just \u{20B9}\(UserDefaultsManager.fetchAppConfigData()?.powder_room_usage_charge ?? "0")"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func clickedContactHelp(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.didClickedContactHelp()
        }
        
    }
    
}
