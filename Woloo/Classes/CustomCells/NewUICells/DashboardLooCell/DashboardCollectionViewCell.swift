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
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
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
        
//        self.lblTimeCar.font = UIFont(name: "CenturyGothic-Bold", size: 8)
//        self.lblTimeBike.font = UIFont(name: "CenturyGothic-Bold", size: 8)
//        self.lblTimeWalk.font = UIFont(name: "CenturyGothic-Bold", size: 8)
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
        else{
            self.imgTransportTypeSelected.image = UIImage(named: "icon_walk")
        }

        if (self.objobjNearbyResultsModel.woloo_type == "Woloo Host"){
            self.vwBack.backgroundColor = UIColor.black
            self.lblWolooTitle.textColor = UIColor(named: "Woloo_Yellow")
            self.lblWolooOpenNow.textColor = UIColor(named: "Woloo_Yellow")
//            self.lblTimeWalk.textColor = UIColor(named: "Woloo_Yellow")
//            self.lblTimeBike.textColor = UIColor(named: "Woloo_Yellow")
//            self.lblTimeCar.textColor = UIColor(named: "Woloo_Yellow")
        }
        else{
            self.vwBack.backgroundColor = UIColor(named: "Woloo_Yellow")
            self.lblWolooTitle.textColor = UIColor.black
            self.lblWolooOpenNow.textColor = UIColor.black
            
//            self.lblTimeWalk.textColor = UIColor.black
//            self.lblTimeBike.textColor = UIColor.black
//            self.lblTimeCar.textColor = UIColor.black
        }
        
        if self.objobjNearbyResultsModel.is_offer == 1{
            self.vwBackOfferVW.isHidden = false
        }
        else{
            self.vwBackOfferVW.isHidden = true
        }
        
        self.lblWolooTitle.text = self.objobjNearbyResultsModel.name ?? ""
        
        
        if self.objobjNearbyResultsModel.is_open == 1{
            self.lblWolooOpenNow.text = "Open Now"
        }
        else{
            self.lblWolooOpenNow.text = "Closed"
        }
        
        self.lblDistance.text = self.objobjNearbyResultsModel.distance ?? ""
        
        self.lblTime.text = self.objobjNearbyResultsModel.duration ?? ""
        
//        self.lblTimeWalk.text = self.objobjNearbyResultsModel.timeByWalk ?? ""
//        self.lblTimeBike.text = self.objobjNearbyResultsModel.timeByBike ?? ""
//        self.lblTimeCar.text = self.objobjNearbyResultsModel.timeByCar ?? ""
        
        if objobjNearbyResultsModel.image?.count ?? 0 > 0{
            let url = "\(objobjNearbyResultsModel.base_url ?? "")/\(objobjNearbyResultsModel.image?[0] ?? "")"
            let trimmedUrl = url.replacingOccurrences(of: " ", with: "")
            self.imgViewWoloo.sd_setImage(with: URL(string: trimmedUrl), completed: nil)
        }
      
        
//        self.lblDistance.text =  "\(self.objobjNearbyResultsModel.distance ?? "")"
//        self.lblTime.text = "\(self.objobjNearbyResultsModel.duration ?? "")"
//        self.lblCibilScore.text = self.objobjNearbyResultsModel.cibil_score ?? ""
        
    }
    
    
    @IBAction func clickedBtnNavigate(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didClickedNavigate(obj: self.objobjNearbyResultsModel)
        }
    }
    
}
