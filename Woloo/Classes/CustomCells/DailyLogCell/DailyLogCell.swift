//
//  DailyLogCell.swift
//  Woloo
//
//  Created on 03/08/21.
//

import UIKit

protocol DailyCellDelegate: class {
    func didselectLogCategory(_ dailyLogSection: Int,_ selectedIndex: Int)
}
class DailyLogCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: DailyCellDelegate?
    var selectedCategory = DailyLogInfo()
    var sectionForDailyLogs: Int? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionSetup()
        //bgView.layer.cornerRadius = 8
    }
    
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension DailyLogCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    private func collectionSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Cell.logDetailCell, bundle: nil), forCellWithReuseIdentifier: Cell.logDetailCell)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fillrowForSection(sectionForDailyLogs ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.logDetailCell, for: indexPath) as? LogDetailCell ?? LogDetailCell()
        fillDailyLogCell(cell, indexPath.item, sectionForDailyLogs ?? 0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.width/3)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didselectLogCategory(sectionForDailyLogs ?? 0, indexPath.item)
    }
}

extension DailyLogCell {
    private func fillDailyLogCell(_ cell: LogDetailCell,_ item: Int,_ section: Int) {
        switch section {
        case 0:
            cell.logTitleLabel.text = PreMenstruation.allCases[item].title
            cell.logImageView.image = PreMenstruation.allCases[item].images
            cell.tickImageView.isHidden = !(selectedCategory.preMenstruation.contains(where: { $0 == PreMenstruation.allCases[item]}))
        case 1:
            cell.logTitleLabel.text = Menstruation.allCases[item].title
            cell.logImageView.image = Menstruation.allCases[item].images
            cell.tickImageView.isHidden = !(selectedCategory.menstruation.contains(where: { $0 == Menstruation.allCases[item]}))
        case 2:
            cell.logTitleLabel.text = DieasesAndMedication.allCases[item].title
            cell.logImageView.image = DieasesAndMedication.allCases[item].images
            cell.tickImageView.isHidden = !(selectedCategory.diseasAndMediaction.contains(where: { $0 == DieasesAndMedication.allCases[item]}))
        case 3:
            cell.logTitleLabel.text = Habits.allCases[item].title
            cell.logImageView.image = Habits.allCases[item].image
            cell.tickImageView.isHidden = !(selectedCategory.habits.contains(where: { $0 == Habits.allCases[item]}))
        case 4:
            cell.logTitleLabel.text = Bleeding.allCases[item].title
            cell.logImageView.image = Bleeding.allCases[item].images
            cell.tickImageView.isHidden = !(selectedCategory.bleedig.contains(where: { $0 == Bleeding.allCases[item]}))
        case 5:
            cell.logTitleLabel.text = Mood.allCases[item].title
            cell.logImageView.image = Mood.allCases[item].images
            cell.tickImageView.isHidden = !(selectedCategory.mood.contains(where: { $0 == Mood.allCases[item]}))
        case 6:
            cell.logTitleLabel.text = SexDrive.allCases[item].title
            cell.logImageView.image = SexDrive.allCases[item].images
            cell.tickImageView.isHidden = !(selectedCategory.sexDrive.contains(where: { $0 == SexDrive.allCases[item]}))
        default:
            break
        }
    }
    
    private func fillrowForSection(_ section: Int) -> Int {
        switch section {
        case 0:
            return PreMenstruation.allCases.count
        case 1:
            return Menstruation.allCases.count
        case 2:
            return DieasesAndMedication.allCases.count
        case 3:
            return Habits.allCases.count
        case 4:
            return Bleeding.allCases.count
        case 5:
            return Mood.allCases.count
        case 6:
            return SexDrive.allCases.count
        default:
            return 0
        }
    }
}
