//
//  StoreBrandCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 30/01/25.
//

import UIKit

protocol StoreBrandCellDelegate: NSObjectProtocol{
    
    func didClickedSeeMoreBrand()
    
    func didClickedBrand(objBrand: ProductCollection)
}

class StoreBrandCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var lisProductCollection = [ProductCollection]()
    weak var delegate: StoreBrandCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(StoreBrandCollectionViewCell.nib, forCellWithReuseIdentifier: StoreBrandCollectionViewCell.identifier)
        collectionView.reloadData()
    }
    
    func configureStoreBrandCell(listBrand: [ProductCollection]?){
        self.lisProductCollection = listBrand ?? [ProductCollection]()
        
        self.collectionView.reloadData()
    }
    
    @IBAction func clickedSeeMore(_ sender: UIButton) {
        
        if (self.delegate != nil){
            self.delegate?.didClickedSeeMoreBrand()
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension StoreBrandCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lisProductCollection.count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreBrandCollectionViewCell.identifier, for: indexPath) as? StoreBrandCollectionViewCell ?? StoreBrandCollectionViewCell()
        cell.configureStoreBrandCollectionViewCell(objBrand: self.lisProductCollection[indexPath.item])
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate?.didClickedBrand(objBrand: self.lisProductCollection[indexPath.item])
        }
       
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/3, height: 126)
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
