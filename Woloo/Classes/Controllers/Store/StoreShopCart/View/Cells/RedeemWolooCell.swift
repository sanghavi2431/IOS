//
//  RedeemWolooCell.swift
//  Woloo
//
//  Created by CEPL on 18/04/25.
//

import UIKit

protocol RedeemWolooCellDelegate: NSObjectProtocol{
    
    func didClickedApplyPointsBtn()
}

class RedeemWolooCell: UITableViewCell {
    
    @IBOutlet weak var lblCoinsInfo: UILabel!
    
    var objUserCoinModel = UserCoinModel()
    weak var delegate: RedeemWolooCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCartPromoCodeCell(objCoins: UserCoinModel?){
        
        self.objUserCoinModel = objCoins ?? UserCoinModel()
        
        self.lblCoinsInfo.text = "You have \(self.objUserCoinModel.totalCoins ?? 0) Woloo Points to Redeem"
        
    }
    
    
    @IBAction func clickedApplyBtn(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.didClickedApplyPointsBtn()
        }
    }
    
    
}

