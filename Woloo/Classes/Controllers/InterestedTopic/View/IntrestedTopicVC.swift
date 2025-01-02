//
//  IntrestedTopicVC.swift
//  Woloo
//
//  Created on 02/08/21.
//

import UIKit

class IntrestedTopicVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var listOfCategory = [CategoryInfo]()
    var selectedCategories = [Int]()
    
    var objInterestedTopicViewModel = InterestedTopicViewModel()
    var listCategories = [CategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objInterestedTopicViewModel.delegate = self
        
        intialSetUp()
        //getCategoryAPI()
        self.getCategoryAPICall()
        print("Accessed Token: \(UserDefaultsManager.fetchAuthenticationToken())")
        
        print("Logged in status: \(UserDefaultsManager.fetchIsUserloggedInStatusSave())")
    }
    
    /// UI Configuration.
    private func intialSetUp() {
        navigationController?.navigationBar.isHidden = true
        setupCollectionView()
    }
    
}

// MARK: - @IBAction's
extension IntrestedTopicVC {
    @IBAction func nextAction(_ sender: UIButton) {
        // saveUserCategoryAPI()
        Global.showIndicator()
        self.objInterestedTopicViewModel.saveBlogCategoryAPI(arrInt: selectedCategories)
        //openMainTab()
    }
}

extension IntrestedTopicVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: TopicHeaderCell.identifier, bundle: nil), forCellWithReuseIdentifier: TopicHeaderCell.identifier)
        collectionView.register(UINib(nibName: CategoryCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //section == 0 ? 1 : listOfCategory.count
        section == 0 ? 1 : listCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicHeaderCell.identifier, for: indexPath) as? TopicHeaderCell ?? TopicHeaderCell()
            fillTopicHeaderCell(cell)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell ?? CategoryCell()
        fillCategoryCell(cell,indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
//            if let index = selectedCategories.firstIndex(where: {$0 == listOfCategory[indexPath.item].id }) {
//                selectedCategories.remove(at: index)
//            } else {
//                selectedCategories.append(listOfCategory[indexPath.item].id ?? 0)
//            }
//            collectionView.reloadData()
            if let index = selectedCategories.firstIndex(where: {$0 == listCategories[indexPath.item].id }) {
                selectedCategories.remove(at: index)
            } else {
                selectedCategories.append(listCategories[indexPath.item].id ?? 0)
            }
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
           return CGSize(width: collectionView.frame.width, height: 250)
        }
       return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) : UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  section == 0 ? 5 :0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 5 :0
    }
}

// MARK: - Cell's Handling
extension IntrestedTopicVC {
    /// cell Related all operation do in this method
    /// - Parameter cell: **TopicHeaderCell**
    private func fillTopicHeaderCell(_ cell: TopicHeaderCell) {
        
    }
    
    /// cell Related all operation do in this method
    /// - Parameters:
    ///   - cell: **CategoryCell**
    ///   - item: Index**IndexPath.item**
    private func fillCategoryCell(_ cell: CategoryCell,_ item: Int) {
        cell.setData(listCategories[item])
        cell.bgImageView.isHidden = !selectedCategories.contains(where: {$0 == listCategories[item].id})
    }
}

// MARK: - API Calling
extension IntrestedTopicVC {
    
    func getCategoryAPICall(){
        
        Global.showIndicator()
        self.objInterestedTopicViewModel.getCategoryAPI()
    }
    
    
    fileprivate func getCategoryAPI() {
        APIManager.shared.getCategoryAPI([:]) { [weak self] list, message in
            guard let weak = self else { return }
            if let `list` = list {
                weak.listOfCategory = list.categories ?? []
                weak.collectionView.reloadData()
            }
            print(message)
        }
    }
    
    fileprivate func saveUserCategoryAPI() {
        let param: [String: Any] = [ "categories": selectedCategories ]
        APIManager.shared.saveUserCategoryAPI(param) { [weak self] list, message in
            guard let weak = self else { return }
            if list?.status == .success {
//                weak.navigationController?.popViewController(animated: true)
                
                 //Milan Code
                let tabSB = UIStoryboard(name: "TabBar", bundle: nil)
                if let main = tabSB.instantiateInitialViewController() {
                    weak.navigationController?.pushViewController(main, animated: true)
                }
                //DELEGATE.rootVC?.tabBarVc?.selectedIndex = 2
            }
            print(message)
        }
    }
}

// MARK: - Handle Other Controller
extension IntrestedTopicVC {
    private func openMainTab() {
        let tabSB = UIStoryboard(name: "TabBar", bundle: nil)
        if let main = tabSB.instantiateInitialViewController() {
            navigationController?.pushViewController(main, animated: true)
        }
    }
}

extension IntrestedTopicVC: InterestedTopicViewModelDelegate{
    //MARK: - InterestedTopicViewModelDelegate
    //Save category API
    func didRecieveSaveCategorySuccess(objWrapper: BaseResponse<StatusSuccessResponseModel>) {
        Global.hideIndicator()
        let tabSB = UIStoryboard(name: "TabBar", bundle: nil)
        if let main = tabSB.instantiateInitialViewController() {
            self.navigationController?.pushViewController(main, animated: true)
        }
    }
    
    func didRecieveSaveCategoryError(strError: String?) {
        Global.hideIndicator()
        self.showToast(message: strError ?? "")
    }
    
    
//Get category API
    func didRecieveGetCategoryResponse(objWraper: BaseResponse<[CategoryModel]>) {
        Global.hideIndicator()
        self.listCategories = objWraper.results
        self.collectionView.reloadData()
        print("self.listOfCategory.count: ", self.listCategories.count)
    }
    
    func didReceiveGetCategoryError(strError: String?) {
        Global.hideIndicator()
    }
    
    
    
}
