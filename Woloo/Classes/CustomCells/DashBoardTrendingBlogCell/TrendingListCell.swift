//
//  TrendingListCell.swift
//  Woloo
//
//  Created on 30/07/21.
//

import UIKit

protocol TrendingListCellDelegate: NSObjectProtocol{
    func didClickedCategory(id: Int?, listCategoryModel: [CategoryModel]?)
}

class TrendingListCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleForSectionLabel: UILabel!
    
    weak var delegate: TrendingListCellDelegate?
    
    var clickHandler: ((_ index: Int) -> Void)?
    var listOfCategory: [CategoryInfo]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var colorArray: [UIColor] = []
    
    var listOfCategoryV2: [CategoryModel]? {
        didSet {
            guard var list = listOfCategoryV2 else { return }

                    let colorSet: [String] = [
                        "#FDEBD2", "#FBDDDD", "#C7E3F9", "#D5FFED", "#FEF9BD",
                        "#FADBD8", "#D2B4DE", "#A9CCE3", "#A3E4D7", "#F9E79F"
                    ]

                    for i in 0..<list.count {
                        list[i].bgColor = colorSet[i % colorSet.count]
                    }

                    self.listOfCategoryV2 = list // trigger reload with updated bgColors
                    collectionView.reloadData()
        }
    }
    
    var selectedCategories = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
}

extension TrendingListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.register(UINib(nibName: CategoryCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
        // Define color set using hex values
        let colorSet: [UIColor] = [
            UIColorFromHex("#FDEBD2"), // Orange-Red
            UIColorFromHex("#FBDDDD"), // Green
            UIColorFromHex("#C7E3F9"), // Blue
            UIColorFromHex("#D5FFED"), // Yellow
            UIColorFromHex("#FEF9BD"),
            UIColorFromHex("#FDEBD2"), // Orange-Red
            UIColorFromHex("#FBDDDD"), // Green
            UIColorFromHex("#C7E3F9"), // Blue
            UIColorFromHex("#D5FFED"), // Yellow
            UIColorFromHex("#FEF9BD"),
            UIColorFromHex("#FDEBD2")// Magenta
        ]
        self.colorArray = colorSet
        self.collectionView.register(CategoryNewCell.nib, forCellWithReuseIdentifier: CategoryNewCell.identifier)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (listOfCategoryV2?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryNewCell.identifier, for: indexPath) as? CategoryNewCell ?? CategoryNewCell()
        fillCategoryCell(cell,indexPath.item)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Clicked categories")
        // Deselect all items
            for i in 0..<(listOfCategoryV2?.count ?? 0) {
                listOfCategoryV2?[i].isSelected = false
            }

            // Select the tapped item
            listOfCategoryV2?[indexPath.item].isSelected = true
        if self.delegate != nil{
            self.delegate?.didClickedCategory(id: self.listOfCategoryV2?[indexPath.item].id ?? 0, listCategoryModel: self.listOfCategoryV2)
        }
        
        //clickHandler?(indexPath.item)
      //  collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
   
    


}


// MARK: - Cell's Handling
extension TrendingListCell {
    /// cell Related all operation do in this method
    /// - Parameters:
    ///   - cell: **CategoryCell**
    ///   - item: Index**IndexPath.item**
    private func fillCategoryCell(_ cell: CategoryNewCell,_ item: Int) {
        cell.topicTitleLabel.textColor = selectedCategories == item ? UIColor.backgroundColor : .gray
//        if item == 0 {
//            cell.topicImageView.image =  selectedCategories == item ?  #imageLiteral(resourceName: "checkMarkSquare") : #imageLiteral(resourceName: "checkMarkSquare").withTintColor(.gray)
//            cell.topicTitleLabel.text = "All"
//            cell.vwBgImg.backgroundColor = self.colorArray[4]
//           // cell.bgImageView.isHidden = true
//            //cell.selectedViewBoarder.isHidden = !(selectedCategories == item)
//            return
//        }
        
        
        
        if let info = listOfCategoryV2?[item] {
            cell.setDataV2(info)
            
        }
       // cell.bgImageView.isHidden = !(selectedCategories == item)
        //cell.selectedViewBoarder.isHidden = !(selectedCategories == item)
    }
}

// Helper function to convert hex color to UIColor
func UIColorFromHex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    if hexSanitized.hasPrefix("#") {
        hexSanitized.removeFirst()
    }
    
    var rgb: UInt64 = 0
    Scanner(string: hexSanitized).scanHexInt64(&rgb)
    
    let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
    let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
    let blue = CGFloat(rgb & 0xFF) / 255.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}
