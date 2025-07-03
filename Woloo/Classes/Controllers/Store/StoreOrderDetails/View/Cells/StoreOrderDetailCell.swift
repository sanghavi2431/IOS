//
//  StoreOrderDetailCell.swift
//  Woloo
//
//  Created by CEPL on 08/03/25.
//

import UIKit

class StoreOrderDetailCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var vwBack: ShadowView!
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var objProduct = Products()
    var objStoreItems = OrderListings()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(OrderStatusCollectionCell.nib, forCellWithReuseIdentifier: OrderStatusCollectionCell.identifier)
  
        
        collectionView.reloadData()
    }
    
    func configureStoreOrderDetailCell(objProduct: Products?, objStoreItems: OrderListings?){
        self.objStoreItems = objStoreItems ?? OrderListings()
        self.imgView.layer.cornerRadius = 12.1
        self.objProduct = objProduct ?? Products()
        
        self.lblItemName.text = self.objProduct.title
        self.lblQty.text = "Qty: \(self.objProduct.quantity ?? 0)"
//        self.lblPrice.text = "Rs. \(self.objProduct.)"
        let price = ((self.objProduct.quantity ?? 0) * (self.objProduct.unit_price ?? 0))
        
        self.lblPrice.text = "Rs. \(price)"
        imgView.sd_setImage(with: URL(string: objProduct?.thumbnail ?? ""), completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let vwBackWidth = vwBack.frame.size.width
        let vwBackHeight = vwBack.frame.size.height
        if vwBackWidth < vwBackHeight {
            self.vwBack.viewCornerRadius = vwBackWidth / 5.7
        } else {
            self.vwBack.viewCornerRadius = vwBackHeight / 5.7
        }
    }


    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension StoreOrderDetailCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderStatusCollectionCell.identifier, for: indexPath) as? OrderStatusCollectionCell ?? OrderStatusCollectionCell()
        //cell.configureOrderStatusCollectionCell(indexPath: indexPath, objOrderListings: self.objStoreItems)
            //fillCategoryCell(cell,indexPath.item)
            return cell
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 4, height: 90)
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
