//
//  AddHostCell.swift
//  Woloo
//
//  Created by ideveloper2 on 10/07/21.
//

import UIKit

class AddHostCell: UITableViewCell {
    @IBOutlet weak var addButttonHeight: NSLayoutConstraint!
    var addWolooAction: (() -> Void)?
     @IBOutlet weak var lblReferWoloo: UILabel!
    
    @IBOutlet weak var bgImgVw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgImgVw.image = UIImage.gifFromAsset(named: "refer_a_host")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 }
    
    @IBAction func addWolooAction(_ sender: Any) {
       addWolooAction?()
    }
}
