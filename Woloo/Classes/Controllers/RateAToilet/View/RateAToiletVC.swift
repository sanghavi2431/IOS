//
//  RateAToiletVC.swift
//  Woloo
//
//  Created by Kapil Dongre on 20/01/25.
//

import UIKit

class RateAToiletVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var sourceLat, sourceLong : Double?
    var sourceAddress, city, strPincode, strName : String?
    var objRateAToiletViewModel = RateAToiletViewModel()
    var sliderValues: [IndexPath: Float] = [:]
    var rating: Float?
    var feedBack = ""
    var objSearchWoloo = SearchWoloo()
    var selectedTags = [RatingOptions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rating = 3
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        self.objRateAToiletViewModel.delegate = self
    }
    

    

}
