//
//  TrendingListCell.swift
//  Woloo
//
//  Created on 30/07/21.
//

import UIKit

class TrendingListCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleForSectionLabel: UILabel!
    
    var clickHandler: ((_ index: Int) -> Void)?
    var listOfCategory: [CategoryInfo]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var listOfCategoryV2: [DataAllBlog]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedCategories = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
}

extension TrendingListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: CategoryCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (listOfCategoryV2?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell ?? CategoryCell()
        fillCategoryCell(cell,indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/3, height: self.collectionView.frame.height)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickHandler?(indexPath.item)
        collectionView.reloadData()
    }
}


// MARK: - Cell's Handling
extension TrendingListCell {
    /// cell Related all operation do in this method
    /// - Parameters:
    ///   - cell: **CategoryCell**
    ///   - item: Index**IndexPath.item**
    private func fillCategoryCell(_ cell: CategoryCell,_ item: Int) {
        cell.topicTitleLabel.textColor = selectedCategories == item ? UIColor.backgroundColor : .gray
        if item == 0 {
            cell.topicImageView.image =  selectedCategories == item ?  #imageLiteral(resourceName: "checkMarkSquare") : #imageLiteral(resourceName: "checkMarkSquare").withTintColor(.gray)
            cell.topicTitleLabel.text = "All"
            cell.bgImageView.isHidden = true
            cell.selectedViewBoarder.isHidden = !(selectedCategories == item)
            return
        }
        if let info = listOfCategoryV2?[item - 1] {
            cell.setDataV2(info)
        }
        cell.bgImageView.isHidden = !(selectedCategories == item)
        cell.selectedViewBoarder.isHidden = !(selectedCategories == item)
    }
}
