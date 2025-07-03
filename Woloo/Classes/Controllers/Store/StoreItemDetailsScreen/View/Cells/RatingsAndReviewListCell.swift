//
//  RatingsAndReviewListCell.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import UIKit

class RatingsAndReviewListCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDtPostedOn: UILabel!
    @IBOutlet weak var lblReviewDesc: UILabel!
    
    var objProductReview = ProductReview()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgView.layer.cornerRadius = self.imgView.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureRatingsAndReviewListCell(objProductReview: ProductReview?){
        
        self.objProductReview = objProductReview ?? ProductReview()
        self.lblName.text = (self.objProductReview.customer?.first_name ?? "") + " " + (self.objProductReview.customer?.last_name ?? "")
        
        self.lblReviewDesc.text = self.objProductReview.comment ?? ""
        self.lblDtPostedOn.text = "posted On: \(self.objProductReview.created_at ?? "")"
        
    }
    
}
