//
//  HighlightCell.swift
//  Woloo
//
//  Created by Ashish Khobragade on 06/01/21.
//

import UIKit

class HighlightCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.textColor.cgColor
        self.layer.cornerRadius = 6.7
        self.layer.masksToBounds = true
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
        //#imageLiteral(resourceName: "white_convience_shop")
    func set(tag: String) {
        tagLabel.text = tag
        if tag == "Clean & Hygienic Toilets" {
            tagImage.image = UIImage(named: "ic_clean")
        } else if tag == "Wheelchair" {
            tagImage.image = #imageLiteral(resourceName: "xmlid_28")
        } else if tag == "Feeding room" {
            tagImage.image = #imageLiteral(resourceName: "mom_feeding_baby")
        }  else if tag == "Sanitizer" {
            tagImage.image = #imageLiteral(resourceName: "ic_hand_sanitizer")
        } else if tag == "Coffee available" {
            tagImage.image = #imageLiteral(resourceName: "ic_coffee")
        } else if tag == "Makeup available" {
            tagImage.image = #imageLiteral(resourceName: "makeup")
        } else if tag == "Sanitary Pads" {
            tagImage.image = #imageLiteral(resourceName: "group_12487")
        } else if tag == "Safe Space" {
            tagImage.image = #imageLiteral(resourceName: "ic_safe_space_new")
        } else if tag == "Covid Free" {
            tagImage.image = #imageLiteral(resourceName: "ic_hand_sanitizer")
        } else if tag == "Convenience Shop" {
            tagImage.image = #imageLiteral(resourceName: "white_convience_shop")
        }
        else if tag == "Indian Washroom"{
            tagImage.image = UIImage(named: "Indian-Toilet_123-01")
        }
        else if tag == "Western Washroom"{
            tagImage.image = UIImage(named: "toilet")
        }
        else if tag == "Gender Specific" {
            tagImage.image = UIImage(named: "Seprate")
        }
        else if tag == "Unisex" {
            tagImage.image = UIImage(named: "Unisex")
        }
    }
}
