//
//  DetailCibilImageView.swift
//  Woloo
//
//  Created by Kapil Dongre on 07/11/24.
//

import UIKit

class DetailCibilImageView: UITableViewCell {
    
    @IBOutlet weak var cibilImgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setV2(img: NearbyResultsModel?){
        
        self.cibilImgView.sd_setImage(with: URL(string: img?.cibil_score_image ?? ""), completed: nil)
        
      //  cibilImgView.image = img.
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
