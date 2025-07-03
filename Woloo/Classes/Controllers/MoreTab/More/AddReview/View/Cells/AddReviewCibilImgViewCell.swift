//
//  AddReviewCibilImgViewCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 09/11/24.
//

import UIKit

class AddReviewCibilImgViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblCibilScore: UILabel!
    
    var rating: Float?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureAddReviewCibilImgViewCell(rating: Float?){
        self.rating = rating ?? 0.0
        if self.rating ?? 0.0 < 1{
            print("poor score")
            self.imgView.image = UIImage(named: "cibil_img_poor")
        }
        else if self.rating ?? 0.0 < 2{
            print("fair score")
            self.imgView.image = UIImage(named: "cibil_img_Fair")
            
        }
        else if self.rating ?? 0.0 < 3{
            print("Good score")
            self.imgView.image = UIImage(named: "cibil_img_good")
        }
        else if self.rating ?? 0.0 < 4{
            print("Very Good score")
            self.imgView.image = UIImage(named: "cibil_img_very_good")
        }
        else if self.rating ?? 0.0 <= 5{
            print("Excllent score")
            self.imgView.image = UIImage(named: "cibil_img_excellent")
        }
    }
    
    func configureRateAToiletImgViewCell(rating: Float?, objSearchWoloo: SearchWoloo?){
        self.rating = rating ?? 0.0
        if self.rating ?? 0.0 < 1{
            print("poor score")
            self.imgView.image = UIImage(named: "cibil_img_poor")
        }
        else if self.rating ?? 0.0 < 2{
            print("fair score")
            self.imgView.image = UIImage(named: "cibil_img_Fair")
            
        }
        else if self.rating ?? 0.0 < 3{
            print("Good score")
            self.imgView.image = UIImage(named: "cibil_img_good")
        }
        else if self.rating ?? 0.0 < 4{
            print("Very Good score")
            self.imgView.image = UIImage(named: "cibil_img_very_good")
        }
        else if self.rating ?? 0.0 <= 5{
            print("Excllent score")
            self.imgView.image = UIImage(named: "cibil_img_excellent")
        }
        
        if let maxScore = objSearchWoloo?.cibil_score?.split(separator: "-").last {
            print("Extracted score: \(maxScore)") // Output: 719
            self.lblCibilScore.text = "\(maxScore)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
