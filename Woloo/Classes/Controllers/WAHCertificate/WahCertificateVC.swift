//
//  WahCertificateVC.swift
//  Woloo
//
//  Created on 29/06/21.
//

import UIKit

class WahCertificateVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCertiNumber: UILabel!
    @IBOutlet weak var lblCertiDate: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var store: WolooStore?
    
    var objWahCertificate = WahCertificate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "ic_left_arrow")?.withTintColor(#colorLiteral(red: 0.2549019608, green: 0.2509803922, blue: 0.2588235294, alpha: 1))
        closeButton.setImage(image, for: .normal)
//        if let store = store {
//            fillData(store: store)
//        }
        
        fillData(store: objWahCertificate)
    }

    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fillData(store: WahCertificate) {
        self.lblName.text = store.name?.capitalized
        self.lblCertiNumber.text = store.code
        if let dateStr = store.created_at {
            let convertDate = dateStr.convertDateFormater(dateStr, inputFormate: "yyyy'-'MM'-'dd HH':'mm':'ss", outputFormate: "dd-MMM-yyyy")
            self.lblCertiDate.text = convertDate
        }
    }
}
