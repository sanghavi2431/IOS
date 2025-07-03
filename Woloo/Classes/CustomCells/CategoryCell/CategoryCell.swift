//
//  CategoryCell.swift
//  Woloo
//
//  Created on 28/07/21.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    static let identifier = "CategoryCell"
    
    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var selectedViewBoarder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(_ info: CategoryModel) {
        topicTitleLabel.text = info.categoryName
        topicImageView.sd_setImage(with: URL(string: info.categoryIconURL ?? ""), completed: nil)
//        bgImageView.layer.cornerRadius = bgImageView.frame.size.height/2
    }
    
    func setDataV2(_ info: CategoryModel) {
        topicTitleLabel.text = info.categoryName
        topicImageView.sd_setImage(with: URL(string: info.categoryIconURL ?? ""), completed: nil)
        bgImageView.layer.backgroundColor = UIColor(hexString: info.bgColor ?? "C7E3F9")?.cgColor
//        bgImageView.layer.cornerRadius = bgImageView.frame.size.height/2
    }
}
