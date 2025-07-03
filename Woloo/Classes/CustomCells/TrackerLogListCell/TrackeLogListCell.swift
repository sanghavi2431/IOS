//
//  TrackeLogListCell.swift
//  Woloo
//
//  Created on 10/08/21.
//

import UIKit

class TrackeLogListCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var emptyCollectionLabel: UILabel!
    
    var righButtonHandle: (() -> Void)?
    var selectedCategories: DailyLogInfo? {
        didSet {
            if (selectedCategories?.bleedig.count ?? 0) > 0 || (selectedCategories?.mood.count ?? 0) > 0 || (selectedCategories?.preMenstruation.count ?? 0) > 0  || (selectedCategories?.sexDrive.count ?? 0) > 0 || (selectedCategories?.menstruation.count ?? 0) > 0  || (selectedCategories?.diseasAndMediaction.count ?? 0) > 0 || (selectedCategories?.habits.count ?? 0) > 0 {
                self.emptyCollectionLabel.isHidden = true
            } else {
                self.emptyCollectionLabel.isHidden = false
            }
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 8

        collectionSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func plusAction(_ sender: Any) {
        righButtonHandle?()
    }
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension TrackeLogListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    private func collectionSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Cell.trackerLogDetailCell, bundle: nil), forCellWithReuseIdentifier: Cell.trackerLogDetailCell)
        collectionView.reloadData()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedCategories?.preMenstruation.count ?? 0 > 0 && section == 0 {
            return 1
        }
        if selectedCategories?.menstruation.count ?? 0 > 0 && section == 1 {
            return 1
        }
        if selectedCategories?.diseasAndMediaction.count ?? 0 > 0 && section == 2 {
            return 1
        }
        if selectedCategories?.habits.count ?? 0 > 0 && section == 3 {
            return 1
        }
        if selectedCategories?.bleedig.count ?? 0 > 0 && section == 4 {
            return 1
        }
        if selectedCategories?.mood.count ?? 0 > 0 && section == 5 {
            return 1
        }
        if selectedCategories?.sexDrive.count ?? 0 > 0 && section == 6 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.trackerLogDetailCell, for: indexPath) as? TrackerLogDetailCell ?? TrackerLogDetailCell()
        cell.plusImage.isHidden = true
        switch indexPath.section {
        case 0: // Premenstruation
            cell.logTitleLabel.text = "Premensturation"
            cell.logImageView.image = selectedCategories?.preMenstruation.first?.images
            if selectedCategories?.preMenstruation.count ?? 0 > 1 {
                //cell.plusImageLbl.layer.cornerRadius = 13.0
                //cell.plusImage.isHidden = false
                cell.plusImageLbl.text = "+ \(selectedCategories?.preMenstruation.count ?? 0 - 1)"
            }
        case 1: // Menstruation
            cell.logTitleLabel.text = "Menstruation"
            cell.logImageView.image = selectedCategories?.menstruation.first?.images
            if selectedCategories?.menstruation.count ?? 0 > 1 {
               // cell.plusImage.isHidden = false
                cell.plusImageLbl.text = "+ \(selectedCategories?.menstruation.count ?? 0 - 1)"
            }
        case 2: // DiseasAndMediaction
            cell.logTitleLabel.text = "Diseases and Medication"
            cell.logImageView.image = selectedCategories?.diseasAndMediaction.first?.images
            if selectedCategories?.diseasAndMediaction.count ?? 0 > 1 {
                // cell.plusImage.isHidden = false
                cell.plusImageLbl.text = "+ \(selectedCategories?.diseasAndMediaction.count ?? 0 - 1)"
            }
        case 3: // Habits
            cell.logTitleLabel.text = "Habits"
            cell.logImageView.image = selectedCategories?.habits.first?.image
            if selectedCategories?.habits.count ?? 0 > 1 {
               // cell.plusImage.isHidden = false
                cell.plusImageLbl.text = "+ \(selectedCategories?.habits.count ?? 0 - 1)"
            }
        case 4: // Bleeding
            cell.logTitleLabel.text = "Bleeding"//selectedCategories?.bleedig.first?.title
            cell.logImageView.image = selectedCategories?.bleedig.first?.images
            if selectedCategories?.bleedig.count ?? 0 > 1 {
                //cell.plusImage.isHidden = false
                cell.plusImageLbl.text = "+ \(selectedCategories?.bleedig.count ?? 0 - 1)"
            }
        case 5: // Mood
            cell.logTitleLabel.text = "Mood"//selectedCategories?.mood.first?.title
            cell.logImageView.image = selectedCategories?.mood.first?.images
            if selectedCategories?.mood.count ?? 0 > 1 {
                //cell.plusImage.isHidden = false
                cell.plusImageLbl.text = "+ \(selectedCategories?.mood.count ?? 0 - 1)"
            }
        case 6: // Sex Drive
            cell.logTitleLabel.text = "Sex"//selectedCategories?.sexDrive.first?.title
            cell.logImageView.image = selectedCategories?.sexDrive.first?.images
            if selectedCategories?.sexDrive.count ?? 0 > 1 {
               // cell.plusImage.isHidden = false
                cell.plusImageLbl.text = "+ \(selectedCategories?.sexDrive.count ?? 0 - 1)"
            }
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90,height: 116)
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
