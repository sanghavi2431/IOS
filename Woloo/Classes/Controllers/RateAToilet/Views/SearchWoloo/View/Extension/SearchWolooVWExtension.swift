//
//  SearchWolooVWExtension.swift
//  Woloo
//
//  Created by CEPL on 07/06/25.
//

import Foundation
import UIKit

extension SearchWolooViewController: UITableViewDelegate, UITableViewDataSource, SearchWolooViewModelProtocol{
    
    //MARK: - SearchWolooViewModelProtocol
    func didRecieveSearchWolooResponse(listWrapper: BaseResponse<SearchListWrapper>) {
        Global.hideIndicator()
        self.listSearchWoloo = listWrapper.results.data ?? [SearchWoloo]()
        self.tableView.reloadData()
    }
    
    func didRecieveSearchWolooError(strError: String) {
        Global.hideIndicator()
    }
    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.listSearchWoloo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SearchTxtFieldCell? = tableView.dequeueReusableCell(withIdentifier: "SearchTxtFieldCell") as! SearchTxtFieldCell?
        if cell == nil{
            cell = (Bundle.main.loadNibNamed("SearchTxtFieldCell", owner: self, options: nil)?.last as? SearchTxtFieldCell)
        }
       
        cell?.configureSearchWoloo(objSearchWoloo: self.listSearchWoloo[indexPath.row])
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil{
            self.delegate?.didSelectSearchedWoloos(objSearchWoloo: self.listSearchWoloo[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
}
