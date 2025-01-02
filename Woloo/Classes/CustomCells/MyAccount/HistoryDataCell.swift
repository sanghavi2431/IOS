//
//  HistoryDateCell.swift
//  Woloo
//
//  Created on 22/04/21.
//

import UIKit

class HistoryDataCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblCreditHistory: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblPointsStatic: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHeaderDate: UILabel!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillDataforDescription(_ model: HistoryModel) {
        self.imgIcon.image = model.imageTypeTitle
        self.lblCreditHistory.text = model.historyTypeTitle?.capitalized
    }
    
    func fillDataforDescriptionV2(_ model: HistoryModelV2) {
        self.imgIcon.image = model.imageTypeTitle
        self.lblCreditHistory.text = model.historyTypeTitle?.capitalized
    }
}
