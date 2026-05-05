//
//  SearchTxtFieldCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 18/11/24.
//

import UIKit

class SearchTxtFieldCell: UITableViewCell {

    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureSearchTxtFieldCell(strTxt: String?){
        
        self.lblLocation.text = strTxt ?? ""
    }
    
    func configureSearchWoloo(objSearchWoloo: SearchWoloo?){
        self.lblLocation.text = "\(objSearchWoloo?.name ?? "-"),\(objSearchWoloo?.address ?? "-")"
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
