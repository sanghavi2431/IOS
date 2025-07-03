//
//  BookmarkedVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 19/11/24.
//

import Foundation

extension BookmarkedVC: UITableViewDelegate, UITableViewDataSource, DashboardCollectionViewCellDelegate, BookmarkTableCellDelegate{
    
    
    //MARK: - BookmarkTableCellDelegate
    func didClickedNavigate(obj: NearbyResultsModel) {
        let objController = EnrouteViewController.init(nibName: "EnrouteViewController", bundle: nil)
        objController.destLat = Double(obj.lat ?? "")
        objController.destLong = Double(obj.lng ?? "")
        objController.strIsComeFrom = "Navigation"
        objController.strDestination = "\(obj.name ?? "")"
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
   
    //MARK: - UItableview delegate and data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listBookmarkedLoos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: HistoryTableCell? = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell") as! HistoryTableCell?
        
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("HistoryTableCell", owner: self, options: nil)?.last as? HistoryTableCell)
        }
        cell?.delegateBookmark = self
        cell?.configureBookmarkTableCell(objNearBy: self.listBookmarkedLoos[indexPath.row])
        
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
}


