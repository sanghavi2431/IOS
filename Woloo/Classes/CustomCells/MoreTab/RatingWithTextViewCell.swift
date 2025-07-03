//
//  RatingWithTextViewCell.swift
//  Woloo
//
//  Created by Vivek shinde on 23/12/20.
//

import UIKit

class RatingWithTextViewCell: RatingCell {

    
    @IBOutlet weak var tagsView: UIView!
    @IBOutlet weak var titleForSection: UILabel!
    @IBOutlet var textFieldHeightConstraints: NSLayoutConstraint!
    
    let tagsField = WSTagsField()
    
    var removeTag: ((_ tag: String) -> Void)?
    
    func insertTags( _ title : String)  {
        tagsField.addTag(title)
        if tagsField.tags.count > 2 {
            textFieldHeightConstraints?.isActive = false
        } else {
            if let constraint = textFieldHeightConstraints {
                constraint.isActive = true
                constraint.constant = 60
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)
        
        tagsField.cornerRadius = 10.0
        tagsField.spaceBetweenLines = 10
        tagsField.spaceBetweenTags = 10
        
        //tagsField.numberOfLines = 3
        //tagsField.maxHeight = 100.0

        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        tagsField.placeholder = ""
        tagsField.placeholderColor = UIColor(red: 78.0/255, green: 78.0/255, blue: 78.0/255, alpha: 1)
        tagsField.placeholderAlwaysVisible = true
        tagsField.backgroundColor = .clear
        tagsField.tintColor = #colorLiteral(red: 0.9960784314, green: 0.9294117647, blue: 0.0431372549, alpha: 1)
        tagsField.textColor = UIColor.black
        tagsField.fieldTextColor = #colorLiteral(red: 0.9960784314, green: 0.9294117647, blue: 0.0431372549, alpha: 1)
        tagsField.delimiter = ""
        tagsField.textDelegate = self
        tagsField.textField.isUserInteractionEnabled = false
        tagsField.font = ThemeManager.Font.OpenSans_Semibold(size: 14)
        textFieldEvents()
    }

    
    fileprivate func textFieldEvents() {
        tagsField.onDidAddTag = { field, tag in
            
        }

        tagsField.onDidRemoveTag = { field, tag in
            if self.tagsField.tags.count < 2 {
                self.textFieldHeightConstraints?.isActive = true
            }
            self.ratingTagListView.addTag(tag.text)
            self.removeTag?(tag.text)
        }

        tagsField.onDidChangeText = { _, text in
        }

        tagsField.onDidChangeHeightTo = { _, height in
            
        }

        tagsField.onDidSelectTagView = { _, tagView in
        }

        tagsField.onDidUnselectTagView = { _, tagView in
        }

        tagsField.onShouldAcceptTag = { field in
            return field.text != "OMG"
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RatingWithTextViewCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tagsField {

        }
        return true
    }

}
