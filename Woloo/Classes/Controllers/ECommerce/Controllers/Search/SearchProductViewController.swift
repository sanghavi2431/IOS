//
//  SearchProductViewController.swift
//  Woloo
//
//  Created by Rahul Patra on 31/08/21.
//

import UIKit

class SearchProductViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet weak var maintableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var persistance: SearchProductPersistance? = SearchProductPersistance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
    }
    
    func setViews() {
        maintableView.register(SearchProductTableViewCell.loadNib(), forCellReuseIdentifier: "SearchProductTableViewCell")
        maintableView.delegate = self
        maintableView.dataSource = self
        
        searchBackView.layer.cornerRadius = searchBackView.frame.height / 2
        backButton.addTarget(self, action: #selector(tappedOnBackButton), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(editingStarted), for: .editingChanged)
        getSearchList()
    }
    
    func getSearchList() {
        persistance?.getSearchList({ [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                
            } else {
                self.showToast(message: message)
            }
        })
    }
    
    func searchProduct(withText text: String) {
        persistance?.searchProducts(withText: text, { [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                self.maintableView.reloadData()
            } else {
                self.showToast(message: message)
            }
        })
    }
    
    @objc
    func tappedOnBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func editingStarted(_ sender: UITextField) {
//        persistance?.search(withtext: searchTextField.text ?? "")
//        maintableView.reloadData()
        
        searchProduct(withText: sender.text ?? "")
        
    }
}


extension SearchProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persistance?.searchedProduct.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchProductTableViewCell") as! SearchProductTableViewCell
        cell.productImages = persistance?.productDetailsImages ?? []
        cell.product = persistance?.searchedProduct[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SearchProductTableViewCell.HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.persistance?.product = persistance?.products?[indexPath.item]
        let productId = persistance?.products?[indexPath.item].id ?? ""
        vc.persistance?.productImages = persistance?.productDetailsImages.filter { $0.productID ?? "" == productId  }.map { $0.img ?? "" } ?? []
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
