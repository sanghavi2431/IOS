//
//  StoreFavouriteViewController.swift
//  Woloo
//
//  Created by CEPL on 10/04/25.
//

import UIKit

class StoreFavouriteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Fetched Wishlist ID", UserDefaultsManager.fetchWishListID())
        self.loadInitialSettigs()
    }


    func loadInitialSettigs(){
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }

}
