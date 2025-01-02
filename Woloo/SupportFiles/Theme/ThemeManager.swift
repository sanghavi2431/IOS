//
//  ThemeManager.swift
//  Woloo
//
//  Created by Ashish Khobragade on 18/12/20.
//

import UIKit

class ThemeManager: NSObject {
    
    
    //Yellow : #ffe141
    
    struct Font {
        
        static func OpenSans_Regular(size:Int = 9) -> UIFont{
            
            return UIFont(name: "OpenSans-Regular", size: CGFloat(size))!
        }
        
        static func OpenSans_Semibold(size:CGFloat = 9) -> UIFont{
                   
            return UIFont(name: "OpenSans-SemiBold", size: CGFloat(size))!
        }
        
        static func OpenSans_bold(size:Int = 9) -> UIFont{
                   
            return UIFont(name: "OpenSans-Bold", size: CGFloat(size))!
        }
        
        static func OpenSans_Light(size:Int = 9) -> UIFont{
                   
            return UIFont(name: "OpenSans-Light", size: CGFloat(size))!
        }
        
        
        static func MavenPro_Regular(size:Int = 9) -> UIFont{
            
            return UIFont(name: "MavenPro-Regular", size: CGFloat(size))!
        }
        
        static func MavenPro_Semibold(size:Int = 9) -> UIFont{
                   
            return UIFont(name: "MavenPro-SemiBold", size: CGFloat(size))!
        }
        
        static func MavenPro_bold(size:Int = 9) -> UIFont{
                   
            return UIFont(name: "MavenPro-Bold", size: CGFloat(size))!
        }
        
        static func MavenPro_Medium(size:Int = 9) -> UIFont{
                   
            return UIFont(name: "MavenPro-Medium", size: CGFloat(size))!
        }
        
        
    }
    
    struct BorderWidth {
        static let Border_Width_1 = 1.0
        static let Border_Width_2 = 2.0
    }
}


extension UIColor {
    
    static var main:UIColor {
        return #colorLiteral(red: 1, green: 0.9407282472, blue: 0, alpha: 1)
    }
    
    static var backgroundColor:UIColor {
        return #colorLiteral(red: 0.2549493909, green: 0.2508341074, blue: 0.2590603232, alpha: 1)
    }
    
    static var textColor:UIColor {
        return #colorLiteral(red: 0.8273604512, green: 0.8275031447, blue: 0.8273514509, alpha: 1)
    }
}
