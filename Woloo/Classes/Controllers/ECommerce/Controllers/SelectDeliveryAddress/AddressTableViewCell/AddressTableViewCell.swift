//
//  AddressTableViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 03/08/21.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    
    static let HEIGHT: CGFloat = 50
    
    //MARK:- Outlets
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    var address: Address? {
        didSet {
            addressLabel.text = address?.getAddress ?? ""
            radioButton.layer.cornerRadius = (radioButton.frame.height / 2)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        radioButton.layer.cornerRadius = (radioButton.frame.height / 2)
        radioButton.layer.borderWidth = 1
        radioButton.layer.borderColor = UIColor.blue.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    class func loadNib() -> UINib? {
        UINib(nibName: "AddressTableViewCell", bundle: .main)
    }
}
