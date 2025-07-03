//
//  WAHCertificateNoCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 08/11/24.
//

import UIKit

class WAHCertificateNoCell: UITableViewCell {

    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.vwBack.cornerRadius = 10
//        self.vwBack.layer.borderWidth = 1.0
       // se
    }
    
    func configureWahCertificateNumber(objWahCertificate: WahCertificate?){
        
        self.lblTitle.text = "Certificate No."
        self.lblDesc.text = objWahCertificate?.code ?? ""
    }
    
    func configureWahCertificateDate(objWahCertificate: WahCertificate?){
        
        self.lblTitle.text = "Date of Certification"
        if let dateStr = objWahCertificate?.created_at {
            let convertDate = dateStr.convertDateFormater(dateStr, inputFormate: "yyyy'-'MM'-'dd HH':'mm':'ss", outputFormate: "dd-MMM-yyyy")
            self.lblDesc.text = convertDate
        }
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
