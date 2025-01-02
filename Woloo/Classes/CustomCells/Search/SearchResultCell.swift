//
//  SearchResultCell.swift
//  Woloo
//
//  Created by Vivek shinde on 29/12/20.
//

import UIKit

class SearchResultCell: UITableViewCell {

    
    @IBOutlet weak var wolooPremiumLbl: UILabel!
    @IBOutlet weak var resultTitleLbl: UILabel!
    @IBOutlet weak var resultDescriptionLbl: UILabel!
    @IBOutlet weak var walkDistanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var starLbl: UILabel!
    
    @IBOutlet weak var placeImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        wolooPremiumLbl.roundCorners(corners: [.bottomLeft], radius: 10)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
