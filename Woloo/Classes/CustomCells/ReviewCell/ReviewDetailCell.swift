//
//  ReviewDetailCell.swift
//  Woloo
//
//  Created by ideveloper2 on 11/06/21.
//

import UIKit

class ReviewDetailCell: UICollectionViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var reviewDescriptionLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var userRatingLbl: UILabel!
    
    var moreButtonHandler: ((_ sender: Int?) -> Void)?
//    var reviewDetail: Review? {
//        didSet {
//            guard let detail = reviewDetail else {
//                return
//            }
//            fillReview(reviewDetail: detail)
//        }
//    }
    
    var reviewDetail: ReviewListModel.Review? {
        didSet {
            guard let detail = reviewDetail else {
                return
            }
            fillReview(reviewDetail: detail)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUP()
    }
    func setUP() {
        self.bgView.cornerRadius = 20
        self.bgView.borderWidth = 1
        self.bgView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    @IBAction func readMoreAction(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        moreButtonHandler?(button.tag)
    }
    
    func fillReview(reviewDetail: ReviewListModel.Review) {
//        if let date = reviewDetail.createdAt?.convertDateFormater(reviewDetail.createdAt ?? "", inputFormate: "yyyy'-'MM'-'dd HH':'mm':'ss", outputFormate: "yyyy'-'MM'-'dd HH':'mm':'ss") {
//            timeAgoLabel.text =  date.toDate?.getElapsedInterval()//dateFormatter.string(from: date)
//        }
//        self.userNameLabel.text = reviewDetail.userDetails?.name?.capitalized.count ?? 0 > 0 ?  reviewDetail.userDetails?.name?.capitalized : "Guest"
//
//        self.userRatingLbl.text = "\(reviewDetail.rating ?? 0)"
//
//        print("review description: \(reviewDetail.reviewDescription)")
//        self.reviewDescriptionLabel.text = reviewDetail.reviewDescription
//        readMoreButton.isHidden = !reviewDescriptionLabel.isTruncated
//
//
//
//        if let avtar = reviewDetail.userDetails?.avatar, avtar.count > 0 {
//            if avtar.contains("users/default.png") || avtar.contains("default.png"){
//
//              let url1 = "\(API.environment.baseURL)public/userProfile/default.png"
//                self.userImageView.sd_setImage(with: URL(string: url1), completed: nil)
//            }
//            else {
//                let url = "\(API.environment.baseURL)public/userProfile/\(avtar)"
//                self.userImageView.sd_setImage(with: URL(string: url), completed: nil)
//            }
//
//        }
        if let date = reviewDetail.created_at?.convertDateFormater(reviewDetail.created_at ?? "", inputFormate: "yyyy'-'MM'-'dd HH':'mm':'ss", outputFormate: "yyyy'-'MM'-'dd HH':'mm':'ss") {
            timeAgoLabel.text =  date.toDate?.getElapsedInterval()//dateFormatter.string(from: date)
        }
       // self.userNameLabel.text = reviewDetail.userDetails?.name?.capitalized.count ?? 0 > 0 ?  reviewDetail.userDetails?.name?.capitalized : "Guest"
        
        self.userNameLabel.text = reviewDetail.user_details?.name?.capitalized.count ?? 0 > 0 ?  reviewDetail.user_details?.name?.capitalized : "Guest"
        
        self.userRatingLbl.text = "\(reviewDetail.rating ?? 0)"
        
        print("review description: \(reviewDetail.review_description)")
        self.reviewDescriptionLabel.text = reviewDetail.review_description
        readMoreButton.isHidden = !reviewDescriptionLabel.isTruncated
        
        
        
        if let avtar = reviewDetail.user_details?.avatar, avtar.count > 0 {
            if avtar.contains("users/default.png") || avtar.contains("default.png"){
                
//              let url1 = "https://app.woloo.in/public/userProfile/default.png"
//                self.userImageView.sd_setImage(with: URL(string: url1), completed: nil)
                self.userImageView.image = UIImage(named: "user_default")
            }
            else {
                //https://app.woloo.in/storage/app/public/woloos/1680527538.jpg
                
                let url = "https://app.woloo.in/public/userProfile/\(avtar)"
                print("image URL: \(url)")
                self.userImageView.sd_setImage(with: URL(string: url), completed: nil)
            }

        }

    }
}
