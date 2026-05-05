//
//  PeriodInfoVC.swift
//  Woloo
//
//  Created by ideveloper2 on 30/10/21.
//

import UIKit

class PeriodInfoVC: UIViewController {

    
    @IBOutlet weak var vwBackMenstrualCycle: UIView!
    @IBOutlet weak var vwBackPregnancyCycle: UIView!
    @IBOutlet weak var vwBackOvulationCycle: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwBackMenstrualCycle.layer.cornerRadius = 23.0
        self.vwBackPregnancyCycle.layer.cornerRadius = 23.0
        self.vwBackOvulationCycle.layer.cornerRadius = 23.0

    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: false) {
            self.view.backgroundColor = UIColor.clear
        }
    }
}
