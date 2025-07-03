//
//  StoreShowAllBrandVWExtension.swift
//  Woloo
//
//  Created by CEPL on 15/04/25.
//

import Foundation
import UIKit

extension StoreShowAllBrandVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AllProductsCollectionCellDelegate{
    
    
    //MARK: - AllProductsCollectionCellDelegate
    func didClickedBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - UIcollection view delegate and datasource methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 2{
            return self.listBrands.count
        }
        else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllProductsCollectionCell.identifier, for: indexPath) as? AllProductsCollectionCell ?? AllProductsCollectionCell()
            //fillCategoryCell(cell,indexPath.item)
            cell.lblTitle.text = "All Brands"
            cell.delegate = self
            return cell
        }
        else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreBrandCollectionViewCell.identifier, for: indexPath) as? StoreBrandCollectionViewCell ?? StoreBrandCollectionViewCell()
            
            cell.configureStoreBrandCollectionViewCell(objBrand: self.listBrands[indexPath.item])
//            cell.delegate = self
//            cell.configureAllProductCollectionCell(objProducts: self.listProducts[indexPath.row])
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreBlankHeaderCollectionCell.identifier, for: indexPath) as? StoreBlankHeaderCollectionCell ?? StoreBlankHeaderCollectionCell()
            //fillCategoryCell(cell,indexPath.item)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Clicked on branc collection id: ", self.listBrands[indexPath.item].id ?? "")
        let objController = StoreShowAllProductVC.init(nibName: "StoreShowAllProductVC", bundle: nil)
        
        objController.strIsComeFrom = "BRANDS"
        objController.objBrands = self.listBrands[indexPath.item]
        
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 2{
            return CGSize(width: self.collectionview.frame.width/3, height: 126)
        }
        else if indexPath.section == 1{
            return CGSize(width: self.collectionview.frame.width, height: 53)
        }
        else{
            return CGSize(width: self.collectionview.frame.width/2, height: 128)
        }
       
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

