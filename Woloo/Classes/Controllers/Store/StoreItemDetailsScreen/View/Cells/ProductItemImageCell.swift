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
    var filteredImages: [StoreProductImages] = []
    
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
    
        func configureProductItemImageCell(objProduct: Products?) {
            self.objProduct = objProduct ?? Products()

            let isWishlisted = self.objProduct.isLiked ?? (self.objProduct.variants?.contains(where: { $0.has_wishlisted == true }) ?? false)
            self.btnLike.isSelected = isWishlisted
            self.objProduct.isLiked = isWishlisted

            print("💡 Like button isSelected: \(self.btnLike.isSelected), has_wishlisted: \(self.objProduct.variants?.first?.has_wishlisted ?? false)")

            var selectedColor: String? = nil
            for opt in self.objProduct.options ?? [] {
                if opt.title?.lowercased() == "color" || opt.title?.lowercased() == "colors" {
                    selectedColor = opt.values?.first(where: { $0.isSelected == true })?.value
                    break
                }
            }

            if let colorName = selectedColor?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !colorName.isEmpty {
                let matches = objProduct?.images?.filter {
                    guard let url = $0.url?.lowercased() else { return false }
                    return url.contains(colorName.replacingOccurrences(of: " ", with: ""))
                } ?? []

                if !matches.isEmpty {
                    self.filteredImages = matches
                    print("🎯 Matched images for color '\(colorName)': \(matches.map { $0.url ?? "" })")
                } else {
                    print("⚠️ No match found for color '\(colorName)'. Using default image.")
                    self.filteredImages = objProduct?.images?.prefix(1).map { $0 } ?? []
                }
            } else {
                self.filteredImages = objProduct?.images ?? []
            }

            print("📊 Reloading collectionView with \(self.filteredImages.count) images")
            for (i, img) in self.filteredImages.enumerated() {
                print("🖼️ Filtered Image [\(i)]: \(img.url ?? "nil")")
            }

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

    
    
    @IBAction func clickedBtnLike(_ sender: UIButton) {
        
        self.btnLike.isSelected.toggle()
           self.objProduct.isLiked = self.btnLike.isSelected

        print("💡 Like button isSelected: \(self.btnLike.isSelected), has_wishlisted: \(self.objProduct.variants?.first?.has_wishlisted ?? false)")

           // ✅ Update first variant's wishlisted flag — assuming single variant display
           self.objProduct.variants?.first?.has_wishlisted = self.btnLike.isSelected

           if self.btnLike.isSelected {
               self.delegate?.didWishlishedItem(objProduct: self.objProduct, strType: "Add")
           } else {
               self.delegate?.didWishlishedItem(objProduct: self.objProduct, strType: "Remove")
           }
        
    }
    
    
}


extension ProductItemImageCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("📦 Returning \(self.filteredImages.count) items")
        return self.filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < self.filteredImages.count else {
            print("⚠️ Invalid index: \(indexPath.item), filteredImages.count: \(filteredImages.count)")
            return UICollectionViewCell() // Return empty cell as fallback
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductItemImageCollectionCell.identifier, for: indexPath) as? ProductItemImageCollectionCell ?? ProductItemImageCollectionCell()

        cell.configureProductItenImageCollectionCell(objStoreProductImages: self.filteredImages[indexPath.item])

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
