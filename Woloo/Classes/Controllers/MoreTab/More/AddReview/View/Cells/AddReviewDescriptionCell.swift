//
//  AddReviewDescriptionCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 11/11/24.
//

import UIKit

protocol AddReviewDescriptionCellDelegate: NSObjectProtocol{
    func didAddReview(feedback: String?)
}

class AddReviewDescriptionCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var txtVw: UITextView!
    @IBOutlet weak var vwBack: UIView!
    
    var feedBack: String? = ""
    weak var delegate: AddReviewDescriptionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBack.layer.borderWidth = 1.0
        self.vwBack.layer.cornerRadius = 10.0
        self.vwBack.layer.borderColor = UIColor.lightGray.cgColor
        
        self.txtVw.delegate = self
        
    }

    func configureAddReviewDescriptionCell(feedBack: String?){
        
        self.feedBack = feedBack ?? ""
        
        self.txtVw.text = self.feedBack
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.feedBack = textView.text
        
        if delegate != nil{
            self.delegate?.didAddReview(feedback:  self.feedBack)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
