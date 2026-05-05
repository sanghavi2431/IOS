//
//  WolooDashBoardVC.swift
//  Woloo
//
//  Created by Sidhdharth Joshi on 29/07/21.
//

import UIKit

class WolooDashBoardVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private enum DashBoardSection: Int, CaseIterable {
        case profile
        case locationDetail
        case banners
        case trendingBlog
        case list
    }
    
    private var dashBoardSections = DashBoardSection.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        intialSetUp()
    }
    
    /// UI inital set up.
    private func intialSetUp() {
        setupTableView()
    }
}


// MARK: - UITableViewDelegate / UITableViewDataSource
extension WolooDashBoardVC: UITableViewDelegate, UITableViewDataSource {
   
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let registerCells = [Cell.dashBoardProfileCell, Cell.dashBoardLocationCell, Cell.bannerListCell, Cell.trendingListCell, Cell.blogDetailCell]
        registerCells.forEach { (identifier) in
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dashBoardSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberForROW(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch dashBoardSections[indexPath.section] {
        case .profile:
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.dashBoardProfileCell, for: indexPath) as? DashBoardProfileCell ?? DashBoardProfileCell()
        case .locationDetail:
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.dashBoardLocationCell, for: indexPath) as? DashBoardLocationCell ?? DashBoardLocationCell()
        case .banners:
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.bannerListCell, for: indexPath) as? BannerListCell ?? BannerListCell()
        case .trendingBlog:
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.trendingListCell, for: indexPath) as? TrendingListCell ?? TrendingListCell()
        case .list:
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.blogDetailCell, for: indexPath) as? BlogDetailCell ?? BlogDetailCell()
        }
        return cellForIndexPath(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - Tableview Logics Handling
extension WolooDashBoardVC {
    private func numberForROW(_ section: Int) -> Int {
        switch dashBoardSections[section] {
        case .list:
            return 5
        default:
            return 1
        }
    }
    
    private func cellForIndexPath(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        switch dashBoardSections[indexPath.section] {
        case .profile:
            guard let profile = cell as? DashBoardProfileCell else { return UITableViewCell() }
            profile.cartAction = {
                let story = UIStoryboard(name: "Shop", bundle: .main)
                let vc = story.instantiateViewController(withIdentifier: "ECommerceDashboardViewController") as! ECommerceDashboardViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            return profile
        case .locationDetail:
            guard let locationDetail = cell as? DashBoardLocationCell else { return UITableViewCell() }
            return locationDetail
        case .banners:
            guard let banners = cell as? BannerListCell else { return UITableViewCell() }
            return banners
        case .trendingBlog:
            guard let trendingBlog = cell as? TrendingListCell else { return UITableViewCell() }
            return trendingBlog
        case .list:
            guard let list = cell as? BlogDetailCell else { return UITableViewCell() }
            return list
        }
    }
}
