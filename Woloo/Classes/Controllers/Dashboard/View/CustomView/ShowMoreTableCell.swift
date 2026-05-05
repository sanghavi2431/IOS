//
//  ShowMoreTableCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 25/01/25.
//

import UIKit

protocol ShowMoreTableCellDelegate: NSObjectProtocol{
    
    func didSelectTakeMeHere(objNearbyResultsModel: NearbyResultsModel?)
}

class ShowMoreTableCell: UITableViewCell {

    @IBOutlet weak var imgViewWoloo: UIImageView!
    @IBOutlet weak var lblWolooTitle: UILabel!
    @IBOutlet weak var lblWolooOpenNow: UILabel!
    @IBOutlet weak var btnNavigate: UIButton!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var vwBackIsOffer: UIView!
    @IBOutlet weak var imgTransportTypeSelected: UIImageView!
    
    @IBOutlet weak var vwBackTakeMeHere: UIView!
    
    @IBOutlet weak var lblTime: UILabel!
    
    
    var objNearbyResultsModel = NearbyResultsModel()
    weak var delegate: ShowMoreTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Initialization code
        self.imgViewWoloo.cornerRadius = 36.31
        //self.vwBackCibil.cornerRadius = 18.0
        self.vwBack.cornerRadius = 20.0
        self.btnNavigate.cornerRadius = 10.0
    }

    func configureShowMoreTableCell(objNearbyResultsModel : NearbyResultsModel?, strTransportType: String?){
        self.objNearbyResultsModel = objNearbyResultsModel ?? NearbyResultsModel()
        
        if strTransportType == TransportType.CAR.rawValue {
            
            self.imgTransportTypeSelected.image = UIImage(named: "icon_car")
        }
       else  if strTransportType == TransportType.BIKE.rawValue {
            self.imgTransportTypeSelected.image = UIImage(named: "icon_bike")
        }
        else if strTransportType == TransportType.WALK.rawValue {
            self.imgTransportTypeSelected.image = UIImage(named: "icon_walk")
        }
        
        self.lblTime.text = self.objNearbyResultsModel.duration ?? ""
        
        if (self.objNearbyResultsModel.woloo_type == "Powder Room"){
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
        
        
        if self.objNearbyResultsModel.is_offer == 1{
            self.vwBackIsOffer.isHidden = false
        }
        else{
            self.vwBackIsOffer.isHidden = true
        }
        
        self.lblWolooTitle.text = self.objNearbyResultsModel.name ?? ""
            //self.lblWolooOpenNow.text = "Open Now"
        
        let isOpen = self.objNearbyResultsModel.is_open ?? 0
        self.lblWolooOpenNow.text = isOpen == 1 ? "Open Now" : "Closed"
        

        if objNearbyResultsModel?.image?.count ?? 0 > 0{
            let url = "\(objNearbyResultsModel?.base_url ?? "")/\(objNearbyResultsModel?.image?[0] ?? "")"
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
        
        if (self.delegate != nil){
            self.delegate?.didSelectTakeMeHere(objNearbyResultsModel: self.objNearbyResultsModel)
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
