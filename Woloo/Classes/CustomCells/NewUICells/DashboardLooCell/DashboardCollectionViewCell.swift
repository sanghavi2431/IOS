//
//  DashboardCollectionViewCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 18/10/24.
//

import UIKit

protocol DashboardCollectionViewCellDelegate: NSObjectProtocol
{
    func didClickedNavigate(obj: NearbyResultsModel)
}

class DashboardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgViewWoloo: UIImageView!
    @IBOutlet weak var lblWolooTitle: UILabel!
    @IBOutlet weak var lblWolooOpenNow: UILabel!
    @IBOutlet weak var btnNavigate: UIButton!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var vwWidth: NSLayoutConstraint!
    @IBOutlet weak var btnTakeMeHere: UIButton!
    @IBOutlet weak var vwBackOfferVW: UIView!
    @IBOutlet weak var imgTransportTypeSelected: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var vwBackTakeMeHere: UIView!
    
    
    weak var delegate: DashboardCollectionViewCellDelegate?
    var objobjNearbyResultsModel = NearbyResultsModel()
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgViewWoloo.cornerRadius = 21.0
        //self.vwBackCibil.cornerRadius = 18.0
        self.vwBack.cornerRadius = 20.0
        self.btnTakeMeHere.cornerRadius = 10.0
        
        let screenWidth = UIScreen.main.bounds.width - 36
        self.vwWidth.constant = screenWidth
        
        self.lblWolooTitle.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        self.lblWolooOpenNow.font = UIFont(name: "CenturyGothic-Bold", size: 8)
        self.btnTakeMeHere.titleLabel?.font = UIFont(name: "CenturyGothic-Bold", size: 8)
        
        
    }

    func configureDashboardCollectionViewCell(objNearbyResultsModel : NearbyResultsModel?, strTransportType: String?){
        self.objobjNearbyResultsModel = objNearbyResultsModel ?? NearbyResultsModel()
        print("strTransportType",strTransportType ?? "")
        
        if strTransportType == TransportType.CAR.rawValue {
            
            self.imgTransportTypeSelected.image = UIImage(named: "icon_car")
        }
       else  if strTransportType == TransportType.BIKE.rawValue {
            self.imgTransportTypeSelected.image = UIImage(named: "icon_bike")
        }
        else if strTransportType == TransportType.WALK.rawValue {
            self.imgTransportTypeSelected.image = UIImage(named: "icon_walk")
        }

        if (self.objobjNearbyResultsModel.woloo_type == "Powder Room"){
            self.vwBack.backgroundColor = UIColor(named: "Woloo_Yellow")
            self.lblWolooTitle.textColor = UIColor.black
            self.lblTime.textColor = UIColor.black
            self.lblWolooOpenNow.textColor = UIColor.black
            self.vwBackTakeMeHere.backgroundColor = UIColor.white
            
           
        }
        else{
            
            self.vwBack.backgroundColor = UIColor.black
            self.lblWolooTitle.textColor = UIColor(named: "Woloo_Yellow")
            self.lblWolooOpenNow.textColor = UIColor(named: "Woloo_Yellow")
            self.vwBackTakeMeHere.backgroundColor = UIColor(named: "Woloo_Yellow")
            self.lblTime.textColor = UIColor(named: "Woloo_Yellow")
        }
        
        if self.objobjNearbyResultsModel.is_offer == 1{
            self.vwBackOfferVW.isHidden = false
        }
        else{
            self.vwBackOfferVW.isHidden = true
        }
        
        self.lblWolooTitle.text = self.objobjNearbyResultsModel.name ?? ""
        
        
        let isOpen = self.objobjNearbyResultsModel.is_open ?? 0
        self.lblWolooOpenNow.text = isOpen == 1 ? "Open Now" : "Closed"
                
        self.lblTime.text = self.objobjNearbyResultsModel.duration ?? ""
        print("Duration for nearby\(self.objobjNearbyResultsModel.duration ?? "")")
        
        if objobjNearbyResultsModel.image?.count ?? 0 > 0{
            let url = "\(objobjNearbyResultsModel.base_url ?? "")/\(objobjNearbyResultsModel.image?[0] ?? "")"
            let trimmedUrl = url.replacingOccurrences(of: " ", with: "")
            self.imgViewWoloo.sd_setImage(with: URL(string: trimmedUrl), completed: { (image, error, cacheType, imageURL) in
                if error != nil || image == nil {
                    self.imgViewWoloo.image = UIImage(named: "woloo_default")
                }
            })
        } else {
            self.imgViewWoloo.image = UIImage(named: "woloo_default")
        }
    }
    
    
    @IBAction func clickedBtnNavigate(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didClickedNavigate(obj: self.objobjNearbyResultsModel)
        }
    }
    
}
