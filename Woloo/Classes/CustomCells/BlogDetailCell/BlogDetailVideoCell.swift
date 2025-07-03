//
//  BlogDetailVideoCell.swift
//  Woloo
//
//  Created by CEPL on 03/05/25.
//

import UIKit
import AVKit


protocol BlogDetailVideoCellDelegate: NSObjectProtocol{
    
    func didClickedLikeBtn(objBlogModel: BlogModel?)
    func didClickedCommentBtn(objBlogModel: BlogModel?)
    func didClickedShareBtn(objBlogModel: BlogModel?, currentIndexPath: Int?)
    
    func didClickedShopNowBtn(objBlogModel: BlogModel?)
    
    func didBockBlogs(objBlogModel: BlogModel?, currentIndexPath: IndexPath?)
}

class BlogDetailVideoCell: UITableViewCell {

    @IBOutlet weak var videoContainerView: UIView!
    
    @IBOutlet weak var blogDescroptionLabel: UILabel!
   // @IBOutlet weak var timesLabel: UILabel!
   // @IBOutlet weak var coinsbtn: UIButton!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var btnShop: UIButton!
    //@IBOutlet weak var blockBtn: UIButton!
    @IBOutlet weak var videoLoader: UIActivityIndicatorView!
    @IBOutlet weak var lblShopNow: UILabel!
    
   
    var objBlogModel = BlogModel()
    var baseUrl: String?
    weak var delegate: BlogDetailVideoCellDelegate?
    var onMoreButtonTapped: (() -> Void)?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerObserver: NSKeyValueObservation?
    var currInddexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.blogTitle.font = UIFont(name: "GOTHICB_ITALIC_BOLD", size: 15)
       // self.lblShopNow.font = UIFont(name: "GOTHIC_BOLD.ttf", size: 12)
        self.blogDescroptionLabel.font = UIFont(name: "Centur_Gothic_Regular", size: 13)
        self.btnShop.titleLabel?.font =  UIFont(name: "Centur_Gothic_Regular", size: 12)
        self.blogTitle.text = "Woloo Powder Room"
        videoLoader.hidesWhenStopped = true
        //blockBtn.addTarget(self, action: #selector(handleMoreTap), for: .touchUpInside)
    }

    @objc private func handleMoreTap() {
            onMoreButtonTapped?()
        }
 
    
    func configureBlogDetailCell(objBlogModel: BlogModel?, parentVC: UIViewController, indexPath: IndexPath) {
        
        self.currInddexPath = indexPath
        self.objBlogModel = objBlogModel ?? BlogModel()
        self.blogDescroptionLabel.text = self.objBlogModel.title?.capitalized
        
        if self.objBlogModel.isFavourite ?? 0 == 1{
            self.likeButton.isSelected = true
        }
        else{
            self.likeButton.isSelected = false
        }
        
//        self.videoContainerView.layer.cornerRadius = 25.0
//        self.videoContainerView.clipsToBounds = true

        let videoPath = self.objBlogModel.main_video?.first ?? ""
        let strVideoUrl = "\(self.baseUrl ?? "")\(videoPath)"

        DispatchQueue.main.async {
            guard let url = URL(string: strVideoUrl) else { return }

            self.videoLoader.startAnimating()

            // Clean up existing layers and observers
            self.videoContainerView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            self.playerObserver?.invalidate()

            // Setup new player
            self.player = AVPlayer(url: url)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.frame = self.videoContainerView.bounds
            self.playerLayer?.videoGravity = .resizeAspectFill

            if let playerLayer = self.playerLayer {
                self.videoContainerView.layer.addSublayer(playerLayer)
            }

            // Observe when video is ready
            self.playerObserver = self.player?.currentItem?.observe(\.status, options: [.new, .initial]) { [weak self] item, _ in
                guard let self = self else { return }

                if item.status == .readyToPlay {
                    DispatchQueue.main.async {
                        self.videoLoader.stopAnimating()
                        self.player?.play()
                    }
                } else if item.status == .failed {
                    DispatchQueue.main.async {
                        self.videoLoader.stopAnimating()
                        print("Video failed to load: \(item.error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }

    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func pauseVideo() {
        player?.pause()
        playerObserver?.invalidate()
        player = nil
        playerLayer?.removeFromSuperlayer()
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
