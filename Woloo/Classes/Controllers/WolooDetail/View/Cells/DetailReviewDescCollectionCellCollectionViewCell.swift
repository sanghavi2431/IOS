//
//  DetailReviewDescCollectionCellCollectionViewCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 09/11/24.
//

import UIKit

class DetailReviewDescCollectionCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblWolooDate: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.cornerRadius = 10
    }
    func configureDetailReviewDescCollectionViewCell(objReviewDetail:ReviewListModel.Review){
        
        self.lblName.text = objReviewDetail.user_details?.name?.capitalized.count ?? 0 > 0 ?  objReviewDetail.user_details?.name?.capitalized : "Guest"
        
        let fullName = objReviewDetail.user_details?.name ?? ""
        let firstName = fullName.components(separatedBy: " ").first ?? "Guest"
        print(firstName) // Output: Harshada or Guest
        self.lblName.text = "\(firstName)"
        
        self.lblReview.text = objReviewDetail.review_description
       // readMoreButton.isHidden = !reviewDescriptionLabel.isTruncated
        
        let url = "\(objReviewDetail.user_details?.base_url ?? "")\(objReviewDetail.user_details?.avatar ?? "")"
        
        print("avatar URL: \(url)")
        self.imgView.sd_setImage(with: URL(string: url), completed: nil)
        
        let dateString = "2023-05-05 09:58:50"
        let dateFormatter = DateFormatter()

        // Input format
        dateFormatter.dateFormat = objReviewDetail.user_details?.woloo_since ?? ""
        if let date = dateFormatter.date(from: dateString) {
            // Output format
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDate = dateFormatter.string(from: date)
            print(formattedDate) // Output: 05/05/2023
            self.lblWolooDate.text = "[Since: \(formattedDate)]"
        }
        
       
    }
    
   

    }


