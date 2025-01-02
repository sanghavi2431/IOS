
//  BlogDetailCell.swift
//  Woloo
//
//  Created on 30/07/21.
//

import UIKit

class BlogDetailCell: UITableViewCell {

    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var blogDescroptionLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var coinsbtn: UIButton!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var handleActionForFavourite: ((_ row: Int) -> Void)?
    var handleActionForLike: ((_ row: Int) -> Void)?
    var handleActionForShare: ((_ row: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(_ info: BlogModel) {
        if info.isBlogRead == 0 {
            coinsbtn.backgroundColor = UIColor.yellow
        } else {
            coinsbtn.backgroundColor = UIColor.lightGray
        }
        blogDescroptionLabel.text =  info.title?.capitalized
        likeButton.isSelected = info.isLiked == 0
        favouriteButton.isSelected = info.isFavourite == 0
        if let blogImage = info.mainImage {
            let url = "https://woloo-stagging.s3.ap-south-1.amazonaws.com/\(blogImage ?? "")"
            self.blogImageView.sd_setImage(with: URL(string: url), completed: nil)
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
            timesLabel.text = removeFirstCharacter ?? ""
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
        likeButton.isSelected = !likeButton.isSelected
        let image = #imageLiteral(resourceName: "hurtBlackIcon").withTintColor(likeButton.isSelected ? UIColor(named: "Woloo_Yellow")! : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) , renderingMode: .alwaysOriginal)
        likeButton.setImage(image, for: .normal)
    }
    
    private func changeFavouriteUnFavouriteUIChange() {
        favouriteButton.isSelected = !favouriteButton.isSelected
        let image = #imageLiteral(resourceName: "FavouriteIcon").withTintColor(favouriteButton.isSelected ? UIColor(named: "Woloo_Yellow")! : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) , renderingMode: .alwaysOriginal)
        favouriteButton.setImage(image, for: .normal)
    }
    
}

// MARK: - @IBActions and @objc metods
extension BlogDetailCell {
    @IBAction func favouriteAction(_ sender: UIButton) {
        changeFavouriteUnFavouriteUIChange()
        handleActionForFavourite?(sender.tag)
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        changeLikeUnlikeUIChange()
        handleActionForLike?(sender.tag)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        handleActionForShare?(sender.tag)
    }
}
