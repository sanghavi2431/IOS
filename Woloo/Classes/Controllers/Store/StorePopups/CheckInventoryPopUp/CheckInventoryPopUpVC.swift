//
//  CheckInventoryPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 27/06/25.
//

import UIKit

protocol CheckInventoryPopUpVCDelegate: NSObject{
    
    func didClickedBtnNotify(objCartItems: CartItems)
}

class CheckInventoryPopUpVC: UIViewController {

    @IBOutlet weak var tableViw: UITableView!
   
    var listItems = [Errors]()
    var listCartItems = [CartItems]()
    weak var delegate: CheckInventoryPopUpVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }

    func loadInitialSettings(){
        self.tableViw.delegate = self
        self.tableViw.dataSource = self
        
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}
