//
//  Toast.swift
//  Woloo
//
//  Created by Ashish Khobragade on 18/12/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import UIKit

class Toast {
    
    static var shared:Toast {
        
        let sharedObject = Toast()
        
        return sharedObject
    }
    
    var notifyLabel = UILabel()
    
     func show(message:String) {
        
        self.remove()
        
        var notifyLabelHeight:CGFloat = 0.0
        notifyLabel.isEnabled = true
        notifyLabel.isOpaque = true
        
        #if os(iOS)
        
        if Device.IS_IPHONE_6_OR_LESS{
            
            notifyLabelHeight = 20
        }
        else{
            notifyLabelHeight = 50.0
        }
        #elseif os(tvOS)
        
        notifyLabelHeight = 40.0
        
        #endif
        
        notifyLabel.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height, width:UIScreen.main.bounds.size.width, height:notifyLabelHeight)
        notifyLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        notifyLabel.numberOfLines = 0
        notifyLabel.text = message
        notifyLabel.textAlignment = .center
        notifyLabel.textColor = UIColor.white
        notifyLabel.alpha = 1.0
        notifyLabel.tag = 70707070
        
        #if os(iOS)
        notifyLabel.font = ThemeManager.Font.MavenPro_Regular()
        #elseif os(tvOS)
        notifyLabel.font = ThemeManager.Font.Montserrat_Regular(size: 24)
        #endif
        DELEGATE.window?.addSubview(notifyLabel)
        // Fallback on earlier versions
        let bottomPadding = (DELEGATE.window?.safeAreaInsets.bottom ?? 0) + 25.0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: UIView.AnimationOptions.curveEaseIn, animations:{
            
            self.notifyLabel.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height - notifyLabelHeight - bottomPadding , width:UIScreen.main.bounds.size.width, height:notifyLabelHeight)
            DELEGATE.window?.bringSubviewToFront(self.notifyLabel)

            
        }, completion:{ finished in
            
            UIView.animate(withDuration: 0.3, delay: 2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseOut, animations:{
                
                self.notifyLabel.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height, width:UIScreen.main.bounds.size.width, height:notifyLabelHeight)
            }, completion: { finished in
                
                self.notifyLabel.removeFromSuperview()
            })
        })
        
    }
    
    func remove()  {
        
        if let subviews = DELEGATE.window?.subviews{
            
            for notifyLabel in subviews{
                
                if ((notifyLabel as? UILabel) != nil){
                    
                    if notifyLabel.tag == 70707070{
                        notifyLabel.removeFromSuperview()
                        break
                    }
                }
            }
        }
    }
}
