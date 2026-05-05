//
//  TakeASneakPeakTblCell.swift
//  Woloo
//
//  Created by CEPL on 10/07/25.
//

import UIKit

class TakeASneakPeakTblCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoriesVideosList: [TakeSneakPeekServiceItem] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(TakeASneakCollectionCell.nib, forCellWithReuseIdentifier: TakeASneakCollectionCell.identifier)
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureTakeASneakPeakTblCell(objVideo: [TakeSneakPeekServiceItem]){
        self.categoriesVideosList = objVideo
        self.collectionView.reloadData()
    }
    
}


extension TakeASneakPeakTblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoriesVideosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TakeASneakCollectionCell.identifier, for: indexPath) as? TakeASneakCollectionCell ?? TakeASneakCollectionCell()
            //fillCategoryCell(cell,indexPath.item)
        cell.configureTakeASneakCollectionCell(strVideoUrl: self.categoriesVideosList[indexPath.item].videoUrl)
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 3, height: 205)
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
