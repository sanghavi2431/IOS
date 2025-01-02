//
//  CustomCalenderCell.swift
//  Woloo
//
//  Created on 26/07/21.
//

import UIKit
import FSCalendar

/// For show left,right and both line in calender cell.
enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}


class CustomCalenderCell: FSCalendarCell {
    static let identifier = "CustomCalenderCell"
    let selectionView = UIView()
    let yellowImage = UIImageView()
    var currentDate: Date? {
        didSet {
            addBackImageView()
        }
    }
    var cycleLinesColor: PeriodItem = PeriodType.Ovulation {
        didSet {
            setNeedsLayout()
        }
    }
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        selectionView.layer.cornerRadius = 3
        let view = UIView(frame: CGRect(origin: self.bounds.origin, size: CGSize(width: 52, height: 52)))
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        self.backgroundView = view;
        yellowImage.frame = backgroundView?.bounds ?? .zero
        backgroundView?.addSubview(yellowImage)
        backgroundView?.bringSubviewToFront(yellowImage)
        self.backgroundView?.addSubview(selectionView)
        self.backgroundView?.bringSubviewToFront(selectionView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.clipsToBounds = true
        selectionView.backgroundColor = selectionType == .none ? .clear : UIColor(hexString: cycleLinesColor.color)
        if selectionType == .middle {
            selectionView.layer.cornerRadius = 0
            selectionView.frame = CGRect(x: 0, y: self.eventIndicator.center.y-3, width: self.contentView.bounds.width, height: 6)
        }
        else if selectionType == .leftBorder {
            selectionView.layer.cornerRadius = 3
            selectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            selectionView.frame = CGRect(x: self.eventIndicator.center.x, y: self.eventIndicator.center.y-3, width: self.contentView.bounds.width/2, height: 6)
        }
        else if selectionType == .rightBorder {
            selectionView.layer.cornerRadius = 3
            selectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            selectionView.frame = CGRect(x: self.eventIndicator.center.x - self.contentView.bounds.width/2, y: self.eventIndicator.center.y-3, width: self.contentView.bounds.width/2, height: 6)
        }
        self.eventIndicator.isHidden = selectionType == .none ? true : false
    }
    
    private func addBackImageView() {
        if let date = currentDate, date.hasSame(.day, as: Date()) && date.hasSame(.month, as: Date()) && date.hasSame(.year, as: Date()) {
            yellowImage.isHidden = false
            yellowImage.image =  #imageLiteral(resourceName: "yellowSquare")
        } else {
            yellowImage.isHidden = true
            backgroundView?.backgroundColor = .clear
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
            self.backgroundView?.backgroundColor = .clear
        }
    }
}
