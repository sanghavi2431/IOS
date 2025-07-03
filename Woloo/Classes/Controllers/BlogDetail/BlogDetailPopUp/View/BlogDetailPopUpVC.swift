//
//  BlogDetailPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 03/05/25.
//

import UIKit
import AVKit
import STPopup


protocol BlogDetailPopUpVCDelegate: NSObject{
    
    func didUpdatedCommentStatus()
}


class BlogDetailPopUpVC: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var blogDescroptionLabel: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var vwBackShopNow: UIView!
    
    @IBOutlet weak var btnLike: UIButton!
    
    
    var objWolooDashboardViewModel = WolooDashboardViewModel()
    var objBlogModel = BlogModel()
    var baseUrl: String?
    var indexOfItem = 0
    var detailType: String? = ""
    weak var delegate: BlogDetailPopUpVCDelegate?
    var isShowAddPointsPopup: Bool? = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        self.vwBackShopNow.layer.cornerRadius = 25.0
        self.videoContainerView.layer.cornerRadius = 25.0
        self.videoContainerView.clipsToBounds = true
        
        self.loadInitialSettings()
        self.collectionView.register(ProductItemImageCollectionCell.nib, forCellWithReuseIdentifier: ProductItemImageCollectionCell.identifier)
        collectionView.reloadData()
        
        if self.objBlogModel.isFavourite == 1{
            self.btnLike.isSelected = true
        }else{
            self.btnLike.isSelected = false
        }
        
        if self.objBlogModel.isBlogRead == 0{
            DispatchQueue.main.async{
                let objController = BlogsPointsPopUpVC(nibName: "BlogsPointsPopUpVC", bundle: nil)
                objController.delegate = self
                let popup = STPopupController(rootViewController: objController)
                popup.present(in: self)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func loadInitialSettings(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.objWolooDashboardViewModel.delegate = self
        self.blogDescroptionLabel.text =  self.objBlogModel.title?.capitalized
        
        
        if detailType == "VIDEO" {
            self.pageController.isHidden = true
            self.collectionView.isHidden = true
            self.videoContainerView.isHidden = false
            let videoPath = self.objBlogModel.main_video?.first ?? ""
            let strVideoUrl = "\(self.baseUrl ?? "")\(videoPath)"
            
            DispatchQueue.main.async {
                guard let url = URL(string: strVideoUrl) else { return }

                // Remove existing player view if reused
                for subview in self.videoContainerView.subviews {
                    subview.removeFromSuperview()
                }

                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                playerViewController.view.frame = self.videoContainerView.bounds
                playerViewController.showsPlaybackControls = true
                playerViewController.videoGravity = .resizeAspectFill
                // Add the playerViewController as a child view controller
                self.addChild(playerViewController)
                self.videoContainerView.addSubview(playerViewController.view)
                playerViewController.didMove(toParent: self)

                player.play()
            }
        }
        else{
            self.videoContainerView.isHidden = true
            self.collectionView.isHidden = false
            if self.objBlogModel.mainImage?.count ?? 0 <= 1{
                self.pageController.isHidden = true
            }
            else{
                self.pageController.numberOfPages = self.objBlogModel.mainImage?.count ?? 0
            }
            
        }
        
       
        
        self.txtView.attributedText = self.objBlogModel.content?.htmlToAttributedString
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        //self.dismiss(animated: true)
    }
    
    
    @IBAction func clickedBackbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedBtnDismiss(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedShopNowBtn(_ sender: UIButton) {
        
        
        if Utility.isEmpty(self.objBlogModel.shop_map_id ?? ""){
            
        }
        else{
            let objController = StoreItemDetailsVC.init(nibName: "StoreItemDetailsVC", bundle: nil)
            objController.strProductID = self.objBlogModel.shop_map_id ?? ""
            
            self.navigationController?.pushViewController(objController, animated: true)
        }
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
       
        self.btnLike.isSelected.toggle()
        
        if self.delegate != nil {
            self.delegate?.didUpdatedCommentStatus()
        }
        
        self.favouriteBLOGV2(self.objBlogModel.id ?? 0)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        let urlStr = self.objBlogModel.detailedShortLink ?? ""
        let blogTitle = self.objBlogModel.title ?? ""
        //let imageUrl = "\(API.environment.baseURL)public/blog/\(self.objBlogDetailModel.blogs[id].mainImage?[0] ?? "")"
      // let image = UIImage(contentsOfFile: imageUrl)
     //  let imageToShare = [image]
       let text = "\(blogTitle) \n\n\(urlStr)"
       let shareAll = [text as Any]
       let activityVC = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
       activityVC.popoverPresentationController?.sourceView = self.view
       self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        print("Call show comments api", objBlogModel.id ?? 0)
        DispatchQueue.main.async {
            
            let objController = BlogCommentPopUpVC(nibName: "BlogCommentPopUpVC", bundle: nil)
           
            objController.delegate = self
            objController.objBlogModel = self.objBlogModel
            objController.baseUrl = self.baseUrl
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    func favouriteBLOGV2(_ id: Int){
       
       let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
       print("App Build: \(AppBuild)")
       var systemVersion = UIDevice.current.systemVersion
       print("System Version : \(systemVersion)")
       var iOS = "IOS"
       var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
       print("UserAgent: \(userAgent)")
       let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
       
       let data = ["blog_id": id]
       
       Global.showIndicator()
       
       if !Connectivity.isConnectedToInternet(){
           //Do something if network not found
           showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
               print("no network found")
           }
           return
       }
       
       
       NetworkManager(data: data, headers: headers, url: nil, service: .ctaFavourite, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<ctaFavouriteModel>, Error>) in
           
           switch result{
               
           case .success(let response):
               Global.hideIndicator()
               print("CTA favourite response: \(response)")
               //self.getBlogsAndCategoryAPIV2(cat: "All")
               
           case .failure(let error):
               Global.hideIndicator()
               print("CTA favourite error: \(error)")
               
               
           }
       }
       
       
   }
    
}
