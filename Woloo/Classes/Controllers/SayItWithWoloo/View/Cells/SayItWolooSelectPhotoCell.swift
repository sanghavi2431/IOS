//
//  SayItWolooSelectPhotoCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 23/01/25.
//

import UIKit

protocol SayItWolooSelectPhotoCellDelegate: NSObjectProtocol {
    
    func didClickedOpenImage(selectedImg: UIImage?)
    func didClickedDeleteImage()
    
}

class SayItWolooSelectPhotoCell: UITableViewCell {

    
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var lblImgName: UILabel!
    
    weak var delegate: SayItWolooSelectPhotoCellDelegate?
    var selectedImg: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBack.layer.cornerRadius = 10.0
    }
    
    func configureSayItWolooSelectPhotoCell(selectedImg: UIImage?, imgName: String?){
        
        if Utility.isEmpty(imgName ?? ""){
            self.lblImgName.text = "Add an image"
            self.lblImgName.textColor = .gray
        }
        else{
            self.lblImgName.text = imgName ?? ""
            self.lblImgName.textColor = .black
        }
        
        
        self.selectedImg = selectedImg ?? UIImage()
        self.imgView.image = selectedImg ?? UIImage(named: "icon_gallery")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedOpenImage(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didClickedOpenImage(selectedImg: self.selectedImg)
        }
    }
    
    
    @IBAction func clickedDeleteImg(_ sender: UIButton) {
        if self.delegate != nil {
            self.delegate?.didClickedDeleteImage()
        }
    }
}
