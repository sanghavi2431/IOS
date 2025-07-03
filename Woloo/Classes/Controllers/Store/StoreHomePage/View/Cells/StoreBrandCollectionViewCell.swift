//
//  StoreBrandCollectionViewCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 30/01/25.
//

import UIKit

class StoreBrandCollectionViewCell: UICollectionViewCell {

   
    @IBOutlet weak var imgBrand: UIImageView!
    @IBOutlet weak var lblBrand: UILabel!
    
    var objProductCollection = ProductCollection()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func configureStoreBrandCollectionViewCell(objBrand: ProductCollection?){
        
        
        let vwBackWidth = imgBrand.frame.size.width
        let vwBackHeight = imgBrand.frame.size.height
        
        if vwBackWidth < vwBackHeight {
            self.imgBrand.cornerRadius = vwBackWidth / 5.7
        } else {
            self.imgBrand.cornerRadius = vwBackHeight / 5.7
        }
        
        
       // self.imgBrand.layer.cornerRadius = 20.37
        self.objProductCollection = objBrand ?? ProductCollection()
        
        self.lblBrand.text = self.objProductCollection.title ?? ""
        self.imgBrand.sd_setImage(with: URL(string: self.objProductCollection.metadata?.image ?? ""), completed: nil)
    }
    
}
