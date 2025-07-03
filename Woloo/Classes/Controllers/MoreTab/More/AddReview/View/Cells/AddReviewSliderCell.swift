//
//  AddReviewSliderCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 09/11/24.
//

import UIKit

protocol AddReviewSliderCellDelegate: NSObjectProtocol{
    
    func didChangedSliderValue(value: Float?)
}

class AddReviewSliderCell: UITableViewCell {

    
    @IBOutlet weak var sliderVW: UISlider!
    
    weak var delegate: AddReviewSliderCellDelegate?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func configureAddReviewSliderCell(value: Float?){
        
        self.sliderVW.value = value ?? 0.0
    }
    
    
    @IBAction func changedSliderValue(_ sender: UISlider) {
        
        if (self.delegate != nil){
            self.delegate?.didChangedSliderValue(value: sender.value)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
