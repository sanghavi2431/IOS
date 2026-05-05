//
//  ShowMoreButtonCell.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 16/06/23.
//

import UIKit

class ShowMoreButtonCell: UITableViewCell {

    @IBOutlet weak var showMoreBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBAction func showMoreBtnPressed(_ sender: UIButton) {
        
        
    }
}
