//
//  WriteAReviewPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 10/03/25.
//

import UIKit

class WriteAReviewPopUpVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var txtView: UITextView!
    
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
        
        self.objWriteAReviewPopViewModel.addReviewAPI(strProductId: "prod_01JPCSVZX498NB3F8X9W4MJJ7W", rating: 5, strComment: self.txtView.text ?? "")
    }
    
    func textViewDidChange(_ textView: UITextView) {
            
        print("Updated User Input: \(txtView.text ?? "")")
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
