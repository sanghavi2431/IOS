//
//  HistroyCell.swift
//  Woloo
//
//  Created by Vivek shinde on 21/12/20.
//

import UIKit


protocol HistroyCellDelegate {
    func earningHistroyBtnPressedDelegate(_ sender: UIButton)
    func subscriptionBtnPressedDelegate(_ sender: UIButton)
}

class HistroyCell: UITableViewCell {

    @IBOutlet weak var bottomLbl: UILabel!
   
    var delegate : HistroyCellDelegate?

    @IBOutlet weak var earnedBtn: UIButton!
    
    func configureUI() {
        
       self.earnedBtn.setTitleColor(#colorLiteral(red: 1, green: 0.9109050035, blue: 0.2959001064, alpha: 1), for: .normal)

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func earningHistroyBtnPressed(_ sender: UIButton) {
        return;
//        self.bottomLbl.translatesAutoresizingMaskIntoConstraints = false
//        self.bottomLbl.frame.origin.x = earnedBtn.frame.origin.x
//        self.earnedBtn.setTitleColor(#colorLiteral(red: 1, green: 0.9109050035, blue: 0.2959001064, alpha: 1), for: .normal)
//        self.historyBtn.setTitleColor(#colorLiteral(red: 1, green: 0.9109050035, blue: 0.2959001064, alpha: 1).withAlphaComponent(0.5), for: .normal)
//        delegate?.earningHistroyBtnPressedDelegate(sender)
    }
    
//    @IBAction func subscriptionBtnPressed(_ sender: UIButton) {
//        self.bottomLbl.translatesAutoresizingMaskIntoConstraints = false
//        self.bottomLbl.frame.origin.x = historyBtn.frame.origin.x
//        self.historyBtn.setTitleColor(#colorLiteral(red: 1, green: 0.9109050035, blue: 0.2959001064, alpha: 1), for: .normal)
//        self.earnedBtn.setTitleColor(#colorLiteral(red: 1, green: 0.9109050035, blue: 0.2959001064, alpha: 1).withAlphaComponent(0.5), for: .normal)
//        delegate?.subscriptionBtnPressedDelegate(sender)
//    }
    
    
    
    
    
}
