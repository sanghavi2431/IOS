//
//  SelectAdressPopUpViewController.swift
//  Woloo
//
//  Created by CEPL on 09/03/25.
//

import UIKit

protocol SelectAdressPopUpViewControllerDelegate: NSObjectProtocol{
    func didChangesAdress(objAddress: StoreAddress?)
    
    func didAddAddress()
    
    func didAddressDeleted()
    
    func didSelectadress(objAddress: StoreAddress?)
}

class SelectAdressPopUpViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    var listAddress = [StoreAddress]()
    var objAddress = StoreAddress()
    var objSelectedAddress = StoreAddress()
    var delegate: SelectAdressPopUpViewControllerDelegate?
    var objSelectAddressPopUpViewModel = SelectAddressPopUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }



    func loadInitialSettings(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.objSelectAddressPopUpViewModel.delegate = self
        
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        
        if self.listAddress.count == 0 {
            self.lblNoDataFound.isHidden = false
        }
        
        for i in 0..<(self.listAddress.count) {
            if self.listAddress[i].id == self.objAddress.id {
                self.listAddress[i] = self.objAddress
                self.listAddress[i].isSelected = true
                //self.objAddress = objAddress
            }
            else{
                self.listAddress[i].isSelected = false
            }
        }
        self.tableView.reloadData()
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedAddAddress(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.didAddAddress()
            self.dismiss(animated: true)
        }
        
    }
    
    @IBAction func clickedSelectAddress(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didSelectadress(objAddress: self.objAddress)
            self.dismiss(animated: true)
        }
    }
}
