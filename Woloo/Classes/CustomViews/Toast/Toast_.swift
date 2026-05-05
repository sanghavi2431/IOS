////
////  Toast.swift
////  Woloo
////
////  Created by Ashish Khobragade on 18/12/20.
////  Copyright © 2020 Ashish Khobragade. All rights reserved.
////
//
//import UIKit
//
//class Toast {
//
//    static var shared:Toast {
//
//        let sharedObject = Toast()
//
//        return sharedObject
//    }
//
//    var notifyLabel = UILabel()
//
//     func show(message:String) {
//        DispatchQueue.main.async {
//            self.remove()
//
//            var notifyLabelHeight:CGFloat = 0.0
//            self.notifyLabel.isEnabled = true
//            self.notifyLabel.isOpaque = true
//
//            #if os(iOS)
//
//            if Device.IS_IPHONE_6_OR_LESS{
//
//                notifyLabelHeight = 60
//            }
//            else{
//                notifyLabelHeight = 60.0
//            }
//            #elseif os(tvOS)
//
//            notifyLabelHeight = 60.0
//
//            #endif
//
//            self.notifyLabel.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height, width:UIScreen.main.bounds.size.width, height:notifyLabelHeight)
//            self.notifyLabel.backgroundColor = UIColor(named: "Woloo_Yellow")
//            self.notifyLabel.numberOfLines = 0
//            self.notifyLabel.text = message
//            self.notifyLabel.textAlignment = .center
//            self.notifyLabel.textColor = .black
//            self.notifyLabel.alpha = 1.0
//            self.notifyLabel.tag = 70707070
//
//            #if os(iOS)
//            self.notifyLabel.font = ThemeManager.Font.MavenPro_Regular(size: 14)
//            #elseif os(tvOS)
//            self.notifyLabel.font = ThemeManager.Font.Montserrat_Regular(size: 24)
//            #endif
//            DELEGATE.window?.addSubview(self.notifyLabel)
//            // Fallback on earlier versions
//            let bottomPadding = (DELEGATE.window?.safeAreaInsets.bottom ?? 0) + 35.0
//
//            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: UIView.AnimationOptions.curveEaseIn, animations:{
//
//                self.notifyLabel.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height - notifyLabelHeight - bottomPadding , width:UIScreen.main.bounds.size.width, height:notifyLabelHeight)
//                DELEGATE.window?.bringSubviewToFront(self.notifyLabel)
//
//
//            }, completion:{ finished in
//
//                UIView.animate(withDuration: 0.3, delay: 2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseOut, animations:{
//
//                    self.notifyLabel.frame = CGRect(x:0, y:UIScreen.main.bounds.size.height, width:UIScreen.main.bounds.size.width, height:notifyLabelHeight)
//                }, completion: { finished in
//
//                    self.notifyLabel.removeFromSuperview()
//                })
//            })
//
//        }
//
//    }
//
//    func remove()  {
//
//        if let subviews = DELEGATE.window?.subviews{
//
//            for notifyLabel in subviews{
//
//                if ((notifyLabel as? UILabel) != nil){
//
//                    if notifyLabel.tag == 70707070{
//                        notifyLabel.removeFromSuperview()
//                        break
//                    }
//                }
//            }
//        }
//    }
//}
