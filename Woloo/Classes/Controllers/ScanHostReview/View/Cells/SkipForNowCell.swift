//
//  SkipForNowCell.swift
//  Woloo
//
//  Created by CEPL on 11/10/25.
//

import UIKit

protocol SkipForNowCellProtocol: NSObjectProtocol{
    
    func clickedBtnSkipForNow()
    
}


class SkipForNowCell: UITableViewCell {

    
    @IBOutlet weak var btnSkipForNow: UIButton!
    
    weak var delegate: SkipForNowCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedBtnskip(_ sender: Any) {
        if self.delegate != nil{
            self.delegate?.clickedBtnSkipForNow()
        }
        
    }
    
    
}
