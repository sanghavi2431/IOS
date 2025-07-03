//
//  SayItWolooImgCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 05/02/25.
//

import UIKit

class SayItWolooImgCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgView.cornerRadius = 10
        imgView.clipsToBounds = true
    }
    
    func configureSayItWolooImgCell(selectedImg: UIImage?){
        
        self.imgView.image = selectedImg ?? UIImage(named: "woloo_default")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
