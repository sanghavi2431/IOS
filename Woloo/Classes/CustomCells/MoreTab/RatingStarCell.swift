//
//  RatingStarCell.swift
//  Woloo
//
//  Created on 18/06/21.
//

import UIKit
import Cosmos

protocol RatingCellDelegate: class {
    func updateRating(rating: Int)
}
class RatingStarCell: UITableViewCell {

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var ratingStartCount: Int? {
        didSet {
            ratingView.settings.filledImage = RatingImage.init(rawValue: Int(ratingStartCount ?? 0))?.fillImage
            titleLabel.text = RatingImage.init(rawValue: Int(ratingStartCount ?? 0))?.titleRating
            ratingView.rating = Double(ratingStartCount ?? 0)
        }
    }
    
    weak var delegate: RatingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell() {
        
        ratingView.didFinishTouchingCosmos = { [weak self] (value) in //setImage Here
            guard let self = self else { return }
            self.delegate?.updateRating(rating: Int(value))
            self.titleLabel.text = RatingImage.init(rawValue: Int(value))?.titleRating
            self.ratingView.settings.filledImage = RatingImage.init(rawValue: Int(value))?.fillImage
        }
        
        ratingView.didTouchCosmos = { [weak self] (value) in //setImage Here
            guard let self = self else { return }
            self.delegate?.updateRating(rating: Int(value))
            self.titleLabel.text = RatingImage.init(rawValue: Int(value))?.titleRating
            self.ratingView.settings.filledImage = RatingImage.init(rawValue: Int(value))?.fillImage
        }
        
    }
}


// MARK: - RatingImage
enum RatingImage: Int {
    case rate1 = 1
    case rate2 = 2
    case rate3 = 3
    case rate4 = 4
    case rate5 = 5

    var fillImage: UIImage? {
        switch self {
        case .rate1:
            return #imageLiteral(resourceName: "rating1")
        case .rate2:
            return #imageLiteral(resourceName: "rating3")
        case .rate3:
            return #imageLiteral(resourceName: "rating2")
        case .rate4:
            return #imageLiteral(resourceName: "rating4")
        case .rate5:
            return #imageLiteral(resourceName: "rating5")
        }
    }
    
    var titleRating: String? {
        switch self {
        case .rate1:
            return "VERY BAD"
        case .rate2:
            return "BAD"
        case .rate3:
            return "AVERAGE"
        case .rate4:
            return "GOOD"
        case .rate5:
            return "LOVED IT"
        }
    }
}
