//
//  BannerImageCollectionViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 02/08/21.
//

import UIKit

class BannerImageCollectionViewCell: UICollectionViewCell {
    
    var mainImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var homeBanner: HomeBanner? {
        didSet {
            mainImageView.sd_setImage(with: URL(string: ShoppingApisEndPoint.IMAGE_URL(homeBanner?.image ?? "").getDescription), completed: nil)
        }
    }
    
    var bannerImage: String? {
        didSet {
            mainImageView.sd_setImage(with: URL(string: ShoppingApisEndPoint.IMAGE_URL(bannerImage ?? "").getDescription), completed: nil)
        }
    }
    
    
    override func layoutSubviews() {
        setViews()
    }
    
    private
    func setViews() {
        contentView.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
