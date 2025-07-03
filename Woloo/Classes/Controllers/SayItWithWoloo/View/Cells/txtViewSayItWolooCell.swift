//
//  txtViewSayItWolooCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 23/01/25.
//

import UIKit

protocol txtViewSayItWolooCellDelegate: NSObjectProtocol{
    
    func didChangedDesc(objAddMessageModel: AddMessageModel?)
}

class txtViewSayItWolooCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var txtVWDesc: UITextView!
    @IBOutlet weak var txtVwBack: UIView!
    
    var objAddMessageModel = AddMessageModel()
    var delegate: txtViewSayItWolooCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtVwBack.layer.cornerRadius = 29.64
        self.txtVWDesc.delegate = self
    }

    func configureTxtViewSayItWolooCell(obj: AddMessageModel?) {
        self.objAddMessageModel = obj ?? AddMessageModel()
        if Utility.isEmpty(obj?.Msg ?? ""){
            txtVWDesc.text = "Enter a thoughtful message"
            txtVWDesc.textColor = UIColor.lightGray
        }
        else{
            txtVWDesc.textColor = UIColor.black
            txtVWDesc.text = self.objAddMessageModel.Msg ?? ""
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.txtVWDesc.text = ""
        txtVWDesc.textColor = UIColor.black
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.objAddMessageModel.Msg = textView.text
        self.delegate?.didChangedDesc(objAddMessageModel: self.objAddMessageModel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
