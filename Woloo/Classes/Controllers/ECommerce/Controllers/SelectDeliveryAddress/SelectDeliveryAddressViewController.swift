//
//  SelectDeliveryAddressViewController.swift
//  Woloo
//
//  Created by Rahul Patra on 03/08/21.
//

import UIKit

class SelectDeliveryAddressViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var mainTableViewHeight: NSLayoutConstraint!
    
    //MARK:- variables
    var persistance: SelectDeliveryPersistance? = SelectDeliveryPersistance()
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        getDelieveryAddress()
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        updateHeight()
    }
    
    //MARK:- Custom functions
    func setViews() {
        outerView.layer.cornerRadius = 24
        outerView.layer.masksToBounds = true
        
        mainTableView.register(AddressTableViewCell.loadNib(), forCellReuseIdentifier: "AddressTableViewCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        persistance?.footerView?.type = .add
        persistance?.footerView?.addAddressButton.addTarget(self, action: #selector(tappedOnAddAddressbutton), for: .touchUpInside)
        mainTableView.reloadData()
        updateHeight()
    }
    
    /// Getting Delivery address
    func getDelieveryAddress() {
        persistance?.getAddressList{ [weak self] isSuccess, message in
            if isSuccess {
                if self?.persistance?.address?.count ?? 0 == 0 {
                    self?.persistance?.footerView?.type = .save
                } else {
                    self?.persistance?.footerView?.type = .add
                }
                
                
                self?.mainTableView.reloadData()
                self?.updateHeight()
            }
        }
    }
    
    func updateHeight() {
        mainTableViewHeight.constant = mainTableView.contentSize.height
    }
    
    func updateHeight(withHeght height: CGFloat) {
        mainTableViewHeight.constant = mainTableView.contentSize.height + height
    }
    
    //MARK:- Action
    @objc
    func tapCrossButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func tappedOnAddAddressbutton() {
        persistance?.changeStatus(.save)
        mainTableView.reloadData()
    }
}

extension SelectDeliveryAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persistance?.address?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView.loadNib()
        headerView?.crossButton.addTarget(self, action: #selector(tapCrossButton), for: .touchUpInside)
        headerView?.enterdOTPTCompletion = { [weak self] otp in
            self?.dismiss(animated: true) {
                self?.persistance?.selectedAddressCompletion?(Address(id: "", userID: "", name: "", phone: "", pincode: otp, city: "", state: "", area: "", flatBuilding: "", landmark: "", dateTime: "", status: ""))
            }
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return persistance?.footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return persistance?.footerView?.getHeight() ?? 20
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return persistance?.footerView?.getHeight() ?? 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        cell.address = persistance?.address?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.persistance?.selectedAddressCompletion?(self.persistance?.address?[indexPath.row])
        }
    }
}
