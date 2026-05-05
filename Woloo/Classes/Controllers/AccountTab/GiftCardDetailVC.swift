//
//  GiftCardDetailVC.swift
//  Woloo
//
//  Created on 01/06/21.
//

import UIKit

class GiftCardDetailVC: UIViewController {

    @IBOutlet weak var lblCardText: UILabel!
    @IBOutlet weak var lblCardPoints: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblGiftNo: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgVwPic: UIImageView!
    @IBOutlet weak var lblSent: UILabel!
    
    var coinHistory = HistoryModel()
    
    var coinHistoryV2 = HistoryModelV2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    func setupUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss"
        let date = dateFormatter.date(from: coinHistoryV2.created_at ?? "") ?? Date()
        dateFormatter.dateFormat = "dd MMMM, hh:mm a"
        lblDate.text =  dateFormatter.string(from: date)
        lblCardPoints.text = coinHistoryV2.value
        lblCardText.text = coinHistoryV2.remarks
        if coinHistoryV2.transaction_type?.lowercased() == "cr" {
            lblSent.text = "Sent by"
            lblCardText.text = "Gift Card Received"
        } else if coinHistoryV2.transaction_type?.lowercased() == "dr" {
            lblSent.text = "Sent to"
        } else  {
            lblSent.text = "Sent"
        }
        let val = coinHistoryV2.message ?? ""
        lblDesc.text = val
        lblGiftNo.text = "Gift Card Id : \(coinHistory.id ?? 0)"
        lblName.text = coinHistoryV2.sender?.name ?? "Guest"
        lblMobile.text = coinHistoryV2.sender?.mobile ?? "N/A"//coinHistory.sentPhone
        print("Entered message: \(coinHistoryV2.message ?? "")")
        print("Entered desc: \(coinHistoryV2.historyTypeTitle)")
        
        if let avtar = coinHistoryV2.sender?.avatar, avtar.count > 0 {
            let url = "\(API.environment.baseURL)public/userProfile/\(avtar)"
            imgVwPic.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            imgVwPic.sd_setImage(with: URL(string: kUserPlaceholderURL), completed: nil)
        }
   }


    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
