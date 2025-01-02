//
//  NewsTableViewCell.swift
//  Woloo
//
//  Created by Ashish Khobragade on 28/12/20.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
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
        collectionView.register(NewsCell.nib, forCellWithReuseIdentifier: NewsCell.identifier)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension NewsTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? NewsCell else { print("NearestStoreCell not available"); return }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size:CGSize = .zero
        
        let width = (UIScreen.main.bounds.width - 32) * 0.71
        let height = (UIScreen.main.bounds.width - 32) * 0.68
        
        size.width = CGFloat(width)
        size.height = CGFloat(height)
        
        return size
    }
}
