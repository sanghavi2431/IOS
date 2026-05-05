//
//  DetailCibilImageView.swift
//  Woloo
//
//  Created by Kapil Dongre on 07/11/24.
//

import UIKit

class DetailCibilImageView: UITableViewCell {
    
    @IBOutlet weak var cibilImgView: UIImageView!
    @IBOutlet weak var lblWahScore: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setV2(img: NearbyResultsModel?){
        
        self.cibilImgView.sd_setImage(with: URL(string: img?.cibil_score_image ?? ""), completed: nil)
        //cibil_score
        if let scoreRange = img?.cibil_score, let upperScore = scoreRange.components(separatedBy: "-").last {
            self.lblWahScore.text = upperScore
        } else {
            self.lblWahScore.text = ""
        }
      //  cibilImgView.image = img.
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
