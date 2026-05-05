//
//  ScanWolooNameCell.swift
//  Woloo
//
//  Created by CEPL on 28/09/25.
//

import UIKit

class ScanWolooNameCell: UITableViewCell {

    
    @IBOutlet weak var lblHostelName: UILabel!
    
    var objWahCertificateDetail = WahCertificate()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureScanWolooNameCell(objWahCertificate: WahCertificate?){
        self.objWahCertificateDetail = objWahCertificate ?? WahCertificate()
        
        self.lblHostelName.text = self.objWahCertificateDetail.woloo?.name ?? "-"
        
    }
    
}
