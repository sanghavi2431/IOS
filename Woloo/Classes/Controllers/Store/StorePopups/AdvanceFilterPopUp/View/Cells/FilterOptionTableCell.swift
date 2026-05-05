//
//  FilterOptionTableCell.swift
//  Woloo
//
//  Created by CEPL on 30/06/25.
//

import UIKit

class FilterOptionTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var onSelectionChanged: (([SizeOption]) -> Void)?
    var strOption = [SizeOption]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(ProductOptionCell.nib, forCellWithReuseIdentifier: ProductOptionCell.identifier)
        collectionView.reloadData()
    }

    
    func configureFilterOptionTableCell(strOption: [SizeOption], onChange: @escaping ([SizeOption]) -> Void) {
            self.strOption = strOption
            self.onSelectionChanged = onChange
            self.collectionView.reloadData()
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension FilterOptionTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.strOption.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductOptionCell.identifier, for: indexPath) as? ProductOptionCell ?? ProductOptionCell()
   
        cell.configureProductOptionsFilterCell(strOption: self.strOption[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<strOption.count {
            strOption[i].isSelected = (i == indexPath.item)
        }
        collectionView.reloadData()
        
        // Propagate change to the view controller
        onSelectionChanged?(strOption)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
        
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
