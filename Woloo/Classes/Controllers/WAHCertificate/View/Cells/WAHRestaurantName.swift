//
//  WAHRestaurantName.swift
//  Woloo
//
//  Created by Kapil Dongre on 08/11/24.
//

import UIKit

class WAHRestaurantName: UITableViewCell {

    
    @IBOutlet weak var lblRestaurantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWAHRestaurantName(objWahCertificate: WahCertificate?){
        self.lblRestaurantName.text = objWahCertificate?.name?.capitalized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
