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
        self.rating = rating ?? 1.0
        let ratingValue = self.rating ?? 1.0
        
        // Round to nearest integer to handle float values from slider
        let roundedRating = Int(ratingValue.rounded())
        
        // Update image and label based on rounded rating
        switch roundedRating {
        case 1:
            print("poor score")
            self.imgView.image = UIImage(named: "cibil_img_poor")
            if let scoreRange = UserDefaultsManager.fetchAppConfigData()?.cibil_score_range?.one, let upperScore = scoreRange.components(separatedBy: "-").last {
                self.lblCibilScore.text = upperScore
            } else {
                self.lblCibilScore.text = ""
            }
        case 2:
            print("fair score")
            self.imgView.image = UIImage(named: "cibil_img_Fair")
            if let scoreRange = UserDefaultsManager.fetchAppConfigData()?.cibil_score_range?.two, let upperScore = scoreRange.components(separatedBy: "-").last {
                self.lblCibilScore.text = upperScore
            } else {
                self.lblCibilScore.text = ""
            }
        case 3:
            print("Good score")
            self.imgView.image = UIImage(named: "cibil_img_good")
            if let scoreRange = UserDefaultsManager.fetchAppConfigData()?.cibil_score_range?.three, let upperScore = scoreRange.components(separatedBy: "-").last {
                self.lblCibilScore.text = upperScore
            } else {
                self.lblCibilScore.text = ""
            }
        case 4:
            print("Very Good score")
            self.imgView.image = UIImage(named: "cibil_img_very_good")
            if let scoreRange = UserDefaultsManager.fetchAppConfigData()?.cibil_score_range?.four, let upperScore = scoreRange.components(separatedBy: "-").last {
                self.lblCibilScore.text = upperScore
            } else {
                self.lblCibilScore.text = ""
            }
        case 5:
            print("Excellent score")
            self.imgView.image = UIImage(named: "cibil_img_excellent")
            if let scoreRange = UserDefaultsManager.fetchAppConfigData()?.cibil_score_range?.five, let upperScore = scoreRange.components(separatedBy: "-").last {
                self.lblCibilScore.text = upperScore
            } else {
                self.lblCibilScore.text = ""
            }
        default:
            // Fallback for values outside 1-5 range
            print("default score")
            self.imgView.image = UIImage(named: "cibil_img_poor")
            self.lblCibilScore.text = ""
        }
    }
    
    func configureRateAToiletImgViewCell(rating: Float?, objSearchWoloo: SearchWoloo?){
        self.rating = rating ?? 1.0
        let ratingValue = self.rating ?? 1.0
        
        // Round to nearest integer to handle float values from slider
        let roundedRating = Int(ratingValue.rounded())
        
        // Update image and label based on rounded rating
        switch roundedRating {
        case 1:
            print("poor score")
            self.imgView.image = UIImage(named: "cibil_img_poor")
            if let scoreRange = UserDefaultsManager.fetchAppConfigData()?.cibil_score_range?.one, let upperScore = scoreRange.components(separatedBy: "-").last {
                self.lblCibilScore.text = upperScore
            } else {
                self.lblCibilScore.text = ""
            }
        case 2:
            print("fair score")
            self.imgView.image = UIImage(named: "cibil_img_Fair")
            if let scoreRange = UserDefaultsManager.fetchAppConfigData()?.cibil_score_range?.two, let upperScore = scoreRange.components(separatedBy: "-").last {
                self.lblCibilScore.text = upperScore
            } else {
                self.lblCibilScore.text = ""
            }
        case 3:
            print("Good score")
            self.imgView.image = UIImage(named: "cibil_img_good")
            if let scoreRange = UserDefaultsManager.fetchAppConfigData()?.cibil_score_range?.three, let upperScore = scoreRange.components(separatedBy: "-").last {
                self.lblCibilScore.text = upperScore
            } else {
                self.lblCibilScore.text = ""
            }
        case 4:
            print("Very Good score")
            self.imgView.image = UIImage(named: "cibil_img_very_good")
            if let scoreRange = UserDefaultsManager.fetchAppConfigData()?.cibil_score_range?.four, let upperScore = scoreRange.components(separatedBy: "-").last {
                self.lblCibilScore.text = upperScore
            } else {
                self.lblCibilScore.text = ""
            }
        case 5:
            print("Excellent score")
            self.imgView.image = UIImage(named: "cibil_img_excellent")
            if let scoreRange = UserDefaultsManager.fetchAppConfigData()?.cibil_score_range?.five, let upperScore = scoreRange.components(separatedBy: "-").last {
                self.lblCibilScore.text = upperScore
            } else {
                self.lblCibilScore.text = ""
            }
        default:
            // Fallback for values outside 1-5 range
            print("default score")
            self.imgView.image = UIImage(named: "cibil_img_poor")
            self.lblCibilScore.text = ""
        }
        
//        if let maxScore = objSearchWoloo?.cibil_score?.split(separator: "-").last {
//            print("Extracted score: \(maxScore)") // Output: 719
//            self.lblCibilScore.text = "\(maxScore)"
//        }
        
        
        
//        if let scoreRange = objSearchWoloo?.cibil_score, let upperScore = scoreRange.components(separatedBy: "-").last {
//            self.lblCibilScore.text = upperScore
//        } else {
//            self.lblCibilScore.text = ""
//        }
        
//        self.lblCibilScore.text = objSearchWoloo?.cibil_score ?? ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
