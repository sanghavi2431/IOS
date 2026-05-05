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
    private var currentVideoURL: String = ""
    private var isPlayerConfigured = false
    
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

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }

    
    @objc private func handleMoreTap() {
            onMoreButtonTapped?()
        }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // ❌ Don’t reset everything — only pause
        self.player?.pause()
        // Keep videoLayer alive for reuse
        // Don't set isPlayerConfigured = false here
    }
    
    func configureBlogDetailCell(objBlogModel: BlogModel?, parentVC: UIViewController, indexPath: IndexPath) {
        self.currInddexPath = indexPath
        self.objBlogModel = objBlogModel ?? BlogModel()
        self.blogDescroptionLabel.text = self.objBlogModel.title?.capitalized
        self.likeButton.isSelected = self.objBlogModel.isFavourite == 1

        let videoPath = self.objBlogModel.main_video?.first ?? ""
        let strVideoUrl = "\(self.baseUrl ?? "")\(videoPath)"

        print("video url is \(strVideoUrl)")
        // 👇 Prevent reconfig if same video
        if isPlayerConfigured && currentVideoURL == strVideoUrl {
            return
        }

        currentVideoURL = strVideoUrl
        isPlayerConfigured = true

        guard let url = URL(string: strVideoUrl) else { return }

        self.videoLoader.startAnimating()

        let playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.frame = self.videoContainerView.bounds
//        self.playerLayer?.videoGravity = .resizeAspectFill
        self.playerLayer?.videoGravity = .resize

        if self.playerLayer?.superlayer == nil {
            self.videoContainerView.layer.addSublayer(self.playerLayer!)
        }

        self.playerObserver?.invalidate()
        self.playerObserver = playerItem.observe(\.status, options: [.new]) { [weak self] item, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if item.status == .readyToPlay {
                    self.videoLoader.stopAnimating()
                    self.player?.play()
                } else if item.status == .failed {
                    self.videoLoader.stopAnimating()
                    print("Video failed: \(item.error?.localizedDescription ?? "unknown")")
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
        // Don’t remove layers or nil player here to allow reuse
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
