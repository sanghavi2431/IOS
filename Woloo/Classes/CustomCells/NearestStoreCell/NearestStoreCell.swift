//
//  NearestStoreCell.swift
//  Woloo
//
//  Created by Ashish Khobragade on 24/12/20.
//

import UIKit

class NearestStoreCell: UICollectionViewCell {
    
    @IBOutlet weak var storeImageGallary: UIImageView!
    
    @IBOutlet weak var storeTitleLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    @IBOutlet weak var timeToTravelTostoreLabel: UILabel!
    
    @IBOutlet weak var storeRatingLabel: UILabel!
    
    var wolooStore :WolooStore?{
        didSet{
            configureUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    
    func configureUI()  {
        
        guard let wolooStore = wolooStore else { return }
        
        storeTitleLabel.text = wolooStore.title
        storeAddressLabel.text = wolooStore.address ?? ""
        storeDistanceLabel.text = wolooStore.distance ?? ""
        timeToTravelTostoreLabel.text = wolooStore.duration ?? ""
//        if let distance = wolooStore.distance{
//            
//            storeDistanceLabel.text = String(format: "%.2fkm", distance)
//        }

        if let offer = wolooStore.offer,let image = offer.image,image.count > 0{
           
            if image.isValidUrl(){
                storeImageGallary.setImage(string: image)
            }
            else{
                storeImageGallary.setImage(string:"https://woloo.digixp.in/storage/app/public/" + image)
            }
        }
        else if let images = wolooStore.image,images.count > 0{
            let image = images.first as? String ?? ""
            if image.isValidUrl(){
                
                storeImageGallary.setImage(string: image)
            }
            else{
                storeImageGallary.setImage(string: "https://woloo.digixp.in/storage/app/public/" + image)
            }
        }
        else{
            storeImageGallary.image = nil
        }
    
    }
}
