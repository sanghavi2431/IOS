//
//  IntroCell.swift
//  Woloo
//
//  Created on 02/08/21.
//

import UIKit

class IntroCell: UICollectionViewCell {

    @IBOutlet weak var introImageView: UIImageView!
    @IBOutlet weak var introTitleLabel: UILabel!
    @IBOutlet weak var introDescLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //configure()
    }

    private func configure() {
        introImageView.layer.cornerRadius = introImageView.frame.height/2
        introImageView.clipsToBounds = true
    }
}
