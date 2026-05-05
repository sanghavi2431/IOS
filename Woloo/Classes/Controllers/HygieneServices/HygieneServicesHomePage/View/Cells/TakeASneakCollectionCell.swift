//
//  TakeASneakCollectionCell.swift
//  Woloo
//
//  Created by CEPL on 10/07/25.
//

import UIKit
import AVFoundation

class TakeASneakCollectionCell: UICollectionViewCell {

    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var videoLoader: UIActivityIndicatorView!
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerObserver: NSKeyValueObservation?
    private var currentVideoURL: String = ""
    private var isPlayerConfigured = false
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        videoLoader.hidesWhenStopped = true
        self.videoContainerView.layer.cornerRadius = 20.0
        self.videoContainerView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        // ❌ Don’t reset everything — only pause
        self.player?.pause()
        // Keep videoLayer alive for reuse
        // Don't set isPlayerConfigured = false here
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.videoContainerView.bounds
    }
    
    func configureTakeASneakCollectionCell(strVideoUrl: String?){
        self.currentVideoURL = strVideoUrl ?? ""
        
        
        isPlayerConfigured = true
        guard let url = URL(string: self.currentVideoURL ?? "") else { return }
        self.videoLoader.startAnimating()
        
        let playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.frame = self.videoContainerView.bounds
        self.playerLayer?.videoGravity = .resizeAspectFill

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
    
    func pauseVideo() {
        player?.pause()
        // Don’t remove layers or nil player here to allow reuse
    }
}
