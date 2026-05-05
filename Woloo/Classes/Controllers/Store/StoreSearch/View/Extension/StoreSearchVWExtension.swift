//
//  StoreSearchVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 30/01/25.
//

import Foundation
import UIKit

extension StoreSearchViewController: UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,StoreSearchViewModelDelegate{
    
    
    //MARK: - StoreSearchViewModelDelegate
    
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper) {
        print("list prod count", objResponse.products?.count ?? 0)
        DispatchQueue.main.async {
            if Utility.isEmpty(self.strSearch ?? ""){
                self.searchListProducts = [Products]()
            }
            else{
                self.searchListProducts = objResponse.products ?? [Products]()
            }
            print("self.strSearch", self.strSearch ?? "")
            self.tableView.reloadData()
            self.collectionView.reloadData()
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
        
        if self.searchListProducts.count > 0{
            cell?.configureStoreSearchListCelll(objProducts: self.searchListProducts[indexPath.row])
        }
        
        
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let objController = StoreItemDetailsVC.init(nibName: "StoreItemDetailsVC", bundle: nil)
        //objController.delegate = self
        // Get existing saved products
        let tappedProduct = searchListProducts[indexPath.item]
        self.txtField.text = searchListProducts[indexPath.item].title ?? ""
        self.strSearch = searchListProducts[indexPath.item].title ?? ""
        self.objStoreSearchViewModel.getSearchProductListAPI(strSearchText: searchListProducts[indexPath.item].title ?? "")
        var savedProducts = UserDefaultsManager().getRecentSearchesFromUserDefaults()
        // Avoid duplicates
        if !savedProducts.contains(where: { $0.id == tappedProduct.id }) {
            savedProducts.insert(tappedProduct, at: 0) // insert at beginning
        }
        // Limit to last 10 searches
        if savedProducts.count > 5 {
            savedProducts = Array(savedProducts.prefix(10))
        }
        
        UserDefaultsManager().saveRecentSearchesToUserDefaults(savedProducts)
        self.recentSearchProducts = UserDefaultsManager().getRecentSearchesFromUserDefaults()
        self.collectionView.reloadData()
        self.tableView.reloadData()
        self.tableView.isHidden = true
        
        //        objController.objProduct = searchListProducts[indexPath.row]
        //        objController.listAddress = self.listAddress
        //        objController.objSelectedAddress = self.objSelectedAddress
        //        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    //MARK: - UIcollectionviewdelegate and datasource methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? recentSearchProducts.count : searchListProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0{
            return collectionView.dequeueReusableCell(withReuseIdentifier: StoreRecentSearchCollectionCell.identifier, for: indexPath)
        }
        else{
            return collectionView.dequeueReusableCell(withReuseIdentifier: StoreMostPurchaseCollectionCell.identifier, for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            self.txtField.text = recentSearchProducts[indexPath.item].title ?? ""
            self.objStoreSearchViewModel.getSearchProductListAPI(strSearchText: recentSearchProducts[indexPath.item].title ?? "")
        }
        else if indexPath.section == 1{
            let objController = StoreItemDetailsVC.init(nibName: "StoreItemDetailsVC", bundle: nil)
            //objController.delegate = self
            objController.objProduct = searchListProducts[indexPath.row]
            objController.listAddress = self.listAddress
            objController.objSelectedAddress = self.objSelectedAddress
            self.navigationController?.pushViewController(objController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            guard let cell = cell as? StoreRecentSearchCollectionCell else { print("StoreRecentSearchCollectionCell not available"); return }
            
            cell.configureStoreRecentSearchCollectionCell(objSearch: self.recentSearchProducts[indexPath.item])
        }
        else {
            guard let cell = cell as? StoreMostPurchaseCollectionCell else { print("StoreMostPurchaseCollectionCell not available"); return }
            
            cell.configureAllProductCollectionCell(objProducts: self.searchListProducts[indexPath.item], listCartItems: self.listCartItems)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "CollectionHeaderView",
                for: indexPath) as! CollectionHeaderView
            
            if indexPath.section == 0 {
                headerView.titleLabel.text = "Recently Searched"
            } else {
                headerView.titleLabel.text = "Based on your Recent Searches"
            }
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize.init(width: widthForView(text: self.recentSearchProducts[indexPath.item].title ?? "") + 60, height: 36.0)
        }
        else{
            return CGSize(width: self.collectionView.frame.width/3, height: 200)
        }
        
    }
    
    func widthForView(text:String) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width:  CGFloat.greatestFiniteMagnitude, height: 44.0))
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = ThemeManager.Font.OpenSans_Semibold(size: 11.7)
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
