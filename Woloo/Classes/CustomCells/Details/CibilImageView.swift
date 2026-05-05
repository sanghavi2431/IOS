//
//  CibilImageView.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 15/06/23.
//

import UIKit

class CibilImageView: UICollectionReusableView {

    
    @IBOutlet weak var cibilImgView: UIImageView!
    
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
    
    class func instanceFromNib() -> UIView {
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
    func setV2(img: NearbyResultsModel?){
        
        self.cibilImgView.sd_setImage(with: URL(string: img?.cibil_score_image ?? ""), completed: nil)
        
      //  cibilImgView.image = img.
        
        
    }
    
}
