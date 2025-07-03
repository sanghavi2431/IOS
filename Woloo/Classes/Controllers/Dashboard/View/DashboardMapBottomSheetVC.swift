//
//  DashboardMapBottomSheetVC.swift
//  Woloo
//
//  Created by Kapil Dongre on 25/01/25.
//

import UIKit


protocol DashboardBottomSheetDelegate: NSObjectProtocol{
    
    func didSelectRadius(radius: Int?)
    func didSelectWoloo(objNearbyResultsModel: NearbyResultsModel?)
    func didClickedTakeMeHere(objNearbyResultsModel: NearbyResultsModel?)
    
}

class DashboardMapBottomSheetVC: UIViewController {
    
    
 
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnOpenNow: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnOffer: UIButton!
    
    
    @IBOutlet weak var vwBackOpenNow: ShadowView!
    @IBOutlet weak var vwBackBookMark: ShadowView!
    @IBOutlet weak var vwBackIsOffer: ShadowView!
    
    var allStoresList = [NearbyResultsModel]()
    weak var delegate: DashboardBottomSheetDelegate?
    var lat: Double?
    var lng: Double?
    var cpyAllStoresList = [NearbyResultsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }

    func loadInitialSettings(){
        self.cpyAllStoresList = self.allStoresList
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    //MARK: -  Button action methods
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
    
    
    @IBAction func clicked8Btnkms(_ sender: UIButton) {
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 6)
        }
        self.dismiss(animated: true)
    }
   
    
    
    @IBAction func clickedBtnDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func clickedOpenNow(_ sender: UIButton) {
        
        let filteredList = btnOpenNow.isSelected
               ? cpyAllStoresList.filter { $0.is_open == 0 }
               : cpyAllStoresList.filter { $0.is_open == 1 }

           // Ensure the count is >= 1 before allowing selection
           if filteredList.count >= 1 {
               btnOpenNow.isSelected.toggle() // Toggle selection state
               allStoresList = filteredList // Update the list
           } else {
               btnOpenNow.isSelected = false // Force unselect if no data
           }

           // Update background color based on the button state
           self.vwBackOpenNow.backgroundColor = btnOpenNow.isSelected ? UIColor(hexString: "D7D7D7") : UIColor(hexString: "FFEB00")

           self.tableView.reloadData()
    }
    
  
    @IBAction func clickedBookmarkBtn(_ sender: UIButton) {
        let filteredList = btnBookmark.isSelected
                ? cpyAllStoresList.filter { $0.is_liked == 0 }
                : cpyAllStoresList.filter { $0.is_liked == 1 }

            // Ensure there is at least one result before toggling selection
            if filteredList.count >= 1 {
                btnBookmark.isSelected.toggle() // Toggle selection state
                allStoresList = filteredList // Update the list
            } else {
                btnBookmark.isSelected = false // Prevent selection if no results
            }

            // Update background color based on the button state
            self.vwBackBookMark.backgroundColor = btnBookmark.isSelected ? UIColor(hexString: "D7D7D7") : UIColor(hexString: "FFEB00")

            self.tableView.reloadData()
    }
    
    @IBAction func clickedBtnOffer(_ sender: UIButton) {
        let filteredList = btnOffer.isSelected
                ? cpyAllStoresList
                : cpyAllStoresList.filter { $0.is_offer == 1 }

            // Ensure there is at least one result before toggling selection
            if filteredList.count >= 1 {
                btnOffer.isSelected.toggle() // Toggle selection state
                allStoresList = filteredList // Update the list
            } else {
                btnOffer.isSelected = false // Prevent selection if no results
            }

            // Update background color based on selection
            self.vwBackIsOffer.backgroundColor = btnOffer.isSelected ? UIColor(hexString: "D7D7D7") : UIColor(hexString: "FFEB00")

            self.tableView.reloadData()
    }
    
}

extension DashboardMapBottomSheetVC: UITableViewDelegate, UITableViewDataSource, ShowMoreTableCellDelegate{
    
    
    
    //MARK: - ShowMoreTableCellDelegate
    func didSelectTakeMeHere(objNearbyResultsModel: NearbyResultsModel?) {
        if (self.delegate != nil){
            self.delegate?.didClickedTakeMeHere(objNearbyResultsModel: objNearbyResultsModel)
            self.dismiss(animated: true)
        }
    }
    

    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.allStoresList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ShowMoreTableCell? = tableView.dequeueReusableCell(withIdentifier: "ShowMoreTableCell") as! ShowMoreTableCell?
        
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("ShowMoreTableCell", owner: self, options: nil)?.last as? ShowMoreTableCell)
        }
        cell?.delegate = self
        cell?.configureShowMoreTableCell(objNearbyResultsModel: self.allStoresList[indexPath.row])
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       if (self.delegate != nil){
           self.delegate?.didSelectWoloo(objNearbyResultsModel: allStoresList[indexPath.row])
           self.dismiss(animated: true)
        }
    }
}
