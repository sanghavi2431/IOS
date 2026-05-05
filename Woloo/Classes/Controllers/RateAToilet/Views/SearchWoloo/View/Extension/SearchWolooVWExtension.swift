//
//  SearchWolooVWExtension.swift
//  Woloo
//
//  Created by CEPL on 07/06/25.
//

import Foundation
import UIKit

extension SearchWolooViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, SearchWolooViewModelProtocol{
    
    //MARK: - SearchWolooViewModelProtocol
    func didRecieveSearchWolooResponse(listWrapper: BaseResponse<SearchListWrapper>) {
        Global.hideIndicator()
        isLoading = false
        
        let results = listWrapper.results
        let newData = results.data ?? [SearchWoloo]()
        
        if currentPage == 1 {
            // First page - replace data
            self.listSearchWoloo = newData
        } else {
            // Subsequent pages - append data
            self.listSearchWoloo.append(contentsOf: newData)
        }
        
        // Check if more data exists
        if let totalPages = results.totalPages, let page = results.page {
            isMoreDataExist = page < totalPages
        } else {
            isMoreDataExist = newData.count > 0
        }
        
        self.tableView.reloadData()
    }
    
    func didRecieveSearchWolooError(strError: String) {
        Global.hideIndicator()
        isLoading = false
        // Revert page increment on error
        if currentPage > 1 {
            currentPage -= 1
        }
    }
    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.listSearchWoloo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: searchWolooTableCell? = tableView.dequeueReusableCell(withIdentifier: "searchWolooTableCell") as! searchWolooTableCell?
        if cell == nil{
            cell = (Bundle.main.loadNibNamed("searchWolooTableCell", owner: self, options: nil)?.last as? searchWolooTableCell)
        }
       
        cell?.configureSearchWolooTableCell(objSearchWoloo: self.listSearchWoloo[indexPath.row])
        
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil{
            self.delegate?.didSelectSearchedWoloos(objSearchWoloo: self.listSearchWoloo[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - UITableViewDataSourcePrefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // Check if we need to load more data
        if indexPaths.contains(where: isLoadingCell) && isMoreDataExist && !isLoading {
            loadMoreData()
        }
    }
    
    /// Check if the index path is near the end of the list
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= listSearchWoloo.count - 3
    }
}
