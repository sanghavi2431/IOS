//
//  DetailReviewCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 07/11/24.
//

import UIKit

class DetailReviewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnAddReview: UIButton!
    
    @IBOutlet weak var lblReview: UILabel!
    
    
    var reviewList: [ReviewListModel.Review]? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    var addReviewBtnAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblReview.font = UIFont(name: "CenturyGothic-Bold", size: 18)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(DetailReviewDescCollectionCellCollectionViewCell.nib, forCellWithReuseIdentifier: DetailReviewDescCollectionCellCollectionViewCell.identifier)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func clickedBtnAddReview(_ sender: UIButton) {
        addReviewBtnAction?()
    }
    
}

extension DetailReviewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reviewList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailReviewDescCollectionCellCollectionViewCell.identifier, for: indexPath) as? DetailReviewDescCollectionCellCollectionViewCell ?? DetailReviewDescCollectionCellCollectionViewCell()
       
        cell.configureDetailReviewDescCollectionViewCell(objReviewDetail: self.reviewList?[indexPath.item] ?? ReviewListModel.Review())
      //  cell.configureDetailReviewDescCollectionCellCollectionViewCell(objReviewDetail: self.reviewList?[indexPath.item] ?? ReviewListModel.Review())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width / 2, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
