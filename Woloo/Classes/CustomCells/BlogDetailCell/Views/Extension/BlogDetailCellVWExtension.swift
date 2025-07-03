//
//  BlogDetailCellVWExtension.swift
//  Woloo
//
//  Created by CEPL on 03/05/25.
//

import Foundation
import UIKit


extension BlogDetailCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    //MARK: - UICollectionViewDelegate & UICollectionViewDataSource methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Image count: ")
        return self.objBlogModel.mainImage?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductItemImageCollectionCell.identifier, for: indexPath) as? ProductItemImageCollectionCell ?? ProductItemImageCollectionCell()
        
        if self.objBlogModel.mainImage?.count ?? 0 > 0 {
            cell.configureBlogDetailMultipleImageCell(blogImg: self.objBlogModel.mainImage?[indexPath.item], baseUrl: self.baseUrl)
            
        }
        
       
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
