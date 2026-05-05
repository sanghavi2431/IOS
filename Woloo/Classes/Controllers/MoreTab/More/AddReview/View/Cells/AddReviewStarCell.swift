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
        let ratingValue = self.rating ?? 0.0
        
        // Handle float values from slider by using range checks
        // Round to nearest integer for star display
        let roundedRating = Int(ratingValue.rounded())
        
        // Update star buttons based on rounded rating
        self.btnRate1.isSelected = roundedRating >= 1
        self.btnRate2.isSelected = roundedRating >= 2
        self.btnRate3.isSelected = roundedRating >= 3
        self.btnRate4.isSelected = roundedRating >= 4
        self.btnRate5.isSelected = roundedRating >= 5
        
        // Print score category for debugging
        if roundedRating <= 1 {
            print("poor score")
        } else if roundedRating == 2 {
            print("fair score")
        } else if roundedRating == 3 {
            print("Good score")
        } else if roundedRating == 4 {
            print("Very Good score")
        } else if roundedRating >= 5 {
            print("Excellent score")
        }
    }
    
    @IBAction func clickedBtnRate1(_ sender: UIButton) {
        self.rating = 1.0
        updateStarButtons(for: 1.0)
        self.delegate?.didChangedStarValue(value: self.rating)
    }
    
    @IBAction func clickedBtnRate2(_ sender: UIButton) {
        self.rating = 2.0
        updateStarButtons(for: 2.0)
        self.delegate?.didChangedStarValue(value: self.rating)
    }
    
    @IBAction func clickedBtnRate3(_ sender: UIButton) {
        self.rating = 3.0
        updateStarButtons(for: 3.0)
        self.delegate?.didChangedStarValue(value: self.rating)
    }
    
    @IBAction func clickedBtnRate4(_ sender: UIButton) {
        self.rating = 4.0
        updateStarButtons(for: 4.0)
        self.delegate?.didChangedStarValue(value: self.rating)
    }
    
    @IBAction func clickedBtnRate5(_ sender: UIButton) {
        self.rating = 5.0
        updateStarButtons(for: 5.0)
        self.delegate?.didChangedStarValue(value: self.rating)
    }
    
    // Helper method to update star button states
    private func updateStarButtons(for rating: Float) {
        let roundedRating = Int(rating.rounded())
        self.btnRate1.isSelected = roundedRating >= 1
        self.btnRate2.isSelected = roundedRating >= 2
        self.btnRate3.isSelected = roundedRating >= 3
        self.btnRate4.isSelected = roundedRating >= 4
        self.btnRate5.isSelected = roundedRating >= 5
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
