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
    @IBOutlet weak var lblTimeWalk: UILabel!
    @IBOutlet weak var lblTimeBike: UILabel!
    @IBOutlet weak var lblTimeCar: UILabel!
    
    
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

    func configureShowMoreTableCell(objNearbyResultsModel : NearbyResultsModel?){
        self.objNearbyResultsModel = objNearbyResultsModel ?? NearbyResultsModel()
        
        if (self.objNearbyResultsModel.woloo_type == "Woloo Host"){
            self.vwBack.backgroundColor = UIColor.black
            self.lblWolooTitle.textColor = UIColor(named: "Woloo_Yellow")
            self.lblWolooOpenNow.textColor = UIColor(named: "Woloo_Yellow")
            self.lblTimeWalk.textColor = UIColor(named: "Woloo_Yellow")
            self.lblTimeBike.textColor = UIColor(named: "Woloo_Yellow")
            self.lblTimeCar.textColor = UIColor(named: "Woloo_Yellow")
        }
        else{
            self.vwBack.backgroundColor = UIColor(named: "Woloo_Yellow")
            self.lblWolooTitle.textColor = UIColor.black
            self.lblWolooOpenNow.textColor = UIColor.black
            self.lblTimeWalk.textColor = UIColor.black
            self.lblTimeBike.textColor = UIColor.black
            self.lblTimeCar.textColor = UIColor.black
        }
        
        
        if self.objNearbyResultsModel.is_offer == 1{
            self.vwBackIsOffer.isHidden = false
        }
        else{
            self.vwBackIsOffer.isHidden = true
        }
        
        self.lblWolooTitle.text = self.objNearbyResultsModel.name ?? ""
            //self.lblWolooOpenNow.text = "Open Now"
        
        if self.objNearbyResultsModel.is_open == 1{
            self.lblWolooOpenNow.text = "Open Now"
        }
        else{
            self.lblWolooOpenNow.text = "Closed"
        }
        
        self.lblTimeWalk.text = self.objNearbyResultsModel.timeByWalk ?? ""
        self.lblTimeBike.text = self.objNearbyResultsModel.timeByBike ?? ""
        self.lblTimeCar.text = self.objNearbyResultsModel.timeByCar ?? ""
        
        if self.objNearbyResultsModel.image?.count ?? 0 > 0{
            let url = "\(self.objNearbyResultsModel.base_url ?? "")/\(self.objNearbyResultsModel.image?[0] ?? "")"
            let trimmedUrl = url.replacingOccurrences(of: " ", with: "")
            self.imgViewWoloo.sd_setImage(with: URL(string: trimmedUrl), completed: nil)
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
