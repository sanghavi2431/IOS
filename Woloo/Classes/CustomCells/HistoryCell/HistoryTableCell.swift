//
//  HistoryTableCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 05/11/24.
//

import UIKit

protocol BookmarkTableCellDelegate: NSObjectProtocol
{
    func didClickedNavigate(obj: NearbyResultsModel)
    
    
}

protocol HistoryTableCellDelegate: NSObjectProtocol
{
    func didClickedNavigate(obj: History)
    
    
}


class HistoryTableCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblWolooName: UILabel!
    @IBOutlet weak var lblWolooAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lbldistance: UILabel!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var vwBackCibil: UIView!
    @IBOutlet weak var lblCibilScore: UILabel!
    
    weak var delegateBookmark: BookmarkTableCellDelegate?
    weak var delegateHistory: HistoryTableCellDelegate?
    var objhistory = History()
    var objNearBy = NearbyResultsModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBack.cornerRadius = 25.0
        self.imgView.cornerRadius = 25.0
        self.vwBackCibil.cornerRadius = 18.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureHistoryTableCell(objhistory: History?){
     
        
        self.objhistory = objhistory ?? History()
        let detail = self.objhistory.woloo_details
        
        lblWolooName.text = detail.name ?? ""
        lblWolooAddress.text = detail.address ?? ""
        self.lblTime.text = "2.3 Hrs"
        self.lbldistance.text = "5 kms"
        
        if let images = detail.image , images.count > 0 {
            let imageUrl = images.first
            if imageUrl?.count ?? 0 > 0 {
                let url = "\(detail.base_url ?? "")\(imageUrl ?? "")"
                print("imgUrl: ", url ?? "")
                self.imgView.sd_setImage(with: URL(string: url), completed: nil)
            }
        }
    }
    
    func configureBookmarkTableCell(objNearBy: NearbyResultsModel?){
        
        
        self.objNearBy = objNearBy ?? NearbyResultsModel()
        
        self.lblWolooName.text = self.objNearBy.name ?? ""
        self.lblWolooAddress.text = self.objNearBy.address ?? ""
        
        self.lblTime.text = self.objNearBy.duration ?? ""
        self.lbldistance.text = self.objNearBy.distance ?? ""
        self.lblCibilScore.text = self.objNearBy.cibil_score ?? ""
        self.vwBackCibil.backgroundColor = UIColor(hexString:  self.objNearBy.cibil_score_colour ?? "#FFFFFF")
        
        if let images = self.objNearBy.image , images.count > 0 {
            let imageUrl = images.first
            if imageUrl?.count ?? 0 > 0 {
                let url = "\(self.objNearBy.base_url ?? "")\(imageUrl ?? "")"
                print("imgUrl: ", url ?? "")
                self.imgView.sd_setImage(with: URL(string: url), completed: nil)
            }
        }
    }
    
    //MARK: - Button Action methods
    @IBAction func clickedBtnNavigate(_ sender: UIButton) {
        if self.delegateBookmark != nil {
            self.delegateBookmark?.didClickedNavigate(obj: self.objNearBy)
        }
        else if self.delegateHistory != nil {
            self.delegateHistory?.didClickedNavigate(obj: self.objhistory)
        }
        
    }
    
}
