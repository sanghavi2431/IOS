//
//  WahCertificateVC.swift
//  Woloo
//
//  Created on 29/06/21.
//

import UIKit
import STPopup

class WahCertificateVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCertiNumber: UILabel!
    @IBOutlet weak var lblCertiDate: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var store: WolooStore?
    
    var objWahCertificate = WahCertificate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        let image = UIImage(named: "ic_left_arrow")?.withTintColor(#colorLiteral(red: 0.2549019608, green: 0.2509803922, blue: 0.2588235294, alpha: 1))
        closeButton.setImage(image, for: .normal)

        fillData(store: objWahCertificate)
        
        //print("objWahCertificate.woloo?.status", objWahCertificate.woloo?.status)
        
        if objWahCertificate.status == 1{
            DispatchQueue.main.async{
                let objController = BlogsPointsPopUpVC(nibName: "BlogsPointsPopUpVC", bundle: nil)
                // objController.delegate = self
                objController.pointCount = "100"
                let popup = STPopupController(rootViewController: objController)
                popup.style = .bottomSheet
                popup.present(in: DELEGATE.window?.rootViewController ?? self)
            }
        }
        else{
            showToast(message: "Woloo Points Already Credited")
            print("woloo Points already credited")
        }
        
    }

    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fillData(store: WahCertificate) {
        self.lblName.text = store.woloo?.name?.capitalized
        self.lblCertiNumber.text = store.woloo?.code
        if let dateStr = store.woloo?.created_at {
            let convertDate = dateStr.convertDateFormater(dateStr, inputFormate: "yyyy'-'MM'-'dd HH':'mm':'ss", outputFormate: "dd-MMM-yyyy")
            self.lblCertiDate.text = convertDate
        }
    }
}
