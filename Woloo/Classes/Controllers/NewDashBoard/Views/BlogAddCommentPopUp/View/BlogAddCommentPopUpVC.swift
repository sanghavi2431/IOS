//
//  BlogAddCommentPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 06/05/25.
//

import UIKit

protocol BlogAddCommentPopUpVCDelegate: NSObjectProtocol{
    func didAddComment(comment: String, blogID: Int)
}

class BlogAddCommentPopUpVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtView: UITextView!
    
    var objBlogModel = BlogModel()
    weak var delegate: BlogAddCommentPopUpVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }
    
    func loadInitialSettings(){
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.40)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        
        self.txtView.delegate = self
        
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    
    @IBAction func clickedDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedSubmitBtn(_ sender: UIButton) {
        
        if Utility.isEmpty(txtView.text ?? ""){
            showToast(message: "Please Enter Comment")
        }
        else{
            if self.delegate != nil{
                self.delegate?.didAddComment(comment: txtView.text ?? "", blogID: self.objBlogModel.id ?? 0)
                self.dismiss(animated: true)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
            
        print("Updated User Input: \(txtView.text ?? "")")
        }
}
