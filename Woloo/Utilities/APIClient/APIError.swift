//
//  APIError.swift
//  KinoClub
//
//  Created by Amzad-Khan on 27/11/19.
//  Copyright © 2019 Jetsynthesys. All rights reserved.
//

import Foundation
import UIKit
/*------------------- Alert controller from Error ----------------*/
extension UIAlertController {
    convenience init<Error>(_ error: Error,
                            preferredStyle: UIAlertController.Style)
    where Error: CustomStringConvertible {
        let title = ""
        let message = error.description
        
        self.init(title: title,
                  message: message,
                  preferredStyle: preferredStyle)
    }
}

//------------ CustomStringConvertible -----------
extension APIRestClient.APIServiceError : CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .apiError: return "Error return by URLSession."
        case .invalidEndpoint: return "Invalid API"
        case .invalidResponse: return "Invalid response received from server"
        case .noData: return "No data available"
        case .decodeError: return "Json parsing error"
        case .networkError: return "No internet connection."
        case .successWithError(let wrapper):
            return wrapper.message ?? "Server return error."
        }
    }
    
    func alert(sender:UIViewController? = nil, completion:((Bool)->Void)? = nil) {
        //Show only custom error send by server with wrapper model.
        if case .successWithError(_) = self {
            
            let vc = sender ?? UIApplication.shared.keyWindow?.rootViewController
            //Global.showBottomToast(message:self.description)
            let alert = UIAlertController(self, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizedString(key: StringConstants.okay, value: ""), style: .default, handler: { (action) in
                if let completion = completion {
                    completion(true)
                }
            }))
            
            DispatchQueue.main.async {
                vc?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
