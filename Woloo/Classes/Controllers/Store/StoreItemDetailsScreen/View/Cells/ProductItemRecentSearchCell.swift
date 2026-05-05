//
//  ProductItemRecentSearchCell.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import UIKit

protocol ProductItemRecentSearchCellDelegate: NSObject{
    
    func didUpdateProductQuantity(objproduct: Products?, strType: String?, listCart: [CartItems]?)
    
}


class ProductItemRecentSearchCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listProducts = [Products]()
    var listCartItems = [CartItems]()
     
    weak var delegate: ProductItemRecentSearchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(StoreMostPurchaseCollectionCell.nib, forCellWithReuseIdentifier: StoreMostPurchaseCollectionCell.identifier)
        collectionView.reloadData()
    }

    
    func configureProductItemRecentSearchCell(listProduct: [Products]?){
        self.listProducts = listProduct ?? [Products]()
        self.collectionView.reloadData()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ProductItemRecentSearchCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listProducts.count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreMostPurchaseCollectionCell.identifier, for: indexPath) as? StoreMostPurchaseCollectionCell ?? StoreMostPurchaseCollectionCell()
            //fillCategoryCell(cell,indexPath.item)
        cell.delegate = self
        cell.configureStoreMostPurchaseCollectionCell(objProducts: self.listProducts[indexPath.item], listCartItems: self.listCartItems)
            return cell
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 3, height: 200)
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


extension ProductItemRecentSearchCell: StoreMostPurchaseCollectionCellDelegate{
    
    
    func didUpdateProductQuantity(objproduct: Products?, strType: String?, listCart: [CartItems]?) {
        if self.delegate != nil{
            self.delegate?.didUpdateProductQuantity(objproduct: objproduct, strType: "Add", listCart: self.listCartItems)
        }
    }
    
    func didWishlishedItem(objProduct: Products?, strType: String?) {
        //
    }
    
    func didCallNotifyAPI(strVariantId: String?) {
        //
    }
}
