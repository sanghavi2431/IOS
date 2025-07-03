//
//  MenuItemsCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 24/10/24.
//

import UIKit

class MenuItemsCell: UITableViewCell {

    var sectionType:MoreSectionType?{
        didSet{
            configureUI()
        }
    }
    
    @IBOutlet weak var sectionImage: UIImageView!
    @IBOutlet weak var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI()  {
     
        if let sectionType = sectionType{
            self.sectionImage?.image = UIImage(named: sectionType.imageName)
            self.sectionLabel?.text = sectionType.title
        }
    }
    
    func configureMenuItemsCell(currentIndexPath: IndexPath){

        switch currentIndexPath.row{
            
        case 0:
            self.sectionImage.image = UIImage.init(named: "icon_buy_membership")
            self.sectionLabel.text = "Buy Pee’rs Club Membership"
            
        case 1:
            self.sectionImage.image = UIImage.init(named: "icon_refer")
            self.sectionLabel.text = "Refer"
            
        case 2:
            self.sectionImage.image = UIImage.init(named: "icon_history")
            self.sectionLabel.text = "My History"
            
        case 3:
            self.sectionImage.image = UIImage.init(named: "icon_offer")
            self.sectionLabel.text = "Offer Cart"
            
        case 4:
            self.sectionImage.image = UIImage.init(named: "icon_giftCard")
            self.sectionLabel.text = "Woloo Gift-Card"
            
        case 5:
            self.sectionImage.image = UIImage.init(named: "icon_wolooHost")
            self.sectionLabel.text = "Become a Woloo Host"
            
        case 6:
            self.sectionImage.image = UIImage.init(named: "icon_referWolooHost")
            self.sectionLabel.text = "Refer a Woloo Host"
            
        case 7:
            self.sectionImage.image = UIImage.init(named: "icon_About")
            self.sectionLabel.text = "About"
            
        case 8:
            self.sectionImage.image = UIImage.init(named: "icon_terms")
            self.sectionLabel.text = "Terms Of Use"
            
        case 9:
            self.sectionImage.image = UIImage.init(named: "icon_logout")
            self.sectionLabel.text = "Logout"
            
        default:
            break
        }
        
    }
    
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
