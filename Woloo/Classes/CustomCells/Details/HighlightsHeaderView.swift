//
//  HighlightsHeaderView.swift
//  Woloo
//
//  Created by Ashish Khobragade on 06/01/21.
//

import UIKit

class HighlightsHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightOfCollectionView: NSLayoutConstraint!
    
    var tags = ["Clean & Hygienic Toilets","Wheelchair","Convenience Shop","Safe Space","sanitizer"]
    var reloadCollection: (()-> Void)?
    
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
    
    class func instanceFromNib() -> UIView {
        return nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func configureUI()  {
        
        collectionView.register(HighlightCell.nib, forCellWithReuseIdentifier: HighlightCell.identifier)
    }
    
    func setData(tags: [String]) {
        self.tags = tags
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        heightOfCollectionView.constant = height
        self.setNeedsLayout()
        reloadCollection?()
    }
    
    func setDataV2(tags: [String]){
        self.tags = tags
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        heightOfCollectionView.constant = height
        self.setNeedsLayout()
        reloadCollection?()
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension HighlightsHeaderView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: HighlightCell.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? HighlightCell else { print("HighlightCell not available"); return }
        let item = tags[indexPath.item]
        cell.set(tag: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: widthForView(text: tags[indexPath.item]) + 60, height: 32.0)
    }
}

extension HighlightsHeaderView{
    func widthForView(text:String) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width:  CGFloat.greatestFiniteMagnitude, height: 44.0))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = ThemeManager.Font.OpenSans_Semibold(size: 11.7)
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
}
