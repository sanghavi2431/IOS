//
//  ReferHostCell.swift
//  Woloo
//
//  Created by ideveloper2 on 22/06/21.
//

import UIKit

class ReferHostCell: UITableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    
    var wolooStore: WolooStore? {
        didSet {
            if let store = wolooStore {
                fillDetail(store)
            }
        }
    }
    
    var wolooStoreV2: EnrouteListModel? {
        
        didSet {
            if let store = wolooStoreV2 {
                
            fillDetailV2(store)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        borderView.layer.cornerRadius = 20.0
        borderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.warmGrey.cgColor
        self.premiumLabel.layer.cornerRadius = 20.0
        self.premiumLabel.layer.maskedCorners = [.layerMinXMaxYCorner]
        self.premiumLabel.clipsToBounds = true
    }
    
}

// MARK: - Logics
extension ReferHostCell {
    func fillDetail(_ store: WolooStore) {
        nameLabel.text = store.name
        addressLabel.text = store.address
        
        if let status = store.status {
            switch status {
            case 0:
                premiumLabel.text = "Under Review"
                premiumLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9333333333, blue: 0, alpha: 1)
            case 1:
                premiumLabel.text = "Approved"
                premiumLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9333333333, blue: 0, alpha: 1)
            case 2:
                premiumLabel.text = "Rejected"
                premiumLabel.backgroundColor = #colorLiteral(red: 1, green: 0.3137254902, blue: 0.137254902, alpha: 1)
            default:
                break
            }
        }
        
        if let images = store.image , images.count > 0 {
            let imageUrl = images.first
            if imageUrl?.count ?? 0 > 0 {
                let url = "\(API.environment.baseURL)/storage/app/public/\(imageUrl ?? "")"
                self.bgImageView.sd_setImage(with: URL(string: url), completed: nil)
            }
        }
    }
    
    
    func fillDetailV2(_ store: EnrouteListModel) {
        nameLabel.text = store.name
        addressLabel.text = store.address
        
        if let status = store.status {
            switch status {
            case 0:
                premiumLabel.text = "Under Review"
                premiumLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9333333333, blue: 0, alpha: 1)
            case 1:
                premiumLabel.text = "Approved"
                premiumLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9333333333, blue: 0, alpha: 1)
            case 2:
                premiumLabel.text = "Rejected"
                premiumLabel.backgroundColor = #colorLiteral(red: 1, green: 0.3137254902, blue: 0.137254902, alpha: 1)
            default:
                break
            }
        }
        
        if let images = store.image , images.count > 0 {
            let imageUrl = images.first
            if imageUrl?.count ?? 0 > 0 {
                let url = "\(API.environment.baseURL)/storage/app/public/\(imageUrl ?? "")"
                self.bgImageView.sd_setImage(with: URL(string: url), completed: nil)
            }
        }
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
