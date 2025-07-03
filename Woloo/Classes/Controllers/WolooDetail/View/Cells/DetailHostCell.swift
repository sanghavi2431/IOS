//
//  DetailHostCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 07/11/24.
//

import UIKit

protocol DetailHostCellDelegate: NSObjectProtocol{
    
    func didSelectNavigationBtn(objNearbyResultsModel: NearbyResultsModel?)
    
    func didSelectBookmamrkBtn(objNearbyResultsModel: NearbyResultsModel?)
    
    func didSelectShareBtn(objNearbyResultsModel: NearbyResultsModel?)
    
    
}

class DetailHostCell: UITableViewCell {

    
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var lblLocationAddress: UILabel!
    @IBOutlet weak var lbldistance: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var vwNavigate: UIView!
    @IBOutlet weak var vwShare: UIView!
    @IBOutlet weak var vwBookmark: UIView!
    
    @IBOutlet weak var btnNavigation: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    
//    @IBOutlet weak var lblNavigate: UILabel!
//    @IBOutlet weak var lblShare: UILabel!
//    @IBOutlet weak var lblBookmark: UILabel!
//    
    var objNearbyResultsModel = NearbyResultsModel()
    var delegate : DetailHostCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.roundCorners(corners: [.topLeft], radius: 20.0)
        
        let btnNavigationWidth = vwNavigate.frame.size.width
        let btnNavigationHeight = vwNavigate.frame.size.height

        if btnNavigationWidth < btnNavigationHeight{
            self.vwNavigate.cornerRadius = btnNavigationWidth / 5.7
        }
        else{
            self.vwNavigate.cornerRadius = btnNavigationHeight / 5.7
        }
       
      //  self.lblNavigate.font = UIFont(name: "CenturyGothic-Bold", size: 10)
         
        let btnShareWidth = vwShare.frame.size.width
        let btnShareHeight = vwShare.frame.size.height

        if btnShareWidth < btnShareHeight{
            self.vwShare.cornerRadius = btnShareWidth / 5.7
        }
        else{
            self.vwShare.cornerRadius = btnShareHeight / 5.7
        }
        
       // self.lblShare.font = UIFont(name: "CenturyGothic-Bold", size: 10)
        
        let btnBookmarkWidth = vwBookmark.frame.size.width
        let btnBookmarkHeight = vwBookmark.frame.size.height

        if btnBookmarkWidth < btnBookmarkHeight{
            self.vwBookmark.cornerRadius = btnBookmarkWidth / 5.7
        }
        else{
            self.vwBookmark.cornerRadius = btnBookmarkHeight / 5.7
        }
       
      //  self.lblBookmark.font = UIFont(name: "CenturyGothic-Bold", size: 10)
        
      //  self.lblLocationAddress.font = UIFont(name: "CenturyGothic-Bold", size: 18)
//        self.lbldistance.font = UIFont(name: "CenturyGothic-Bold", size: 18)
//        self.lblTime.font = UIFont(name: "CenturyGothic-Bold", size: 18)
//        self.lblHostName.font = UIFont(name: "CenturyGothic-Bold", size: 18)
        
    }

    override func layoutSubviews() {
            super.layoutSubviews()
        
        let width = vwBack.frame.size.width
        let height = vwBack.frame.size.height

        if width < height{
            
            let path = UIBezierPath(roundedRect: self.vwBack.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width:  width / 5.7, height:  width / 5.7)) // Set desired radius

            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            self.vwBack.layer.mask = maskLayer
        }
        else{
            
            let path = UIBezierPath(roundedRect: self.vwBack.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: height / 5.7, height: height / 5.7)) // Set desired radius

            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            self.vwBack.layer.mask = maskLayer
        }
        
    }
    
    
    func configureDetailHostCell(objNearbyResultsModel: NearbyResultsModel?){

        self.objNearbyResultsModel = objNearbyResultsModel ?? NearbyResultsModel()
        self.lblLocationAddress.text = self.objNearbyResultsModel.address ?? ""
        self.lblHostName.text = self.objNearbyResultsModel.name ?? ""
        
        self.lbldistance.text = self.objNearbyResultsModel.distance ?? ""
        
        self.lblTime.text = self.objNearbyResultsModel.timeByCar ?? ""
        
        if self.objNearbyResultsModel.is_liked == 1{
            self.btnBookmark.isSelected = true
            self.vwBookmark.backgroundColor = UIColor(named: "gray_selected_button_color")
          
        }
        else if self.objNearbyResultsModel.is_liked == 0{
            self.btnBookmark.isSelected = false
            self.vwBookmark.backgroundColor = UIColor(named: "yellow_button_color")
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedNavigationBtn(_ sender: Any) {
        
        if ((self.delegate) != nil){
            self.delegate?.didSelectNavigationBtn(objNearbyResultsModel: self.objNearbyResultsModel)
        }
        
    }
    
    @IBAction func clickedShareBtn(_ sender: Any) {
        
        if ((self.delegate) != nil){
            self.delegate?.didSelectShareBtn(objNearbyResultsModel: self.objNearbyResultsModel)
        }
        
    }
    
    @IBAction func clickedBookmarkBtn(_ sender: Any) {
        self.btnBookmark.isSelected = !self.btnBookmark.isSelected
       
        if self.btnBookmark.isSelected == true
        {
            self.objNearbyResultsModel.is_liked = 1
        }
        else  if self.btnBookmark.isSelected == false{
            self.objNearbyResultsModel.is_liked = 0
        }
        
        
        if ((self.delegate) != nil){
            self.delegate?.didSelectBookmamrkBtn(objNearbyResultsModel: self.objNearbyResultsModel)
        }
        
    }
}
