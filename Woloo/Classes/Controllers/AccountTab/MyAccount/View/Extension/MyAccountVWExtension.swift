//
//  MyAccountVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 08/10/24.
//

import Foundation

extension MyAccountVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return coinHistoryV2.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountCell", for: indexPath) as? MyAccountCell ?? MyAccountCell()

            cell.lblWolooPoints.text = "\(self.objUserCoinModel.totalCoins ?? 0)"

            cell.lblGiftPoints.text = "\(self.objUserCoinModel.totalGiftCoins ?? 0)"
          cell.btnShop.addTarget(self, action: #selector(openShopTab(sender:)), for: .touchUpInside)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistroyCell", for: indexPath) as! HistroyCell
            cell.delegate = self
            cell.configureUI()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryDataCell", for: indexPath) as? HistoryDataCell ?? HistoryDataCell()
//            guard let histData = coinHistory[indexPath.row] else { return cell }
            guard let histDataV2 = coinHistoryV2[indexPath.row] else {return cell}
            
            if histDataV2.is_gift == 1 {
                cell.lblPoints.text = " \(histDataV2.value ?? "")"//\u{20B9}
                cell.lblPointsStatic.text = "INR"
            } else {
                cell.lblPoints.text = histDataV2.value
                cell.lblPointsStatic.text = "Points"
            }

            cell.fillDataforDescriptionV2(histDataV2)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss"
            let date = dateFormatter.date(from: histDataV2.created_at ?? "") ?? Date()
            dateFormatter.dateFormat = "dd MMMM"
            cell.lblDate.text =  dateFormatter.string(from: date)
            dateFormatter.dateFormat = "MMMM yyyy"
            cell.lblHeaderDate.text =  dateFormatter.string(from: date)
            if indexPath.row == 0 {
                cell.headerHeight.constant = 40
            } else {
                //let histDataOld = coinHistory[indexPath.row - 1]
                let histDataOldV2 = coinHistoryV2[indexPath.row - 1]
                
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss"
                let cdate = dateFormatter.date(from: histDataOldV2?.created_at ?? "") ?? Date()
                dateFormatter.dateFormat = "MMMM yyyy"
                let monthName = dateFormatter.string(from: cdate)
                if monthName == cell.lblHeaderDate.text {
                    cell.headerHeight.constant = 5
                } else {
                    cell.headerHeight.constant = 40
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let histDataV2 = coinHistoryV2[indexPath.row]
        if coinHistoryV2[indexPath.row]?.is_gift == 1 && ((coinHistoryV2[indexPath.row]?.sender) != nil) && histDataV2?.type != "Add Coins" {
            Global.addFirebaseEvent(eventName: "point_detail_click", param: ["points_id":coinHistoryV2[indexPath.row]?.id ?? "0"])
            
            Global.addNetcoreEvent(eventname: self.netcoreEvents.pointDetailClick, param: ["points_id":coinHistoryV2[indexPath.row]?.id ?? "0"])
//
//            let vc = UIStoryboard.init(name: "MyAccount", bundle: Bundle.main).instantiateViewController(withIdentifier: "GiftCardDetailVC") as? GiftCardDetailVC
//            vc?.coinHistory = coinHistory[indexPath.row] ?? HistoryModel()
//            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
  
    @objc func openShopTab(sender: UIButton) {
    
        Global.addNetcoreEvent(eventname: self.netcoreEvents.shopClick, param: [:])
//        Global.addFirebaseEvent(eventName: "shop_click", param: [:])
//        let shopeSB = UIStoryboard(name: "Shop", bundle: nil)
//        let shopeVC = shopeSB.instantiateViewController(withIdentifier: "ShopVC")
//        navigationController?.pushViewController(shopeVC, animated: true)
//
        let shopeSB = UIStoryboard(name: "Shop", bundle: nil)
        if let shopeVC = shopeSB.instantiateViewController(withIdentifier: "ECommerceDashboardViewController") as? ECommerceDashboardViewController {
            self.navigationController?.pushViewController(shopeVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if coinHistoryModel.totalCount ?? 0 > coinHistory.count {
                //getCoinHistory(param: ["pageNumber": pageNumber])
                
                getCoinHistoryV2(param: ["pageIndex": pageNumber])
            }
        }
    }
    
}
