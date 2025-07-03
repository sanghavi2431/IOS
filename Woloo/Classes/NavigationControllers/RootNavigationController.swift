//
//  RootNavigationController.swift
//  Woloo
//
//  Created by Ashish Khobragade on 16/10/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    
    override func viewDidLoad() {
        #if os(iOS)
        
//        self.navigationBar.barTintColor = ThemeManager.Color.ThemeColor_white
//        self.navigationBar.items?.first?.backBarButtonItem?.tintColor = ThemeManager.Color.ThemeColor_black
//        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: ThemeManager.Font.Montserrat_bold(size: 17)]
        #endif

    }
    
}
