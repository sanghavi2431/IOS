//
//  ShopFilterTableCell.swift
//  Woloo
//
//  Created by CEPL on 17/04/25.
//

import UIKit

class ShopFilterTableCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightOfCollectionView: NSLayoutConstraint!
    
    var listProductCategories = [StoreProductCategories]()
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblTitle.font = UIFont(name: "CenturyGothic-Bold", size: 18)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(FilterCatCollectionViewCell.nib, forCellWithReuseIdentifier: FilterCatCollectionViewCell.identifier)
        self.collectionView.reloadData()
    }

    func configureShopFilterTableCell(listProductCategories: [StoreProductCategories]?){
        self.listProductCategories = listProductCategories ?? [StoreProductCategories]()
        //self.tags = self.tags
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        heightOfCollectionView.constant = height
        self.setNeedsLayout()
        self.collectionView.reloadData()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ShopFilterTableCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("listProductCategories Count", self.listProductCategories.count)
        return self.listProductCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return collectionView.dequeueReusableCell(withReuseIdentifier: FilterCatCollectionViewCell.identifier, for: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FilterCatCollectionViewCell else { print("FilterCatCollectionViewCell not available"); return }
       
        cell.configureFilterCatViews(objCategories: self.listProductCategories[indexPath.item])
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: widthForView(text: self.listProductCategories[indexPath.item].name ?? "") + 60, height: 32.0)
    }
    
}

extension ShopFilterTableCell{
    func widthForView(text:String) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width:  CGFloat.greatestFiniteMagnitude, height: 44.0))
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = ThemeManager.Font.OpenSans_Semibold(size: 11.7)
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
}

