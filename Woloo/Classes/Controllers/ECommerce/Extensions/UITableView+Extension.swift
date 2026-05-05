//
//  UITableView+Extension.swift
//  Woloo
//
//  Created by Rahul Patra on 07/08/21.
//

import Foundation
import UIKit

extension UITableView {
    
    enum ErrorMessageType {
        case removeMessage
        case error(String)
    }
    
    func setErrorSuccessMessage(withErrorType type: ErrorMessageType) {
        switch type {
        case .error(let message):
            let label = UILabel()
            label.font = .italicSystemFont(ofSize: 20)
            label.textColor = .black
            label.text = "\(message)"
            label.frame = self.frame
            label.textAlignment = .center
            self.backgroundView = label
            
        case .removeMessage:
            self.backgroundView = nil
        }
    }
}

extension UICollectionView {
    
    enum ErrorMessageType {
        case removeMessage
        case error(String)
    }
    
    func setErrorSuccessMessage(withErrorType type: ErrorMessageType) {
        switch type {
        case .error(let message):
            let label = UILabel()
            label.font = .italicSystemFont(ofSize: 20)
            label.textColor = .black
            label.text = "\(message)"
            label.frame = self.frame
            label.textAlignment = .center
            self.backgroundView = label
            
        case .removeMessage:
            self.backgroundView = nil
        }
    }
}


extension UIViewController {
    func showAlertWithActionOkandCancel(Title: String , Message: String , OkButtonTitle: String ,CancelButtonTitle: String ,outputBlock:@escaping ()->Void) {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: CancelButtonTitle, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: OkButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
            outputBlock()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
