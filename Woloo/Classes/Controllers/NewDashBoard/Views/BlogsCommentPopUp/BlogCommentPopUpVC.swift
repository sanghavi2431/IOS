//
//  BlogCommentPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 05/05/25.
//

import UIKit

protocol BlogCommentPopUpVCDelegate: NSObjectProtocol{
    
    func clickedAddCommentBtn(objBlogModel: BlogModel?)
}

class BlogCommentPopUpVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoComment: UILabel!
    
    var objWolooDashboardViewModel = WolooDashboardViewModel()
    var listBlogsComment = [GetBlogComments]()
    var objBlogModel = BlogModel()
    var baseUrl: String?
    var delegate: BlogCommentPopUpVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }
    
    func loadInitialSettings(){
        
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        
        self.objWolooDashboardViewModel.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        
        self.objWolooDashboardViewModel.getBlogsCommentAPI(blogID: self.objBlogModel.id ?? 0)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedAddCommentBtn(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.clickedAddCommentBtn(objBlogModel: self.objBlogModel)
            self.dismiss(animated: true)
        }
        
    }
    
}

