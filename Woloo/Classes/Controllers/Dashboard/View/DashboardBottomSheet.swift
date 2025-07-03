//
//  DashboardBottomSheet.swift
//  Woloo
//
//  Created by Kapil Dongre on 24/01/25.
//

import UIKit


class DashboardBottomSheet: UIViewController {

    
    @IBOutlet weak var vwBack2: UIView!
    @IBOutlet weak var vwBack4: UIView!
    @IBOutlet weak var vwBack6: UIView!
    
    weak var delegate: DashboardBottomSheetDelegate?
    var lat: Double?
    var lng: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }


    func loadInitialSettings(){
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width, height: 150)
        self.popupController?.containerView.layer.cornerRadius = 10.0
        self.popupController?.navigationBarHidden = true
        //let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        
        self.vwBack2.layer.cornerRadius = 10.0
        self.vwBack4.layer.cornerRadius = 10.0
        self.vwBack6.layer.cornerRadius = 10.0
    }
    
    @IBAction func clickedbtn2kms(_ sender: UIButton) {
        
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 2)
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedBtn4kms(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 4)
        }
        self.dismiss(animated: true)
    }
    
    
    @IBAction func clickedBtnkms(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 6)
        }
        self.dismiss(animated: true)
    }
}
