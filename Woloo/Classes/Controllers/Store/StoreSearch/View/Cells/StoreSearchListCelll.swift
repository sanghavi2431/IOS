//
//  StoreSearchListCelll.swift
//  Woloo
//
//  Created by CEPL on 20/03/25.
//

import UIKit

class StoreSearchListCelll: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    
   var objProducts = Products()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureStoreSearchListCelll(objProducts: Products?){
        self.objProducts = objProducts ?? Products()
        self.lblProductName.text = objProducts?.title ?? ""
        
        imgView.sd_setImage(with: URL(string: self.objProducts.thumbnail ?? ""), completed: nil)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
