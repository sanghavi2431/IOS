//
//  StoreCategoriesTblCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 29/01/25.
//

import UIKit

protocol StoreCategoriesTblCellDelegate: NSObject{
    
    func didSelectedCategories(objCategory: StoreProductCategories?)
}

class StoreCategoriesTblCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listProductCategories = [StoreProductCategories]()
    weak var delegate: StoreCategoriesTblCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(CategoryNewCell.nib, forCellWithReuseIdentifier: CategoryNewCell.identifier)
        collectionView.reloadData()
    }

    func configureStoreCategoriesTblCell(listProductCategories: [StoreProductCategories]?){
        self.listProductCategories = listProductCategories ?? [StoreProductCategories]()
        self.collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension StoreCategoriesTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Categories count: \(self.listProductCategories.count)")
        return self.listProductCategories.count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryNewCell.identifier, for: indexPath) as? CategoryNewCell ?? CategoryNewCell()
            //fillCategoryCell(cell,indexPath.item)
        cell.configureShopCell(objStoreProductCategories: self.listProductCategories[indexPath.item])
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate?.didSelectedCategories(objCategory: self.listProductCategories[indexPath.item])
        }
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/4, height: self.collectionView.frame.height)
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
