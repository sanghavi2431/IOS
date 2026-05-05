//
//  BuyPassBtnCell.swift
//  Woloo
//
//  Created by CEPL on 07/10/25.
//

import UIKit

protocol BuyPassBtnCellDelegate: NSObjectProtocol{
    func didClickedBuyPassbtn()
}

class BuyPassBtnCell: UITableViewCell {

    @IBOutlet weak var btnBuyPass: ShadowViewButton!
    
    
    weak var delegate: BuyPassBtnCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnBuyPass.setTitle("Buy Pass For \u{20B9}\(UserDefaultsManager.fetchAppConfigData()?.powder_room_usage_charge ?? "0")", for: .normal)
        self.btnBuyPass.setTitle("Buy Pass For \u{20B9}\(UserDefaultsManager.fetchAppConfigData()?.powder_room_usage_charge ?? "0")", for: .selected)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedBtnBuyPass(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didClickedBuyPassbtn()
        }
    }
    
    
    
}
