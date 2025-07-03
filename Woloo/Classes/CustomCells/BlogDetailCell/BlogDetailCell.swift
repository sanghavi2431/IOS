
//  BlogDetailCell.swift
//  Woloo
//
//  Created on 30/07/21.
//

import UIKit


class BlogDetailCell: UITableViewCell {

    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var blogDescroptionLabel: UILabel!
   // @IBOutlet weak var timesLabel: UILabel!
   // @IBOutlet weak var coinsbtn: UIButton!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var btnShop: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var blockBtn: UIButton!
    
    var onMoreButtonTapped: (() -> Void)?
    
    var handleActionForFavourite: ((_ row: Int) -> Void)?
    var handleActionForLike: ((_ row: Int) -> Void)?
    var handleActionForShare: ((_ row: Int) -> Void)?
    var handleForShop: ((_ row: Int) -> Void)?
    var objBlogModel = BlogModel()
    var baseUrl: String?
    weak var delegate: BlogDetailVideoCellDelegate?
    var selectedIndexPath = IndexPath()
    
    var menuView: TweetContextMenu?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.blogTitle.font = UIFont(name: "Centur_Gothic_Regular", size: 15)
        self.blogTitle.text = "Woloo Powder Room"
        self.btnShop.titleLabel?.font =  UIFont(name: "Centur_Gothic_Regular", size: 12)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(ProductItemImageCollectionCell.nib, forCellWithReuseIdentifier: ProductItemImageCollectionCell.identifier)
        self.blockBtn.isHidden = true
        blockBtn.addTarget(self, action: #selector(handleMoreTap), for: .touchUpInside)
        collectionView.reloadData()
    }
    
    func configureBlogDetailCell(objBlogModel: BlogModel?, currentIndexPath: IndexPath){
        self.selectedIndexPath = currentIndexPath
        self.objBlogModel = objBlogModel ?? BlogModel()
        self.selectedIndexPath = currentIndexPath
        self.blogDescroptionLabel.text =  self.objBlogModel.title?.capitalized
        
        
        self.collectionView.reloadData()
    }
    


    @objc private func handleMoreTap() {
            onMoreButtonTapped?()
        }
 
    func setData(_ info: BlogModel) {
        //self.objBlogModel = info
        if info.isBlogRead == 0 {
            //coinsbtn.backgroundColor = UIColor.yellow
        } else {
            //coinsbtn.backgroundColor = UIColor.lightGray
        }
        blogDescroptionLabel.text =  info.title?.capitalized
       // likeButton.isSelected = info.isLiked == 0
        favouriteButton.isSelected = info.isFavourite == 0
        
        if info.mainImage?.count ?? 0 > 0{
            if let blogImage = info.mainImage?[0] {
                let url = "https://woloo-stagging.s3.ap-south-1.amazonaws.com/\(blogImage)"
                self.blogImageView.sd_setImage(with: URL(string: url), completed: nil)
            }
        }
       
        
        let startDate = Date()
        let endDateString = info.updatedAt ?? ""

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let endDate = formatter.date(from: endDateString) {
            let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
            print("Number of days: \(components.day!)")
            var removeFirstCharacter = "\(String(components.day!)) Days Ago"
            removeFirstCharacter.removeFirst()
          //  timesLabel.text = removeFirstCharacter ?? ""
        } else {
            print("\(endDateString) can't be converted to a Date")
        }
        
//        // Current Date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = Date()
//        let dateString = dateFormatter.string(from: date)
//        print(dateString)
//
//        // API Date
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let start = dateFormatter.date(from: dateString)!
//        let end = dateFormatter.date(from: info.updatedAt ?? "")!
//        let diff = Date.daysBetween(start: start, end: end)
//        print(diff)
//        let timeLabel = "\(String(diff)) Days Ago"
//        if (timeLabel ?? "").isEmpty {
//            print("String is nil or empty")
//            timesLabel.isHidden = true
//        } else {
//            timesLabel.text = timeLabel
//        }
    }
    
    private func changeLikeUnlikeUIChange() {
       // likeButton.isSelected = !likeButton.isSelected
        //let image = #imageLiteral(resourceName: "hurtBlackIcon").withTintColor(likeButton.isSelected ? UIColor(named: "Woloo_Yellow")! : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) , renderingMode: .alwaysOriginal)
           // likeButton.setImage(image, for: .normal)
    }
    
    private func changeFavouriteUnFavouriteUIChange() {
        favouriteButton.isSelected = !favouriteButton.isSelected
        let image = #imageLiteral(resourceName: "FavouriteIcon").withTintColor(favouriteButton.isSelected ? UIColor(named: "Woloo_Yellow")! : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) , renderingMode: .alwaysOriginal)
        favouriteButton.setImage(image, for: .normal)
    }
    
}

// MARK: - @IBActions and @objc metods
extension BlogDetailCell {
    
    @IBAction func BlockAction(_ sender: UIButton) {
        print("Open block option")
        
//        if self.delegate != nil{
//            self.delegate?.didBockBlogs(objBlogModel: self.objBlogModel, currentIndexPath: self.selectedIndexPath)
//        }
        
    }
    
    
    @IBAction func commentAction(_ sender: UIButton) {
        changeFavouriteUnFavouriteUIChange()
        handleActionForFavourite?(sender.tag)
        if (self.delegate != nil){
            self.delegate?.didClickedCommentBtn(objBlogModel: self.objBlogModel)
        }
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        changeLikeUnlikeUIChange()
        handleActionForLike?(sender.tag)
        if (self.delegate != nil){
            self.delegate?.didClickedLikeBtn(objBlogModel: self.objBlogModel)
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        handleActionForShare?(sender.tag)
        if (self.delegate != nil){
            self.delegate?.didClickedShareBtn(objBlogModel: self.objBlogModel, currentIndexPath: self.selectedIndexPath.row)
        }
    }
    
    @IBAction func shopAction(_ sender: UIButton) {
        handleForShop?(sender.tag)
        if (self.delegate != nil){
            self.delegate?.didClickedShopNowBtn(objBlogModel: self.objBlogModel)
        }
    }
    

}
