//
//  PeriodEssentialsCell.swift
//  Woloo
//
//  Created by CEPL on 07/03/25.
//

import UIKit

protocol PeriodEssentialsCellDelegate: NSObject{
    
    func didSelectedCategories(objCategory: StoreProductCategories?)
}


class PeriodEssentialsCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listPeriodEssentials = [StoreProductCategories]()
    weak var delegate: StoreCategoriesTblCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(PeriodEssentialsCollectionCell.nib, forCellWithReuseIdentifier: PeriodEssentialsCollectionCell.identifier)
    }

    
    func configurePeriodEssentialsCell(listPeriodEssentials: [StoreProductCategories]?){
        self.listPeriodEssentials = listPeriodEssentials ?? [StoreProductCategories]()
        self.collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension PeriodEssentialsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listPeriodEssentials.count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeriodEssentialsCollectionCell.identifier, for: indexPath) as? PeriodEssentialsCollectionCell ?? PeriodEssentialsCollectionCell()
            //fillCategoryCell(cell,indexPath.item)'
        cell.configureShopCell(objStoreProductCategories: self.listPeriodEssentials[indexPath.item])
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate?.didSelectedCategories(objCategory: self.listPeriodEssentials[indexPath.item])
        }
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 3, height: self.collectionView.frame.height)
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
