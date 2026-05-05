//
//  AddReviewSubmitBtnCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 11/11/24.
//

import UIKit

protocol AddReviewSubmitBtnCellProtocol: NSObjectProtocol{
    func didTappedSubmitRequestBtn()
}

class AddReviewSubmitBtnCell: UITableViewCell {

    
    @IBOutlet weak var btnSubmit: UIButton!
    
    weak var delegate: AddReviewSubmitBtnCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnSubmit.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func clickedBtnSubmit(_ sender: UIButton) {
        
        self.btnSubmit.isSelected = !self.btnSubmit.isSelected
        
//        if self.btnSubmit.isSelected {
//            self.btnSubmit.backgroundColor = .lightGray
//            
//        }
//        else{
//            self.btnSubmit.backgroundColor = .yellow
//        }
        
        if self.delegate != nil{
            self.delegate?.didTappedSubmitRequestBtn()
        }
    }
}
