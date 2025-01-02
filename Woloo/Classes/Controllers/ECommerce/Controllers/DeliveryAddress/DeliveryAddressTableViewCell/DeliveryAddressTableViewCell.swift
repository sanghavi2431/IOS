//
//  DeliveryAddressTableViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 03/08/21.
//

import UIKit

class DeliveryAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var phoneLbel: UILabel!
    @IBOutlet weak var mainAddressLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var deleteCompletion: ((Address?) -> Void)?
    
    var address: Address? {
        didSet {
            mainAddressLabel.text = address?.getAddress ?? ""
            phoneLbel.text = "Phone: \(address?.phone ?? "")"
            deleteButton.addTarget(self, action: #selector(tappedOnDeleteButton), for: .touchUpInside)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @objc private
    func tappedOnDeleteButton() {
        deleteCompletion?(address)
    }
}
