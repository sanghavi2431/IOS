//
//  RedeemWolooCell.swift
//  Woloo
//
//  Created by CEPL on 18/04/25.
//

import UIKit

protocol RedeemWolooCellDelegate: NSObjectProtocol{
    
    func didClickedApplyPointsBtn()
    func didDeletePromoCode(strPromocode: String?)
}

class RedeemWolooCell: UITableViewCell {
    
    @IBOutlet weak var lblCoinsInfo: UILabel!
    
    @IBOutlet weak var btnApply: ShadowViewButton!
    
    
    var objUserCoinModel = UserCoinModel()
    weak var delegate: RedeemWolooCellDelegate?
    var objPromotions = Promotions()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCartPromoCodeCell(objCoins: UserCoinModel?, objPromotion: Promotions?){
        
        self.objUserCoinModel = objCoins ?? UserCoinModel()
        self.objPromotions = objPromotion ?? Promotions()
        
        self.lblCoinsInfo.text = "You have \(self.objUserCoinModel.totalCoins ?? 0) Woloo Points to Redeem"
        
        if !(Utility.isEmpty(self.objPromotions.code ?? "")) {
            self.btnApply.setTitle("Remove", for: .normal)
            self.btnApply.setTitle("Remove", for: .highlighted)
            self.btnApply.setTitle("Remove", for: .selected)
        }else{
            self.btnApply.setTitle("Apply", for: .normal)
            self.btnApply.setTitle("Apply", for: .highlighted)
            self.btnApply.setTitle("Apply", for: .selected)
        }
        
    }
    
    
    @IBAction func clickedApplyBtn(_ sender: UIButton) {
        if !(Utility.isEmpty(self.objPromotions.code ?? "")) {
            if self.delegate != nil {
                self.delegate?.didDeletePromoCode(strPromocode: self.objPromotions.code ?? "")
            }
        }
        else{
            if self.delegate != nil{
                self.delegate?.didClickedApplyPointsBtn()
            }
        }
    }
    
    
}

