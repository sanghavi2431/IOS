//
//  ShowMoreCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 24/01/25.
//

import UIKit

class ShowMoreCell: UICollectionViewCell {

    @IBOutlet weak var vwWidth: NSLayoutConstraint!
    
    weak var delegate: DashboardBottomSheetDelegate?
    
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
            self.delegate?.didSelectRadius(radius: 6)
        }
       
    }
    
    @IBAction func clickedbtn8kms(_ sender: UIButton) {
        
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 8)
        }
       
    }
    
    @IBAction func clickedBtn10kms(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 10)
        }
      
    }
    
    
    @IBAction func clickedBtn12kms(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 12)
        }
       
    }

}
