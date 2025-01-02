//
//  MyOrdersViewController.swift
//  Woloo
//
//  Created by Rahul Patra on 31/08/21.
//

import UIKit

class MyOrdersViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    
    var persistance: MyOrdersPersistance? = MyOrdersPersistance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        getMyProducts()
    }
    
    func getMyProducts() {
        persistance?.getMyProducts({ isSuccess, message in
            if isSuccess {
                self.mainTableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.mainTableView.reloadData()
                }
            }
        })
    }
    
    func returnOrder(withOrder order: MyOrder?) {
        persistance?.returnOrderWithOrder(order: order, completion: { [weak self] isSuccess, message in
            if isSuccess {
                self?.getMyProducts()
            }
        })
    }
    
    func setViews() {
        backButton.addTarget(self, action: #selector(tappedOnBackbutton), for: .touchUpInside)
        
        mainTableView.register(MyOrdersTableViewCell.loadNib(), forCellReuseIdentifier: "MyOrdersTableViewCell")
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    @objc
    func tappedOnBackbutton() {
        navigationController?.popViewController(animated: true)
    }
}


extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persistance?.myOrders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell") as! MyOrdersTableViewCell
        cell.myOrder = persistance?.myOrders?[indexPath.row]
        return cell
    }
}
