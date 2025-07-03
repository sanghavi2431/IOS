//
//  BlogDetailSingleImgCell.swift
//  Woloo
//
//  Created by CEPL on 16/05/25.
//

import UIKit

class BlogDetailSingleImgCell: UITableViewCell {

    
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var blogDescroptionLabel: UILabel!
   // @IBOutlet weak var timesLabel: UILabel!
   // @IBOutlet weak var coinsbtn: UIButton!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var btnShop: UIButton!
    //@IBOutlet weak var blockBtn: UIButton!
    
    var objBlogModel = BlogModel()
    var baseUrl: String?
    weak var delegate: BlogDetailVideoCellDelegate?
    var onMoreButtonTapped: (() -> Void)?
    var selectedIndexPath = IndexPath()
    var currInddexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.blogTitle.font = UIFont(name: "Centur_Gothic_Regular", size: 15)
        self.btnShop.titleLabel?.font =  UIFont(name: "Centur_Gothic_Regular", size: 12)
        self.blogTitle.text = "Woloo Powder Room"
        //blockBtn.addTarget(self, action: #selector(handleMoreTap), for: .touchUpInside)
//        self.blogImageView.layer.cornerRadius = 10
    }
    
    
    func configureBlogDetailSingleImgCell(objBlogModel: BlogModel?, currentIndexPath: IndexPath){
        self.currInddexPath = currentIndexPath
        self.objBlogModel = objBlogModel ?? BlogModel()
        self.selectedIndexPath = currentIndexPath
        self.blogDescroptionLabel.text =  self.objBlogModel.title?.capitalized
        
        if self.objBlogModel.isFavourite ?? 0 == 1{
            self.likeButton.isSelected = true
        }
        else{
            self.likeButton.isSelected = false
        }
        
        
        if self.objBlogModel.mainImage?.count ?? 0 > 0 {
            self.blogImageView.sd_setImage(with: URL(string: "\(baseUrl ?? "")\(self.objBlogModel.mainImage?[0] ?? "")"), completed: nil)
            
            
        }
    }
    
    @objc private func handleMoreTap() {
            onMoreButtonTapped?()
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedLikeBtn(_ sender: UIButton) {
        
        if (self.delegate != nil){
            self.delegate?.didClickedLikeBtn(objBlogModel: self.objBlogModel)
        }
    }
    
    @IBAction func clickedCommentBtn(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didClickedCommentBtn(objBlogModel: self.objBlogModel)
        }
    }
    
    @IBAction func clickedShareBtn(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didClickedShareBtn(objBlogModel: self.objBlogModel, currentIndexPath: self.currInddexPath?.row)
        }
    }
    
    @IBAction func clickedShopNowBtn(_ sender: UIButton) {
        
        if (self.delegate != nil){
            self.delegate?.didClickedShopNowBtn(objBlogModel: self.objBlogModel)
        }
    }
}
