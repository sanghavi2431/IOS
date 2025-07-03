//
//  LogOutBtnCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 17/01/25.
//

import UIKit

protocol LogOutBtnCellProtocol: NSObjectProtocol{
    
    func didSelectLogOutBtn()
}

class LogOutBtnCell: UITableViewCell {

    @IBOutlet weak var btnLogout: UILabel!
    
    
    weak var delegate: LogOutBtnCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnLogout.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func logOutBtnTapped(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didSelectLogOutBtn()
        }
    }
    
}
