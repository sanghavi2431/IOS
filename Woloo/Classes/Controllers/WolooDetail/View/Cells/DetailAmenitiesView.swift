//
//  DetailAmenitiesView.swift
//  Woloo
//
//  Created by Kapil Dongre on 07/11/24.
//

import UIKit

class DetailAmenitiesView: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightOfCollectionView: NSLayoutConstraint!
    @IBOutlet weak var lblAmenities: UILabel!
    
    var tags = ["Clean & Hygienic Toilets","Wheelchair","Convenience Shop","Safe Space","sanitizer"]
    var reloadCollection: (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
    }

    func configureUI()  {
        self.lblAmenities.font = UIFont(name: "CenturyGothic-Bold", size: 18)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    
        collectionView.register(HighlightCell.nib, forCellWithReuseIdentifier: HighlightCell.identifier)
    }
    
    func setDataV2(tags: [String]){
        self.tags = tags
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        heightOfCollectionView.constant = height
        self.setNeedsLayout()
        reloadCollection?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DetailAmenitiesView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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

extension DetailAmenitiesView{
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

