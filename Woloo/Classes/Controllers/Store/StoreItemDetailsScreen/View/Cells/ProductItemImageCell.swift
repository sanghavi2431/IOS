//
//  ProductItemImageCell.swift
//  Woloo
//
//  Created by CEPL on 05/03/25.
//

import UIKit


protocol ProductItemImageCellDelegate: NSObjectProtocol{
    
    func didWishlishedItem(objProduct: Products?, strType: String?)
}

class ProductItemImageCell: UITableViewCell {

    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var objProduct = Products()
    weak var delegate: ProductItemImageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(ProductItemImageCollectionCell.nib, forCellWithReuseIdentifier: ProductItemImageCollectionCell.identifier)
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureProductItemImageCell(objProduct: Products?){
        
        self.objProduct = objProduct ?? Products()
        
        if self.objProduct.isLiked == true{
            self.btnLike.isSelected = true
        }
        else{
            self.btnLike.isSelected = false
        }
        
        self.collectionView.reloadData()
    }
    
    
    @IBAction func clickedBtnLike(_ sender: UIButton) {
        
        self.btnLike.isSelected.toggle()
        
        if self.btnLike.isSelected == true{
            self.objProduct.isLiked = true
            
            if self.delegate != nil{
                self.delegate?.didWishlishedItem(objProduct: self.objProduct, strType: "Add")
            }
        }
        else{
            self.objProduct.isLiked = false
            if self.delegate != nil{
                self.delegate?.didWishlishedItem(objProduct: self.objProduct, strType: "Remove")
            }
        }
        
    }
    
    
}


extension ProductItemImageCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objProduct.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductItemImageCollectionCell.identifier, for: indexPath) as? ProductItemImageCollectionCell ?? ProductItemImageCollectionCell()
        
        cell.configureProductItenImageCollectionCell(objStoreProductImages: self.objProduct.images?[indexPath.item])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
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
