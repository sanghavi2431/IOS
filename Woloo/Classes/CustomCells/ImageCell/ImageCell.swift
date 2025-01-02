//
//  ImageCellCollectionViewCell.swift
//  Woloo
//
//  Created by ideveloper2 on 05/06/21.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var plusPlaceHolderImage: UIImageView!
    
    var deleteImageHandler: ((_ indx: Int?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 10
        plusPlaceHolderImage.cornerRadius = 10
        imageView.backgroundColor = #colorLiteral(red: 0.8010786772, green: 0.8010975718, blue: 0.8010874391, alpha: 1)
    }
    
    
    @IBAction func deleteAction(_ sender: UIButton) {
        deleteImageHandler?(sender.tag)
    }
    
}
