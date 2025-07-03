//
//  StoreShowAllBrandVC.swift
//  Woloo
//
//  Created by CEPL on 15/04/25.
//

import UIKit

class StoreShowAllBrandVC: UIViewController {

    @IBOutlet weak var vwBackTxtField: UIView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var vwCartCountBack: UIView!
    @IBOutlet weak var lblCartCount: UILabel!
    @IBOutlet weak var vwBackFilter: ShadowView!
    
    var listBrands = [ProductCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }

    func loadInitialSettings(){
           
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
        self.btnCart.layer.cornerRadius = self.btnCart.frame.size.width / 2
        
        self.vwBackFilter.layer.cornerRadius = self.vwBackFilter.frame.size.width / 2
        
        self.vwCartCountBack.layer.cornerRadius = 8.5
        self.vwCartCountBack.clipsToBounds = true
        
        self.collectionview.register(StoreBrandCollectionViewCell.nib, forCellWithReuseIdentifier: StoreBrandCollectionViewCell.identifier)
        self.collectionview.register(StoreBlankHeaderCollectionCell.nib, forCellWithReuseIdentifier: StoreBlankHeaderCollectionCell.identifier)
        self.collectionview.register(AllProductsCollectionCell.nib, forCellWithReuseIdentifier: AllProductsCollectionCell.identifier)
        
        //AllProductsCollectionCell
        
        self.collectionview.reloadData()
        
        }
}
