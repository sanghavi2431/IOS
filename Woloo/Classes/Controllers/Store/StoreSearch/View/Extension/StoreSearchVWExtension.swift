//
//  StoreSearchVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 30/01/25.
//

import Foundation
import UIKit

extension StoreSearchViewController: UITableViewDelegate, UITableViewDataSource,StoreSearchViewModelDelegate{
   
    //MARK: - StoreSearchViewModelDelegate
    
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper) {
        print("list", objResponse.products?.count ?? 0)
        DispatchQueue.main.async {
            self.searchListProducts = objResponse.products ?? [Products]()
            self.tableView.reloadData()
        }
       
    }
    
    func didReceievGetProductListAPIError(strError: String) {
        print(strError)
    }
    
    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchListProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: StoreSearchListCelll? = tableView.dequeueReusableCell(withIdentifier: "StoreSearchListCelll") as! StoreSearchListCelll?
        
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("StoreSearchListCelll", owner: self, options: nil)?.last as? StoreSearchListCelll)
        }
        
        cell?.configureStoreSearchListCelll(objProducts: self.searchListProducts[indexPath.row])
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objController = StoreItemDetailsVC.init(nibName: "StoreItemDetailsVC", bundle: nil)
        //objController.delegate = self
        objController.objProduct = searchListProducts[indexPath.row]
        objController.listAddress = self.listAddress
        objController.objSelectedAddress = self.objSelectedAddress
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
}
