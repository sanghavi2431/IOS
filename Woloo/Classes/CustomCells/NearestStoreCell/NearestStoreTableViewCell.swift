//
//  NearestStoreCell.swift
//  Woloo
//
//  Created by Ashish Khobragade on 24/12/20.
//

import UIKit

protocol SelectionProtocol:class {
    
    func didSelectStore(_ wolooStore:WolooStore)
    func didSelectCategory()
}

extension SelectionProtocol {
    
    func didSelectCategory(){}
}

class NearestStoreTableViewCell: UITableViewCell {
  
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate:SelectionProtocol?
    
    var nearByStoreResponseDO:NearByStoreResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI()  {
        
        collectionView.register(NearestStoreCell.nib, forCellWithReuseIdentifier: NearestStoreCell.identifier)
    }
    
}

// MARK: - UICollectionView Delegate & DataSource
extension NearestStoreTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearByStoreResponseDO?.stores?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: NearestStoreCell.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? NearestStoreCell else { print("NearestStoreCell not available"); return }
        guard let stores = nearByStoreResponseDO?.stores else { return }
        cell.wolooStore = stores[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size:CGSize = .zero
        
        let width = (UIScreen.main.bounds.width - 32) * 0.68
        
        let multiplier_height:CGFloat =  (UIScreen.main.bounds.width > 375.0) ? 0.71 : 0.78
        let height = (UIScreen.main.bounds.width - 32) * multiplier_height
        
        size.width = width
        size.height = CGFloat(height)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let stores = nearByStoreResponseDO?.stores else { return }
        let wolooStore = stores[indexPath.item]
        delegate?.didSelectStore(wolooStore)
    }
}
