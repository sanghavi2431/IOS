//
//  ChoosePaymentVC.swift
//  Woloo
//
//  Created by Vivek shinde on 21/12/20.
//

import UIKit

enum PaymentType : String, CaseIterable{
    case card
    case netBanking
    case UPI
    case wallets
    
    
    var imageName : String{
        switch self {
        case .card:
            return "ic_card"
        case .netBanking:
            return "ic_net_banking"
        case .UPI:
            return "ic_upi"
        case .wallets :
            return "ic_wallets"
        }
    }
    var cardName : String{
        switch self {
        case .card:
            return "Card"
        case .netBanking:
            return "Net Banking"
        case .UPI:
            return "UPI"
        case .wallets:
            return "Wallets"
        }
    }
    
    
}




class ChoosePaymentVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var paymentArray : [PaymentType] = [.card,.netBanking,.UPI,.wallets]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }


    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
}


extension ChoosePaymentVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return paymentArray.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NativePaymentCell", for: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCalculationCell", for: indexPath)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardDetailCell", for: indexPath)
            return cell
        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardDetailCell", for: indexPath)
//            return cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTypeCell", for: indexPath) as! PaymentTypeCell
            cell.cardImageView.image = UIImage(named: paymentArray[indexPath.row].imageName)
            cell.cardName.text = paymentArray[indexPath.row].cardName
            return cell
        }
        
    }
    
    
}
