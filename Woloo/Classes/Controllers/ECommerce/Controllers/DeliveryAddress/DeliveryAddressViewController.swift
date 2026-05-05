//
//  DeliveryAddressViewController.swift
//  Woloo
//
//  Created by Rahul Patra on 03/08/21.
//

import UIKit

class DeliveryAddressViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK:- Variables
    var persistance: DelieveryAddressesPersistance? = DelieveryAddressesPersistance()
    
    //MARK:- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
    }
    
    override
    func viewWillAppear(_ animated: Bool) {
        getAddress()
    }
    
    //MARK:- custom functions
    func setUI() {
        mainTableView.register(UINib(nibName: "DeliveryAddressTableViewCell", bundle: .main), forCellReuseIdentifier: "DeliveryAddressTableViewCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    func getAddress() {
        persistance?.getAddressList{ [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                self.mainTableView.reloadData()
            } else {
                self.showToast(message: message)
            }
        }
    }
    
    func deleteAddress(_ address: Address?) {
        persistance?.deleteAddress(address: address, completion: { [weak self] isSuccess, message in
            if isSuccess {
                self?.getAddress()
            } else {
                self?.showToast(message: message)
            }
        })
    }
    
    //MARK:- Action
    @objc
    func tapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func tapAddAddressButton(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK:- tableview delegates and datasource
extension DeliveryAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if persistance?.address?.count ?? 0 == 0 {
            tableView.setErrorSuccessMessage(withErrorType: .error("No Addresses Added."))
        } else {
            tableView.setErrorSuccessMessage(withErrorType: .removeMessage)
        }
        return persistance?.address?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "DeliveryAddressTableViewCell", for: indexPath) as! DeliveryAddressTableViewCell
        
        cell.address = persistance?.address?[indexPath.row]
        cell.defaultView.isHidden = !(indexPath.row == 0)
        cell.topView.isHidden = !(indexPath.row == 0)
        
        cell.deleteCompletion = { [weak self] address in
            guard let self = self else { return }
            self.showAlertWithActionOkandCancel(Title: "Woloo", Message: "Are you sure you want to delete this address", OkButtonTitle: "Yes", CancelButtonTitle: "No") { [weak self] in
                self?.deleteAddress(address)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = AddNewAddressXib.loadNib()
        footerView?.addButton.addTarget(self, action: #selector(tapAddAddressButton), for: .touchUpInside)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        self.persistance?.selectedAddressCompletion?(self.persistance?.address?[indexPath.row])
    }
}
