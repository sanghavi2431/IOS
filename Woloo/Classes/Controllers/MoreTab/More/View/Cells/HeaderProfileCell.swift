//
//  HeaderProfileCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 10/12/24.
//

import UIKit

class HeaderProfileCell: UITableViewCell {

    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.bgView.roundBottom(radius: 20.0)
        //self.bgView.addBottomShadow()
        
    }

    override func layoutSubviews() {
            super.layoutSubviews()
          //  addBottomShadow(to: bgView)
        }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
