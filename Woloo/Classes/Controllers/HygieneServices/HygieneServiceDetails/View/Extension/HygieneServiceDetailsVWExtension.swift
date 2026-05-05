//
//  HygieneServiceDetailsVWExtension.swift
//  Woloo
//
//  Created by CEPL on 23/07/25.
//

import Foundation

extension HygieneServiceDetailsVC: UITableViewDelegate, UITableViewDataSource, HygieneServiceDetailsViewModelDelegate{
    
    //MARK: HygieneServiceDetailsViewModelDelegate
    func didRecieveProductReviewsAPISuccess(objResponse: ProductReviewWrapper) {
        print("Get reviews success", objResponse.data?.product_id ?? "")
        self.listProductReviews = objResponse.data?.reviews ?? [ProductReview]()
        
        self.tableView.reloadData()
    }
    
    func didRecieveProductReviewsAPIError(strError: String) {
        print("Get reviews error")
    }
    
    
    func didReceievGetProductListAPISuccess(objResponse: ProductListWrapper) {
        self.listProducts = objResponse.products ?? [Products]()
        self.tableView.reloadData()
    }
    
    func didReceievGetProductListAPIError(strError: String) {
        //
    }
    
    
    
    
    
    //MARK: - UITableViewDelegate and UITableViewDataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            
            return 3
            
        }else if section == 1{
            
            return self.objProduct.options?.count ?? 0
            
        }
        else if section == 2{
            
            return 2
            
        }
        else if section == 4{
            
            return self.listProductReviews.count
            
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            if indexPath.row == 0{
                var cell: ProductItemImageCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemImageCell") as? ProductItemImageCell
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductItemImageCell", owner: self, options: nil)?.last as? ProductItemImageCell)
                }
                
                //cell?.delegate = self
                
                // Get selected color name (example)
                let selectedColor = getSelectedColorName()
                cell?.configureProductItemImageCell(objProduct: self.objProduct)
                cell?.selectionStyle = .none
                return cell!
            }
            else  if indexPath.row == 1{//ProductRatingCartCell
                var cell: ProductRatingCartCell? = tableView.dequeueReusableCell(withIdentifier: "ProductRatingCartCell") as! ProductRatingCartCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductRatingCartCell", owner: self, options: nil)?.last as? ProductRatingCartCell)
                }
                
                //cell?.delegate = self
                // cell?.configureProductRatingCartCell(objProducts: self.objProduct, listReview: self.listProductReviews)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else  if indexPath.row == 2{//ProductItemInfoCell
                var cell: ProductItemInfoCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemInfoCell") as! ProductItemInfoCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductItemInfoCell", owner: self, options: nil)?.last as? ProductItemInfoCell)
                }
                //cell?.delegate = self
                cell?.configureProductItemInfoCell(objProduct: self.objProduct)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            
        }// section 0 ends
        else if indexPath.section == 1{
            
            var cell: ProductItemColorCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemColorCell") as! ProductItemColorCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("ProductItemColorCell", owner: self, options: nil)?.last as? ProductItemColorCell)
            }
            
            //cell?.delegate = self
            cell?.configureOptions(objProductOptions: self.objProduct.options?[indexPath.row])
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.section == 2{
            if indexPath.row == 0{
                var cell: ProductItemAddressCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemAddressCell") as! ProductItemAddressCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductItemAddressCell", owner: self, options: nil)?.last as? ProductItemAddressCell)
                }
                
                cell?.configureProductItemAddressCell(objAddress: self.objSelectedAddress)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            //Recent Search Cell
            else  if indexPath.row == 1{
                var cell: ProductItemRecentSearchCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemRecentSearchCell") as! ProductItemRecentSearchCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("ProductItemRecentSearchCell", owner: self, options: nil)?.last as? ProductItemRecentSearchCell)
                }
                
                //cell?.delegate = self
                cell?.configureProductItemRecentSearchCell(listProduct: self.listProducts)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
        }
        if indexPath.section == 3{
            var cell: RatingsAndReviewCell? = tableView.dequeueReusableCell(withIdentifier: "RatingsAndReviewCell") as! RatingsAndReviewCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("RatingsAndReviewCell", owner: self, options: nil)?.last as? RatingsAndReviewCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 4{
            
            var cell: RatingsAndReviewListCell? = tableView.dequeueReusableCell(withIdentifier: "RatingsAndReviewListCell") as! RatingsAndReviewListCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("RatingsAndReviewListCell", owner: self, options: nil)?.last as? RatingsAndReviewListCell)
            }
            
            cell?.configureRatingsAndReviewListCell(objProductReview: self.listProductReviews[indexPath.row])
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 5{
            
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else{
            return UITableViewCell()
        }
    }
    
    func getSelectedColorName() -> String? {
        for opt in self.objProduct.options ?? [] {
            if opt.title?.lowercased() == "color" {
                if let selected = opt.values?.first(where: { $0.isSelected == true }) {
                    return selected.value
                }
            }
        }
        return nil
    }
}
