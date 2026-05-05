//
//  StoreNewBrandCell.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import UIKit

protocol StoreNewBrandCellDelegate: NSObject {
    func openProductListDetailView(objProduct: StoreProductCategories?)
}

class StoreNewBrandCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listProducts = [StoreProductCategories]()
    weak var delegate: StoreNewBrandCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(NewBrandCollectionCell.nib, forCellWithReuseIdentifier: NewBrandCollectionCell.identifier)
        collectionView.reloadData()
    }
    
    func configureStoreNewBrandCell(listProducts: [StoreProductCategories]?){
        self.listProducts = listProducts ?? [StoreProductCategories]()
        self.collectionView.reloadData()
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension StoreNewBrandCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listProducts.count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewBrandCollectionCell.identifier, for: indexPath) as? NewBrandCollectionCell ?? NewBrandCollectionCell()
            //fillCategoryCell(cell,indexPath.item)
        cell.configureNewBrandCollectionCell(objProducts: self.listProducts[indexPath.item])
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil{
            self.delegate?.openProductListDetailView(objProduct: self.listProducts[indexPath.item])
        }
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width - 32, height: 165)
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
