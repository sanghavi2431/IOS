//
//  WahCell.swift
//  Woloo
//
//  Created by ideveloper2 on 09/06/21.
//

import UIKit

class WahCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    let label = "To become a Woloo Host, you need to have WAH (Woloo Assurance of Hygiene) certification. All Woloo washrooms are certified in association with the Toilet Board Coalition (A Global non-profit enterprise working under World Bank to improve sanitation standards across 40+ countries) & the Woloo Assurance of Hygiene (WAH) based on safety, hygiene & accessibility parameters.\n\nWoloo Assurance of Hygiene (WAH) is a symbol of commitment to every Woloo customer towards providing Safe, Hygienic & Accessible washrooms. The mission of WAH is to provide a compliance guide & certification for Woloo-Hosts (restaurants/QSR & other facilities) to improve the standard of hygiene & their toilet facility."

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = label
    }

}
