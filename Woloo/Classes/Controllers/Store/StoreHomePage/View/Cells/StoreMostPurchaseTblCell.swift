//
//  StoreMostPurchaseTblCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 30/01/25.
//

import UIKit

protocol StoreMostPurchaseTblCellDelegate: NSObjectProtocol{
    
    func didOpenAllRecentSearches()
    func openProductDetailView(objProduct: Products?)
    
    func didUpdateProductQuantity(objproduct: Products?, strType: String?)
}

class StoreMostPurchaseTblCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var listProducts = [Products]()
    var listCartItems = [CartItems]()
    
    weak var delegate: StoreMostPurchaseTblCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(StoreMostPurchaseCollectionCell.nib, forCellWithReuseIdentifier: StoreMostPurchaseCollectionCell.identifier)
        collectionView.reloadData()
    }

    
    func confgureStoreMostPurchaseTblCell(listProducts: [Products]?, listCartItems: [CartItems]?){
        self.listProducts = listProducts ?? [Products]()
        self.listCartItems = listCartItems ?? [CartItems]()
        
        self.collectionView.reloadData()
    }
    
    @IBAction func clickedSeeMoreBtn(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didOpenAllRecentSearches()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension StoreMostPurchaseTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StoreMostPurchaseCollectionCellDelegate {
    func didWishlishedItem(objProduct: Products?, strType: String?) {
        //
    }
    
    
    
    //MARK: - StoreMostPurchaseCollectionCellDelegate
    func didUpdateProductQuantity(objproduct: Products?, strType: String?) {
        print("Str  Type: ", strType ?? "")
        if self.delegate != nil {
            self.delegate?.didUpdateProductQuantity(objproduct: objproduct ?? Products(), strType: strType ?? "")
        }
    }
    
    
    
    //MARK: - UICollectionViewDelegate & UICollectionViewDataSource methods
    
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
        if self.delegate != nil{
            self.delegate?.openProductDetailView(objProduct: self.listProducts[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/3, height: 200)
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
