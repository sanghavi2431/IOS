//
//  DetailsReviewTableCell.swift
//  Woloo
//
//  Created by CEPL on 03/09/25.
//

import UIKit

class DetailsReviewTableCell: UITableViewCell {
    
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblWolooDate: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
    @IBOutlet weak var lblRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgVw.layer.cornerRadius = self.imgVw.frame.size.width/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureDetailsReviewTableCell(objReviewDetail:ReviewListModel.Review){
        
        self.lblName.text = objReviewDetail.user_details?.name?.capitalized.count ?? 0 > 0 ?  objReviewDetail.user_details?.name?.capitalized : "Guest"
        
        let fullName = objReviewDetail.user_details?.name ?? "Guest"
        let firstName = fullName.components(separatedBy: " ").first ?? "Guest"
        
        print(firstName) // Output: Harshada or Guest
        self.lblName.text = "\(firstName)"
        
        print("objReviewDetail.rating ?? 0", objReviewDetail.rating ?? 0)
        
        self.lblRating.text = "\(objReviewDetail.rating ?? 0)"
        
        self.lblReview.text = objReviewDetail.review_description
        let url = "\(objReviewDetail.user_details?.base_url ?? "")\(objReviewDetail.user_details?.avatar ?? "")"
        
        print("avatar URL: \(url)")
        
        if objReviewDetail.user_details?.avatar == "default.png" || Utility.isEmpty(objReviewDetail.user_details?.avatar ?? ""){
            
            self.imgVw.image = UIImage(named: "woloo_default")
            
        }
        else{
            self.imgVw.sd_setImage(with: URL(string: url), completed: nil)
        }
        
        self.lblWolooDate.text = "Woloo Member Since - \(self.formatDate(objReviewDetail.user_details?.woloo_since ?? ""))"
        
    }
    
    func formatDate(_ input: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // format of your input
        
        if let date = formatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM yy"   // May 23
            return outputFormatter.string(from: date)
        }
        return input // fallback if parsing fails
    }}
