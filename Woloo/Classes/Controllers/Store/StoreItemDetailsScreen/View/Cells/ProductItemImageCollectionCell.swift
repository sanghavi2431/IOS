//
//  ProductItemImageCollectionCell.swift
//  Woloo
//
//  Created by CEPL on 09/04/25.
//

import UIKit

class ProductItemImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
//    @IBOutlet weak var overlayView: UIView!
//    @IBOutlet weak var overlayLabel: UILabel!
    
    var objBlogModel = BlogModel()
    var objStoreProductImages = StoreProductImages()
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    
//    func showOverlayText(_ text: String) {
//        overlayView.isHidden = false
//        overlayLabel.text = text
//    }
//
//    func hideOverlay() {
//        overlayView.isHidden = true
//        overlayLabel.text = ""
//    }

    func configureBlogDetailMultipleImageCell(blogImg: String?, baseUrl: String?){
        
        self.imgView.layer.cornerRadius = 25
        self.imgView.backgroundColor = .black
        self.imgView.sd_setImage(with: URL(string: "\(baseUrl ?? "")\(blogImg ?? "")"), completed: nil)
        
        print("image url:\(baseUrl ?? "")\(blogImg ?? "")")
    }
    
    
    
    func configureProductItenImageCollectionCell(objStoreProductImages: StoreProductImages?) {
        self.objStoreProductImages = objStoreProductImages ?? StoreProductImages()
        
        //self.imgView.layer.cornerRadius = 67
        self.imgView.sd_setImage(with: URL(string: objStoreProductImages?.url ?? ""), completed: nil)
        
    }
    
}
