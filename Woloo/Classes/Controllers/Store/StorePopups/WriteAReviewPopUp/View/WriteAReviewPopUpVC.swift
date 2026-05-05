//
//  WriteAReviewPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 10/03/25.
//

import UIKit

class WriteAReviewPopUpVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnRate1: UIButton!
    @IBOutlet weak var btnRate2: UIButton!
    @IBOutlet weak var btnRate3: UIButton!
    @IBOutlet weak var btnRate4: UIButton!
    @IBOutlet weak var btnRate5: UIButton!
    
    
    var rating: Int?
   
    var strProductID: String? = ""
    var objWriteAReviewPopViewModel =  WriteAReviewPopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }


    
    func loadInitialSettings(){
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.55)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        
        self.objWriteAReviewPopViewModel.delegate = self
        self.txtView.delegate = self
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func clickedSubmitBtn(_ sender: UIButton) {
        
        self.objWriteAReviewPopViewModel.addReviewAPI(strProductId: strProductID, rating: self.rating, strComment: self.txtView.text ?? "")
    }
    
    func textViewDidChange(_ textView: UITextView) {
            
        print("Updated User Input: \(txtView.text ?? "")")
        }
    
    @IBAction func clickedBtnRate1(_ sender: UIButton) {
        
        self.btnRate1.isSelected = true
        if self.btnRate1.isSelected == true{
                  self.btnRate1.isSelected = true
                  self.btnRate2.isSelected = false
                  self.btnRate3.isSelected = false
                  self.btnRate4.isSelected = false
                  self.btnRate5.isSelected = false
      
                  self.rating = 0
      
      
              }
    }
    
    @IBAction func clickedBtnRate2(_ sender: UIButton) {
        
        self.btnRate2.isSelected = true
        if self.btnRate2.isSelected == true{
            self.btnRate1.isSelected = true
            self.btnRate2.isSelected = true
            self.btnRate3.isSelected = false
            self.btnRate4.isSelected = false
            self.btnRate5.isSelected = false
            
            self.rating = 2
        }
       
    }
    
    @IBAction func clickedBtnRate3(_ sender: UIButton) {
        self.btnRate3.isSelected = true
        if self.btnRate3.isSelected == true{
            self.btnRate1.isSelected = true
            self.btnRate2.isSelected = true
            self.btnRate3.isSelected = true
            self.btnRate4.isSelected = false
            self.btnRate5.isSelected = false
            
            self.rating = 3
        }
  
    }
    
    @IBAction func clickedBtnRate4(_ sender: UIButton) {
        self.btnRate4.isSelected = true
        if self.btnRate4.isSelected == true{
       
                   self.btnRate1.isSelected = true
                   self.btnRate2.isSelected = true
                   self.btnRate3.isSelected = true
                   self.btnRate4.isSelected = true
                   self.btnRate5.isSelected = false
       
                   self.rating = 4
               }
    }
    
    @IBAction func clickedBtnRate5(_ sender: UIButton) {
        self.btnRate5.isSelected = true
                if self.btnRate5.isSelected == true{
        
                    self.btnRate1.isSelected = true
                    self.btnRate2.isSelected = true
                    self.btnRate3.isSelected = true
                    self.btnRate4.isSelected = true
                    self.btnRate5.isSelected = true
        
                    self.rating = 5
                }
    }
}

//MARK: Extensions
extension WriteAReviewPopUpVC: WriteAReviewPopViewModelDelegate{
    
    //MARK: - WriteAReviewPopViewModelDelegate
    func didRecieveAddreviewSuccess(objWrapper: ProductReviewWrapper?) {
        print("Review Added")
        self.dismiss(animated: true)
    }
    
    func didRecieveAddreviewAPIError(strError: String?) {
        print("API Error")
    }
}
