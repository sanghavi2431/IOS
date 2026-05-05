
//
//  RatingCell.swift
//  Woloo
//
//  Created by Vivek shinde on 23/12/20.
//

import UIKit

class RatingCell: UITableViewCell {
    
    @IBOutlet weak var ratingTagListView: TagListView!
    
    func configureUI(_ tagArray : [RatingOptions] ,_ selectedTag: String,_ delegate : TagListViewDelegate?)  {
        let tags = tagArray.compactMap({$0.displayName})
        ratingTagListView.delegate = delegate
        ratingTagListView.removeAllTags()
        ratingTagListView.addTags(tags)
        if let selectedtag = ratingTagListView.tagViews.first(where: {$0.titleLabel?.text?.lowercased() == selectedTag.lowercased()}) {
            selectedtag.isSelected = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}



