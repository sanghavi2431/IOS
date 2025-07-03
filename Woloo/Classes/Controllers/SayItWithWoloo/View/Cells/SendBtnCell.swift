//
//  SendBtnCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 23/01/25.
//

import UIKit

protocol SendBtnCellProtocol: NSObjectProtocol{
    func didClickedSendBtn()
}

class SendBtnCell: UITableViewCell {

    @IBOutlet weak var btnSend: UIButton!
    
    weak var delegate: SendBtnCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnSend.layer.cornerRadius = 25.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didClickedSendBtnAction(_ sender: Any) {
        self.delegate?.didClickedSendBtn()
    }
    
}
