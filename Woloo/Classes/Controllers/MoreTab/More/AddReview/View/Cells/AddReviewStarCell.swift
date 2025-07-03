//
//  AddReviewStarCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 09/11/24.
//

import UIKit

protocol AddReviewStarCellDelegate: NSObjectProtocol{
    
    func didChangedStarValue(value: Float?)
}


class AddReviewStarCell: UITableViewCell {

    @IBOutlet weak var vwBackStar: UIView!
    @IBOutlet weak var btnRate1: UIButton!
    @IBOutlet weak var btnRate2: UIButton!
    @IBOutlet weak var btnRate3: UIButton!
    @IBOutlet weak var btnRate4: UIButton!
    @IBOutlet weak var btnRate5: UIButton!
    
    var rating: Float?
    weak var delegate: AddReviewStarCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBackStar.layer.borderWidth = 1.0
        self.vwBackStar.layer.borderColor = UIColor.lightGray.cgColor
        self.vwBackStar.layer.cornerRadius = 10.0
    }

    func configureAddReviewStarCell(rating: Float?){
        self.rating = rating ?? 0.0
        
        if self.rating ?? 0.0 < 1{
            print("poor score")
            self.btnRate1.isSelected = true
            self.btnRate2.isSelected = false
            self.btnRate3.isSelected = false
            self.btnRate4.isSelected = false
            self.btnRate5.isSelected = false
        }
        else if self.rating ?? 0.0 < 2{
            print("fair score")
            self.btnRate1.isSelected = true
            self.btnRate2.isSelected = true
            self.btnRate3.isSelected = false
            self.btnRate4.isSelected = false
            self.btnRate5.isSelected = false
            
        }
        else if self.rating ?? 0.0 < 3{
            print("Good score")
            self.btnRate1.isSelected = true
            self.btnRate2.isSelected = true
            self.btnRate3.isSelected = true
            self.btnRate4.isSelected = false
            self.btnRate5.isSelected = false
        }
        else if self.rating ?? 0.0 < 4{
            print("Very Good score")
            self.btnRate1.isSelected = true
            self.btnRate2.isSelected = true
            self.btnRate3.isSelected = true
            self.btnRate4.isSelected = true
            self.btnRate5.isSelected = false
        }
        else if self.rating ?? 0.0 <= 5{
            print("Excllent score")
            self.btnRate1.isSelected = true
            self.btnRate2.isSelected = true
            self.btnRate3.isSelected = true
            self.btnRate4.isSelected = true
            self.btnRate5.isSelected = true
        }
    }
    
    @IBAction func clickedBtnRate1(_ sender: UIButton) {
        
        self.btnRate1.isSelected = !self.btnRate1.isSelected
        
//        if self.btnRate1.isSelected == true{
//            self.btnRate1.isSelected = true
//            self.btnRate2.isSelected = false
//            self.btnRate3.isSelected = false
//            self.btnRate4.isSelected = false
//            self.btnRate5.isSelected = false
//            
//            self.rating = 0.0
//            
//            
//        }
        self.rating = 0.0
        self.delegate?.didChangedStarValue(value: self.rating)
    }
    
    @IBAction func clickedBtnRate2(_ sender: UIButton) {
//        if self.btnRate2.isSelected == true{
//            self.btnRate1.isSelected = true
//            self.btnRate2.isSelected = true
//            self.btnRate3.isSelected = false
//            self.btnRate4.isSelected = false
//            self.btnRate5.isSelected = false
//            
//            self.rating = 2.0
//        }
        self.rating = 1.0
        self.delegate?.didChangedStarValue(value: self.rating)
    }
    
    @IBAction func clickedBtnRate3(_ sender: UIButton) {
//        if self.btnRate3.isSelected == true{
//            self.btnRate1.isSelected = true
//            self.btnRate2.isSelected = true
//            self.btnRate3.isSelected = true
//            self.btnRate4.isSelected = false
//            self.btnRate5.isSelected = false
//            
//            self.rating = 3.0
//        }
        self.rating = 2.0
        self.delegate?.didChangedStarValue(value: self.rating)
    }
    
    @IBAction func clickedBtnRate4(_ sender: UIButton) {
//        if self.btnRate4.isSelected == true{
//            
//            self.btnRate1.isSelected = true
//            self.btnRate2.isSelected = true
//            self.btnRate3.isSelected = true
//            self.btnRate4.isSelected = true
//            self.btnRate5.isSelected = false
//            
//            self.rating = 4.0
//        }
        self.rating = 3.0
        self.delegate?.didChangedStarValue(value: self.rating)
    }
    
    @IBAction func clickedBtnRate5(_ sender: UIButton) {
//        if self.btnRate5.isSelected == true{
//            
//            self.btnRate1.isSelected = true
//            self.btnRate2.isSelected = true
//            self.btnRate3.isSelected = true
//            self.btnRate4.isSelected = true
//            self.btnRate5.isSelected = true
//            
//            self.rating = 5.0
//        }
        self.rating = 4.0
        self.delegate?.didChangedStarValue(value: self.rating)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
