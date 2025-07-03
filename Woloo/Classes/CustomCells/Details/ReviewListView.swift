//
//  ReviewListView.swift
//  Woloo
//
//  Created by ideveloper2 on 11/06/21.
//

import UIKit

protocol ReviewListDelegate: class {
    /// Open specific review page detail.
    func openReviewDetail(_ review: Review)
}

class ReviewListView: UICollectionReusableView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var allReviewButton: UIButton!
   // @IBOutlet weak var reviewRatingLabel: UILabel!
    
    @IBOutlet weak var addReviewBtn: UIButton!
    
    
    var openReviewActionHandler: (() -> Void)?
    weak var delegate: ReviewListDelegate?
    
    var addReviewBtnAction: (() -> Void)?
    
//    var reviewList: [Review]? {
//        didSet {
//            self.collectionView.reloadData()
//        }
//    }
    var reviewList: [ReviewListModel.Review]? {
        didSet {
            self.collectionView.reloadData()
        }
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
        
    }
    
    @IBAction func allReviewAction(_ sender: Any) {
        openReviewActionHandler?()
    }
    
    @IBAction func addReviewBtnPressed(_ sender: UIButton) {
        print("open Review Page")
        addReviewBtnAction?()
    }
}

extension ReviewListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupView() {
        allReviewButton.layer.borderColor = #colorLiteral(red: 1, green: 0.9333333333, blue: 0, alpha: 1)
        allReviewButton.layer.borderWidth = 2
        allReviewButton.cornerRadius = 20
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ReviewDetailCell", bundle: nil), forCellWithReuseIdentifier: "ReviewDetailCell")
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewDetailCell", for: indexPath) as! ReviewDetailCell
        fillCell(cell,indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width - 32, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// MARK: - Cell Handling
extension ReviewListView {
    private func fillCell(_ cell: ReviewDetailCell, _ indexPath: IndexPath) {
        guard let detail = self.reviewList?[indexPath.item] else { return }
        cell.reviewDetail = detail
        cell.readMoreButton.tag = indexPath.item
        cell.moreButtonHandler = { [weak self] (index) in
            guard let self = self else { return }
            if let reviewDetail = self.reviewList?[index ?? 0]  {
                //self.delegate?.openReviewDetail(reviewDetail)
            }
        }
    }
}

