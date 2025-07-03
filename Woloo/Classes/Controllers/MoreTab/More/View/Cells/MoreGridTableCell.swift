//
//  MoreGridTableCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 16/01/25.
//

import UIKit

protocol MoreGridTableCellProtocol: NSObjectProtocol{
    
    func didClickedPeriodManagement()
    func didClickedThirstReminder()
    func didClickedSayItWoloo()
    func didClickedPeersClubMembership()
    func didClickedRefer()
    func didClickedMyHistory()
    func didClickedOfferCart()
    func didClickedWolooGiftCard()
    func didClickedBecomeAWolooHost()
    func didClickedReferAWolooHost()
    func didClickedAbout()
    func didClickedTermsOfUse()
    
    
}


class MoreGridTableCell: UITableViewCell {
    
    @IBOutlet weak var lblPeriodManagement: UILabel!
    @IBOutlet weak var lblThirstReminder: UILabel!
    @IBOutlet weak var lblSayItWoloo: UILabel!
    @IBOutlet weak var lblPeersClubMembership: UILabel!
    
    @IBOutlet weak var lblRefer: UILabel!
    @IBOutlet weak var lblMyHistory: UILabel!
    @IBOutlet weak var lblOfferCart: UILabel!
    @IBOutlet weak var lblWolooGiftCard: UILabel!
    @IBOutlet weak var lblBecomeAWolooHost: UILabel!
    @IBOutlet weak var lblReferAWolooHost: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblTermsOfUse: UILabel!
    
    weak var delegate: MoreGridTableCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblPeriodManagement.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        lblThirstReminder.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        lblSayItWoloo.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        lblPeersClubMembership.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        lblRefer.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        lblMyHistory.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        lblOfferCart.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        lblWolooGiftCard.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        lblBecomeAWolooHost.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        lblReferAWolooHost.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        lblAbout.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        lblTermsOfUse.font = UIFont(name: "CenturyGothic-Bold", size: 12)
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func clickedBtnPeriodManagement(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedPeriodManagement()
        }
    }
    
    @IBAction func didClickedThirstReminder(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedThirstReminder()
        }
    }
    
    
    @IBAction func didClickedSayItWoloo(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedSayItWoloo()
        }
    }
    
    
    @IBAction func didClickedBuyPeersMembership(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedPeersClubMembership()
        }
    }
    
    @IBAction func didClickedRefer(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedRefer()
        }
    }
    
    @IBAction func didClickedHistory(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedMyHistory()
        }
    }
    
    @IBAction func didClickedOfferCart(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedOfferCart()
        }
    }
    
    @IBAction func didClickedWolooGiftCard(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedWolooGiftCard()
        }
    }
    
    @IBAction func didClickedBecomeAWolooHost(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedBecomeAWolooHost()
        }
    }
    
    
    @IBAction func didClikckedReferAWolooHost(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedReferAWolooHost()
        }
    }
    
    
    
    @IBAction func didClickedAbout(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedAbout()
        }
    }
    
    @IBAction func didClickedTermsOfUse(_ sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.didClickedTermsOfUse()
        }
    }
    
}

