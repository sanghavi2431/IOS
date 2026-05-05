//
//  ShowMoreCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 24/01/25.
//

import UIKit


protocol ShowMoreCellDelegate: NSObjectProtocol {
    func didSelectRadius(radius: Int)
}

class ShowMoreCell: UICollectionViewCell {

    @IBOutlet weak var vwWidth: NSLayoutConstraint!
    
    weak var delegate: ShowMoreCellDelegate?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let screenWidth = UIScreen.main.bounds.width - 36
        self.vwWidth.constant = screenWidth
    }
    
    @IBAction func clickedbtn2kms(_ sender: UIButton) {
        
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 2)
        }
       
    }
    
    @IBAction func clickedBtn4kms(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 4)
        }
      
    }
    
    
    @IBAction func clickedBtn6kms(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 5)
        }
       
    }
    
    @IBAction func clickedbtn8kms(_ sender: UIButton) {
        
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 6)
        }
       
    }
    
}
