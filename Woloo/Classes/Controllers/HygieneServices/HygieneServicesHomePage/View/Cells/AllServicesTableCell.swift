//
//  AllServicesTableCell.swift
//  Woloo
//
//  Created by CEPL on 26/04/25.
//

import UIKit

protocol AllServicesTableCellDelegate: NSObject{
    
    func didSelectAllServiceCategory(objCategory: StoreProductCategories?)
}

class AllServicesTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listServicesCategories = [StoreProductCategories]()
    weak var delegate: AllServicesTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(AllServiceCollectionCell.nib, forCellWithReuseIdentifier: AllServiceCollectionCell.identifier)
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureAllServicesTableCell(listServiceCategories: [StoreProductCategories]?){
        self.listServicesCategories = listServiceCategories ?? [StoreProductCategories]()
        self.collectionView.reloadData()
    }
}

extension AllServicesTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Hygiene Services count: \(self.listServicesCategories.count)")
        return self.listServicesCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {//
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllServiceCollectionCell.identifier, for: indexPath) as? AllServiceCollectionCell ?? AllServiceCollectionCell()
        //fillCategoryCell(cell,indexPath.item)
        cell.configureAllServiceCollectionCell(objStoreProductCategories: self.listServicesCategories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Selected Service Category",self.listServicesCategories[indexPath.item].id ?? "")
        if self.delegate != nil {
            self.delegate?.didSelectAllServiceCategory(objCategory: self.listServicesCategories[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/3, height: 120)
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
