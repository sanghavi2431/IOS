//
//  OrderStatusTableCell.swift
//  Woloo
//
//  Created by CEPL on 10/04/25.
//

import UIKit

class OrderStatusTableCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var objStoreItems = OrderSets()
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(OrderStatusCollectionCell.nib, forCellWithReuseIdentifier: OrderStatusCollectionCell.identifier)
  
        
        collectionView.reloadData()
    }

   
    func configureOrderStatusTableCell(objStoreItems: OrderSets?){
        
        self.objStoreItems = objStoreItems ?? OrderSets()
        
        self.collectionView.reloadData()
        
    }
    
}


extension OrderStatusTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: UICollectionViewDelegate, UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderStatusCollectionCell.identifier, for: indexPath) as? OrderStatusCollectionCell ?? OrderStatusCollectionCell()
    cell.configureOrderStatusCollectionCell(indexPath: indexPath, objOrderListings: self.objStoreItems)
        //fillCategoryCell(cell,indexPath.item)
        return cell
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
