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
       // self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor.backgroundColor.cgColor
        
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
            tagImage.image = UIImage(named: "icon_clean_toilet")
        } else if tag == "Wheelchair" {
            tagImage.image = UIImage(named: "icon_wheelchair")
        } else if tag == "Feeding room" {
            tagImage.image = UIImage(named: "icon_feeding_room")
        }  else if tag == "Sanitizer" {
            tagImage.image = UIImage(named: "icon_sanitizer")
        } else if tag == "Coffee available" {
            tagImage.image = UIImage(named: "icon_coffee_available")
        } else if tag == "Makeup available" {
            tagImage.image = UIImage(named: "icon_makeup_available")
        } else if tag == "Sanitary Pads" {
            tagImage.image = UIImage(named: "icon_sanitary_pads")
        } else if tag == "Safe Space" {
            tagImage.image = UIImage(named: "icon_safe_space")
        } else if tag == "Covid Free" {
            tagImage.image = UIImage(named: "icon_covid_free")
        } else if tag == "Convenience Shop" {
            tagImage.image = #imageLiteral(resourceName: "white_convience_shop")
        }
        else if tag == "Indian Washroom"{
            tagImage.image = UIImage(named: "icon_indian_washroom")
        }
        else if tag == "Western Washroom"{
            tagImage.image = UIImage(named: "icon_western_washroom")
        }
        else if tag == "Gender Specific" {
            tagImage.image = UIImage(named: "icon_gender_specific")
        }
        else if tag == "Unisex" {
            tagImage.image = UIImage(named: "icon_unisex")
        }
    }
}
