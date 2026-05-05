//
//  MoreTabOtherCell.swift
//  Woloo
//
//  Created by Vivek shinde on 21/12/20.
//

import UIKit

class MoreSectionCell: UITableViewCell {
 
    var sectionType:MoreSectionType?{
        didSet{
            configureUI()
        }
    }
    
    @IBOutlet weak var sectionImage: UIImageView!
    @IBOutlet weak var sectionLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func configureUI()  {
     
        if let sectionType = sectionType{
            
            self.sectionImage?.image = UIImage(named: sectionType.imageName)
            self.sectionLabel.text = sectionType.title
        }
    }
}
