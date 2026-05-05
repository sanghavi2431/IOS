//
//  ShopCategoryCell.swift
//  Woloo
//
//  Created by Ashish Khobragade on 28/12/20.
//

import UIKit

class ShopCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    weak var delegate:SelectionProtocol?
    
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
        
        collectionView.register(ShopCategoryCell.nib, forCellWithReuseIdentifier: ShopCategoryCell.identifier)

    }
    
}

// MARK: - UICollectionView Delegate & DataSource
extension ShopCategoryTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ShopCategoryCell.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? ShopCategoryCell else { print("ShopCategoryCell not available"); return }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size:CGSize = .zero
        
        let width = (collectionView.bounds.width - 36)/2
        let height = width
        
        size.width = width
        size.height = CGFloat(height)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCategory()
    }
}
