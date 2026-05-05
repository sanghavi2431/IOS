//
//  searchWolooTableCell.swift
//  Woloo
//
//  Created by CEPL on 16/10/25.
//

import UIKit

class searchWolooTableCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblWolooName: UILabel!
    @IBOutlet weak var lblWolooAddress: UILabel!
    @IBOutlet weak var vwBackRating: UIView!
    @IBOutlet weak var lblRating: UILabel!
    
    var objSearchWoloo = SearchWoloo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureSearchWolooTableCell(objSearchWoloo: SearchWoloo?){
        
        self.objSearchWoloo = objSearchWoloo ?? SearchWoloo()
        
        self.imgView.cornerRadius = 26.31
        self.vwBackRating.cornerRadius = 10.0
        self.lblWolooName.text = objSearchWoloo?.name ?? "-"
        self.lblWolooAddress.text = objSearchWoloo?.address ?? "-"
        self.lblRating.text = "\(objSearchWoloo?.cibil_score ?? "")"
        self.vwBackRating.backgroundColor = UIColor(hexString:  objSearchWoloo?.cibil_score_colour ?? "#00FF38")
        

        if objSearchWoloo?.image?.count ?? 0 > 0{
            let url = "\(UserDefaultsManager.fetchUserData()?.profile?.baseUrl ?? "")/\(objSearchWoloo?.image?[0] ?? "")"
            let trimmedUrl = url.replacingOccurrences(of: " ", with: "")
            self.imgView.sd_setImage(with: URL(string: trimmedUrl), completed: { (image, error, cacheType, imageURL) in
                if error != nil || image == nil {
                    self.imgView.image = UIImage(named: "woloo_default")
                }
            })
        } else {
            self.imgView.image = UIImage(named: "woloo_default")
        }
        

        
        
        //"\(API.environment.baseURL)/storage/app/public/\(imageUrl ?? "")"
        
    }
    
}
