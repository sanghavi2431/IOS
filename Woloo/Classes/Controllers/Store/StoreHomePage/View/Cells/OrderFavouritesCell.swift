//
//  OrderFavouritesCell.swift
//  Woloo
//
//  Created by CEPL on 02/04/25.
//

import UIKit

protocol OrderFavouritesCellDelegate: NSObjectProtocol{
    
    func didClickedBtnOrder()
    func didClickedBtnFavourite()
    
}

class OrderFavouritesCell: UITableViewCell {

    @IBOutlet weak var vwBackFavourite: UIView!
    @IBOutlet weak var vwBackOrder: UIView!
    
    weak var delegate: OrderFavouritesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.vwBackOrder.layer.cornerRadius = 7.89
        self.vwBackFavourite.layer.cornerRadius = 7.89
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedBtnOrder(_ sender: UIButton) {
        
        if (self.delegate != nil){
            self.delegate?.didClickedBtnOrder()
        }
    }
    
    @IBAction func clickedBtnFavourite(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didClickedBtnFavourite()
        }
    }
    
}
