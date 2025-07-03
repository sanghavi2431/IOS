//
//  BlogDetaiFourImgCell.swift
//  Woloo
//
//  Created by CEPL on 16/05/25.
//

import UIKit

class BlogDetaiFourImgCell: UITableViewCell {

    @IBOutlet weak var imgVw1: UIImageView!
    @IBOutlet weak var imgVw2: UIImageView!
    @IBOutlet weak var imgVw3: UIImageView!
    @IBOutlet weak var imgVw4: UIImageView!
    @IBOutlet weak var blogDescroptionLabel: UILabel!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.blogTitle.font = UIFont(name: "Centur_Gothic_Regular", size: 15)
        self.btnShop.titleLabel?.font =  UIFont(name: "Centur_Gothic_Regular", size: 12)
        self.blogTitle.text = "Woloo Powder Room"
        //blockBtn.addTarget(self, action: #selector(handleMoreTap), for: .touchUpInside)
        
//        self.imgVw1.layer.cornerRadius = 10
//        self.imgVw2.layer.cornerRadius = 10
//        self.imgVw3.layer.cornerRadius = 10
//        self.imgVw4.layer.cornerRadius = 10
    }
    
    @objc private func handleMoreTap() {
            onMoreButtonTapped?()
        }
    
    func configureBlogDetailFourImgCell(objBlogModel: BlogModel?, currentIndexPath: IndexPath){
        self.objBlogModel = objBlogModel ?? BlogModel()
        self.selectedIndexPath = currentIndexPath
        self.blogDescroptionLabel.text =  self.objBlogModel.title?.capitalized
        
        if self.objBlogModel.isFavourite ?? 0 == 1{
            self.likeButton.isSelected = true
        }
        else{
            self.likeButton.isSelected = false
        }
        
        if self.objBlogModel.mainImage?.count ?? 0 >= 4 {
            self.imgVw1.sd_setImage(with: URL(string: "\(baseUrl ?? "")\(self.objBlogModel.mainImage?[0] ?? "")"), completed: nil)
            
            self.imgVw2.sd_setImage(with: URL(string: "\(baseUrl ?? "")\(self.objBlogModel.mainImage?[1] ?? "")"), completed: nil)
            self.imgVw3.sd_setImage(with: URL(string: "\(baseUrl ?? "")\(self.objBlogModel.mainImage?[2] ?? "")"), completed: nil)
            self.imgVw4.sd_setImage(with: URL(string: "\(baseUrl ?? "")\(self.objBlogModel.mainImage?[3] ?? "")"), completed: nil)
            
            
        }
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
            self.delegate?.didClickedShareBtn(objBlogModel: self.objBlogModel, currentIndexPath: self.selectedIndexPath.row)
        }
    }
    
    @IBAction func clickedShopNowBtn(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didClickedShopNowBtn(objBlogModel: self.objBlogModel)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
