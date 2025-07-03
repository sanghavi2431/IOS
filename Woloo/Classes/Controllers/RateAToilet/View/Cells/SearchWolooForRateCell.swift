//
//  SearchWolooForRateCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 20/01/25.
//

import UIKit

protocol SearchWolooForRateCellProtocol: NSObjectProtocol{
    
    func didTappedSearchLocation()
}

class SearchWolooForRateCell: UITableViewCell {

    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var btnSearchLocation: UIButton!
    @IBOutlet weak var txtFieldLSearchLocation: UITextField!
    
    weak var delegate: SearchWolooForRateCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBack.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedSearchLocation(_ sender: UIButton) {
        
        if (self.delegate != nil){
            self.delegate?.didTappedSearchLocation()
        }
        
    }
}
