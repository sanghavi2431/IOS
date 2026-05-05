//
//  FeebackCell.swift
//  Woloo
//
//  Created by Vivek shinde on 23/12/20.
//

import UIKit
protocol FeedBackCellDelegate: class {
    func didEndFeedBack(_ text: String)
}
class FeedbackCell: UITableViewCell {

    @IBOutlet weak var descriptionTextView: UITextView!
    weak var delegate: FeedBackCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupCell() {
        self.descriptionTextView.delegate = self
    }
}

// MARK: - UITextViewDelegate
extension FeedbackCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        
        print("textViewDidEndEditing\(textView.text)")
        delegate?.didEndFeedBack(textView.text)
    }
}
