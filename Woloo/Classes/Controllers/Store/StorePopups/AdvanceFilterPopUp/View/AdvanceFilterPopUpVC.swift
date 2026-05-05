//
//  AdvanceFilterPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 17/04/25.
//

import UIKit

protocol AdvanceFilterPopUpProtocol: NSObject{
    func didClickedApplyBtn(strCatId: String?, strOptionName: String?)
    func didClickedResetBtn()
}

class AdvanceFilterPopUpVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var listCategories = [StoreProductCategories]()
    var listOptions = ProductOptions()
    var listProducts = [Products]()
    var cpyListProducts = [Products]()
    var optionsValues: [String] = []
    var filteredOptionsValues: [SizeOption] = []
    weak var delegate: AdvanceFilterPopUpProtocol?
    var strCatID: String? = ""
    var strOptionName: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
        print("list categories count: ", self.listCategories.count)
    }
    
    func loadInitialSettings(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.65)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        for product in listProducts {
            if let options = product.options {
                for option in options {
                    if let title = option.title?.lowercased(), title == "size" || title == "sizes" {
                        if let values = option.values {
                            for value in values {
                                if let safeValue = value.value {
                                    optionsValues.append(safeValue)
                                    print("- setLiveData: \(safeValue)")
                                }
                            }
                        }
                    }
                }
            }
        }
        let uniqueOptions = Array(Set(optionsValues.map { $0 }))
        
        self.filteredOptionsValues = uniqueOptions.map { SizeOption(value: $0, isSelected: false) }

        self.listCategories = self.getUniqueCategories(from: self.listCategories)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedApplyBtn(_ sender: UIButton) {
        
        let selectedCategories = listCategories.filter { $0.isSelected ?? false }
           print("Selected Categories:")
           for category in selectedCategories {
               print("- \(category.name ?? "Unnamed")")
               self.strCatID = category.id ?? ""
           }

           let selectedSizes = filteredOptionsValues.filter { $0.isSelected }
           print("Selected Sizes:")
           for size in selectedSizes {
               print("- \(size.value)")
               self.strOptionName = size.value
           }
        
        if self.delegate != nil{
            self.delegate?.didClickedApplyBtn(strCatId: self.strCatID ?? "", strOptionName: self.strOptionName ?? "")
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func clickedResetBtn(_ sender: UIButton) {
        if self.delegate != nil
        {
            self.delegate?.didClickedResetBtn()
            self.dismiss(animated: true)
        }
    }
    
    func getUniqueCategories(from categories: [StoreProductCategories]) -> [StoreProductCategories] {
        var seen = Set<String>()
        var uniqueCategories: [StoreProductCategories] = []

        for category in categories {
            if let id = category.id, !seen.contains(id) {
                seen.insert(id)
                uniqueCategories.append(category)
            }
        }

        return uniqueCategories
    }
}


