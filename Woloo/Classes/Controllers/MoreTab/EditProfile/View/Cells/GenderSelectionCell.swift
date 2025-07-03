//
//  GenderSelectionCell.swift
//  Woloo
//
//  Created by CEPL on 27/02/25.
//

import UIKit

protocol GenderSelectionCellDelegate: NSObjectProtocol{
    
    func didChangeGender(strGender: String?)
}

class GenderSelectionCell: UITableViewCell {

    @IBOutlet weak var btnMale: UIButton!
    
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var lblGender: UILabel!
    
    
    var objUserData = UserProfileModel()
    weak var delegate: GenderSelectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnMale.titleLabel?.font = UIFont(name: "CenturyGothic", size: 12) // Bold
        btnFemale.titleLabel?.font = UIFont(name: "CenturyGothic", size: 12)
        lblGender.font = UIFont(name: "CenturyGothic-Bold", size: 12)
    }
    
    func configureGenderSelectionCell(userData: UserProfileModel?){
        
        self.objUserData = userData ?? UserProfileModel()
        
        if objUserData.profile?.gender?.lowercased() == "male"
        {
            btnMale.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            btnFemale.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
            print("male selected \(self.btnMale.isSelected)")
        } else {
            btnFemale.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            btnMale.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
            print("female selected \(self.btnFemale.isSelected)")
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedBtnMale(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didChangeGender(strGender: "male")
        }
        
    }
    
    @IBAction func clickedBtnFemale(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didChangeGender(strGender: "female")
        }
    }
    
    
}
