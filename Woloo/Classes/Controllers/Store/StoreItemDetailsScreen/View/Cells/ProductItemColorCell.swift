//
//  ProductItemColorCell.swift
//  Woloo
//
//  Created by CEPL on 05/03/25.
//

import UIKit

protocol ProductItemColorCellProtocol: NSObjectProtocol{
    
    func didSelectItem(objProductOptionValue: ProductOptionValue?)
}


class ProductItemColorCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var objOptions = ProductOptions()
    weak var delegate: ProductItemColorCellProtocol?
    var selectedOptions: [String: String] = [:]
    var strOption: String? = ""
    
    
    
//    var hexColor = ["#0E8B84", "#17181A", "#1F6F9C", "#7E19CE"]
//    var strSize = ["S", "M", "L", "XL"]
    
    var strIsType: String? = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(ProductColorCollectionCell.nib, forCellWithReuseIdentifier: ProductColorCollectionCell.identifier)
        self.collectionView.register(ProductOptionCell.nib, forCellWithReuseIdentifier: ProductOptionCell.identifier)
        collectionView.reloadData()
    }

    func configureOptions(objProductOptions: ProductOptions?){
        self.objOptions = objProductOptions ?? ProductOptions()
        self.lblTitle.text = self.objOptions.title ?? ""
    }
    
    func configureProductItemColorCell()
    {
        self.strIsType = "COLOR"
        self.lblTitle.text = "Colours"
        
      
    }
    
    func configureProductItemSizeCell(objProductOption: ProductOptions?)
    {
       self.objOptions = objProductOption ?? ProductOptions()
        self.strIsType = "SIZE"
        self.lblTitle.text = "Size"
        self.lblTitle.text = self.objOptions.title ?? ""
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

    extension ProductItemColorCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
       
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.objOptions.values?.count ?? 0
        }
        
       
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if self.objOptions.title ?? "" == "Color" || self.objOptions.title ?? "" == "color" || self.objOptions.title ?? "" == "colors" || self.objOptions.title ?? "" == "Colours" || self.objOptions.title ?? "" == "colours"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductColorCollectionCell.identifier, for: indexPath) as? ProductColorCollectionCell ?? ProductColorCollectionCell()
           
                cell.configureProductColorCollectionCell(objProductOptionValue: self.objOptions.values?[indexPath.item])
            
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductOptionCell.identifier, for: indexPath) as? ProductOptionCell ?? ProductOptionCell()
           
                cell.configureProductOptionCell(objProductOptionValue: self.objOptions.values?[indexPath.item])
                return cell
            }

            }
     
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("clicked on items: ", self.objOptions.values?[indexPath.item].value ?? "")
            
                if self.delegate != nil {
                    self.delegate?.didSelectItem(objProductOptionValue: self.objOptions.values?[indexPath.item])
                }
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            if self.objOptions.title == "Color"{
                return CGSize(width: 50, height: collectionView.frame.height)
            }else{
                return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
            }
            
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
