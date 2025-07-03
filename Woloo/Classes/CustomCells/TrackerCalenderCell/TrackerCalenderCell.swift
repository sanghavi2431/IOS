//
//  TrackerCalenderCell.swift
//  Woloo
//
//  Created on 26/07/21.
//

import UIKit
import FSCalendar

class TrackerCalenderCell: UITableViewCell {
    
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var calenderHeightConstraint: NSLayoutConstraint!
   // @IBOutlet weak var buttonBgImageView: UIImageView!
    @IBOutlet weak var lowerViewHeightConstraint130: NSLayoutConstraint!
    //@IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var vwBack: UIView!
    
    static let identifier = "TrackerCalenderCell"
    
   // var calenderDateButtonClicker:(() -> Void)?
    var toogleButton: (() -> Void)?
    var monthChange: (() -> Void)?
    var allMonthtrackerInfo: [UserTrackerInfo]? {
        didSet {
            fillListOfCycles()
        }
    }
    
    
    var allMonthtrackerInfoV2: [ViewPeriodTrackerModel]? {
        didSet {
            fillListOfCyclesv2()
        }
    }
    var menstrationList: [Date] = []// [ClosedRange<Int>] = [0...0]
    var ovalutionList: [Date] = [] // [ClosedRange<Int>] = [0...0]
    var pregnancyList: [Date] = [] // [ClosedRange<Int>] = [0...0]
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellConfigure()
    }
    
    
    /// Peform UI Operations.
    private func cellConfigure() {
       // dateButton.setTitle(Date().convertDateToString("dd, MMM yyyy"), for: .normal)
       // buttonBgImageView.layer.cornerRadius = 8
        //dateButton.layer.applySketchShadow()
        calenderView.dataSource = self
        calenderView.delegate = self
        calenderView.pagingEnabled = true
        //calenderView.headerHeight = 10
        calenderView.weekdayHeight = 10
        calenderView.appearance.eventDefaultColor = UIColor.black
        calenderView.appearance.eventSelectionColor = UIColor.black
        calenderView.appearance.todayColor = .clear
       // calenderView.today = Date() // Hide the today circle
        calenderView.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calenderView.register(CustomCalenderCell.self, forCellReuseIdentifier: "cell")
        calenderView.allowsSelection = false
        self.vwBack.layer.borderWidth = 1
        self.vwBack.layer.borderColor = UIColor.lightGray.cgColor
        self.vwBack.layer.cornerRadius = 44.0
        
//        toogleButton = { [weak self] in
//            guard let weak = self else { return }
//            weak.calenderView.scope = weak.calenderView.scope == .week ? .month : .week
//            
//        }
        calenderView.setScope(.month, animated: true)
    }
    
//    @IBAction func calendeDateButtonAction(_ sender: Any) {
//        calenderDateButtonClicker?()
//    }
    
    
}

// MARK: - FSCalendarDelegate/ FSCalendarDataSource
extension TrackerCalenderCell: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
//        self.configure(cell: cell, for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if (allMonthtrackerInfo?.count ?? 0) == 0 {
            return 0
        }
        if menstrationList.contains(date) {
            return 1
        } else if ovalutionList.contains(date) {
            return 1
        } else if pregnancyList.contains(date) {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calenderView.frame.size.height = bounds.height
        self.calenderHeightConstraint.constant = bounds.height
        self.lowerViewHeightConstraint130.constant = self.lowerViewHeightConstraint130.constant == 130 ? 0 : 130
        calendar.reloadData()
        monthChange?()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.formatter.string(from: date))")
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.formatter.string(from: date))")
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if (allMonthtrackerInfo?.count ?? 0) == 0 {
            return [.clear]
        }
        if menstrationList.contains(date) {
            return [appearance.eventDefaultColor]
        } else if ovalutionList.contains(date) {
            return [appearance.eventDefaultColor]
        } else if pregnancyList.contains(date) {
            return [appearance.eventDefaultColor]
        }
        return [.clear]
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        monthChange?()
        self.configureVisibleCells()
    }
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return Date()
//    }
//    func maximumDate(for calendar: FSCalendar) -> Date {
//        return Calendar.current.date(byAdding: .month, value: 2, to: Date()) ?? Date()
//    }
    // MARK: - Private functions
    
    private func configureVisibleCells() {
        calenderView.visibleCells().forEach { [weak self] (cell) in
            guard let weak = self else { return }
            let date = calenderView.date(for: cell)
            let position = calenderView.monthPosition(for: cell)
            weak.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! CustomCalenderCell)
        diyCell.titleLabel.textColor = .black
        diyCell.backgroundView?.layer.cornerRadius = 3
        diyCell.backgroundView?.backgroundColor = .clear
        diyCell.currentDate = date
        // Configure selection layer
//        if position == .current {
           
            var selectionType = SelectionType.none
            print(date.convertDateToString())
            if menstrationList.contains(where: {$0 == date}) {
                /*if menstrationList'.count == 1 {
                    selectionType = .middle
                } else if menstrationList.first == date { // For first date
                    selectionType = .leftBorder
                }  else if menstrationList.last == date { // for last date
                    selectionType = .rightBorder
                } else if menstrationList.contains(where: {$0 == date}) { // Middle dates
                    selectionType = .middle
                }*/
                selectionType = .middle
                diyCell.cycleLinesColor = PeriodType.Menstruation
            }
            
            if pregnancyList.contains(where: {$0 == date}) {
               /* if pregnancyList.count == 1 {
                    selectionType = .middle
                } else if pregnancyList.first == date { // For first date
                    selectionType = .leftBorder
                }  else if pregnancyList.last == date { // for last date
                    selectionType = .rightBorder
                } else if pregnancyList.contains(where: {$0 == date}) { // Middle dates
                    selectionType = .middle
                }*/
                selectionType = .middle
                diyCell.cycleLinesColor = PeriodType.Pregnancy
            }
            
            if ovalutionList.contains(where: {$0 == date}) {
                /*if ovalutionList.count == 1 {
                    selectionType = .middle
                } else if ovalutionList.first == date { // For first date
                    selectionType = .leftBorder
                }  else if ovalutionList.last == date { // for last date
                    selectionType = .rightBorder
                } else if ovalutionList.contains(where: {$0 == date}) { // Middle dates
                    selectionType = .middle
                }*/
                selectionType = .middle
                diyCell.cycleLinesColor = PeriodType.Ovulation
            }
            
            diyCell.selectionType = selectionType
//        } else {
//            diyCell.selectionType = .none
//        }
    }
    
}

// MARK: - Business Logics
extension TrackerCalenderCell {

    
    private func fillListOfCyclesv2() {
        menstrationList.removeAll()
        ovalutionList.removeAll()
        pregnancyList.removeAll()
        allMonthtrackerInfoV2?.forEach({ (info) in
            let getCyclesRange = makeCycleDatesLisV2t(info: info)
            menstrationList.append(contentsOf: getCyclesRange.menstruation)
            ovalutionList.append(contentsOf: getCyclesRange.ovulation)
            pregnancyList.append(contentsOf: getCyclesRange.pregnancyCount)
        })
        
        print("get Cycles length: \(menstrationList)")
        
        print("Tracker Calendar Cell")
        print("FsCalendar List")
        print("Menustration Lit:\(menstrationList)")
        print("ovalutionList Lit:\(ovalutionList)")
        print("pregnancyList Lit:\(pregnancyList)")
        calenderView.reloadData()
    }
    
    private func fillListOfCycles() {
        menstrationList.removeAll()
        ovalutionList.removeAll()
        pregnancyList.removeAll()
        allMonthtrackerInfo?.forEach({ (info) in
            let getCyclesRange = makeCycleDatesList(info: info)
            menstrationList.append(contentsOf: getCyclesRange.menstruation)
            ovalutionList.append(contentsOf: getCyclesRange.ovulation)
            pregnancyList.append(contentsOf: getCyclesRange.pregnancyCount)
        })
        
        print("get Cycles length: \(menstrationList)")
        
        print("Tracker Calendar Cell")
        print("FsCalendar List")
        print("Menustration Lit:\(menstrationList)")
        print("ovalutionList Lit:\(ovalutionList)")
        print("pregnancyList Lit:\(pregnancyList)")
        calenderView.reloadData()
    }
   
    private func makeCycleDatesList(info: UserTrackerInfo) -> (menstruation: [Date], ovulation: [Date], pregnancyCount: [Date]) {
        guard let periodStartDate = info.periodDate?.toDate() else {
            return (menstruation: [], ovulation: [], pregnancyCount: [])
        }

        print("Period start date: ", periodStartDate)
        print("Period length: ", info.periodLength ?? 0)
        print("Cycle length: ", info.cycleLength ?? 0)

        // Calculate the next period start date based on cycle length
        let nextPeriodStartDate = Calendar.current.date(byAdding: .day, value: info.cycleLength ?? 28, to: periodStartDate) ?? Date()
        print("Next period start date: ", nextPeriodStartDate)

        // Calculate period end date based on period length
        let periodEndDate = Calendar.current.date(byAdding: .day, value: (info.periodLength ?? 4) - 1, to: periodStartDate) ?? Date()
        print("Period end date: ", periodEndDate)

        // Calculate ovulation end date as 14 days before the next period start date
        let ovulationEndDate = Calendar.current.date(byAdding: .day, value: -14, to: nextPeriodStartDate) ?? Date()
        print("Ovulation end date: ", ovulationEndDate)

        // Calculate ovulation start date as 5 days before the ovulation end date
        let ovulationStartDate = Calendar.current.date(byAdding: .day, value: -4, to: ovulationEndDate) ?? Date()
        print("Ovulation start date: ", ovulationStartDate)

        // Calculate low fertility period
        let lowFertilityStartDate = Calendar.current.date(byAdding: .day, value: -4, to: ovulationStartDate) ?? Date()
        let lowFertilityEndDate = Calendar.current.date(byAdding: .day, value: 4, to: ovulationEndDate) ?? Date()
        print("Low fertility start date: ", lowFertilityStartDate)
        print("Low fertility end date: ", lowFertilityEndDate)

        let menstruation = datesRange(from: periodStartDate, to: periodEndDate)
        let ovulationCount = datesRange(from: ovulationEndDate, to: ovulationEndDate)
        let pregnancyCount = datesRange(from: lowFertilityStartDate, to: lowFertilityEndDate)

        // Schedule notifications
        schedulePeriodReminders(for: periodStartDate)

        return (menstruation: menstruation, ovulation: ovulationCount, pregnancyCount: pregnancyCount)
    }
    
    private func makeCycleDatesLisV2t(info: ViewPeriodTrackerModel) -> (menstruation: [Date], ovulation: [Date], pregnancyCount: [Date]) {
        guard let periodStartDate = info.periodDate?.toDate() else {
            return (menstruation: [], ovulation: [], pregnancyCount: [])
        }

        print("Period start date: ", periodStartDate)
        print("Period length: ", info.periodLength ?? 0)
        print("Cycle length: ", info.cycleLength ?? 0)

        // Calculate the next period start date based on cycle length
        let nextPeriodStartDate = Calendar.current.date(byAdding: .day, value: info.cycleLength ?? 28, to: periodStartDate) ?? Date()
        print("Next period start date: ", nextPeriodStartDate)

        // Calculate period end date based on period length
        let periodEndDate = Calendar.current.date(byAdding: .day, value: (info.periodLength ?? 4) - 1, to: periodStartDate) ?? Date()
        print("Period end date: ", periodEndDate)

        // Calculate ovulation end date as 14 days before the next period start date
        let ovulationEndDate = Calendar.current.date(byAdding: .day, value: -14, to: nextPeriodStartDate) ?? Date()
        print("Ovulation end date: ", ovulationEndDate)

        // Calculate ovulation start date as 5 days before the ovulation end date
        let ovulationStartDate = Calendar.current.date(byAdding: .day, value: -4, to: ovulationEndDate) ?? Date()
        print("Ovulation start date: ", ovulationStartDate)

        // Calculate low fertility period
        let lowFertilityStartDate = Calendar.current.date(byAdding: .day, value: -4, to: ovulationStartDate) ?? Date()
        let lowFertilityEndDate = Calendar.current.date(byAdding: .day, value: 4, to: ovulationEndDate) ?? Date()
        print("Low fertility start date: ", lowFertilityStartDate)
        print("Low fertility end date: ", lowFertilityEndDate)

        let menstruation = datesRange(from: periodStartDate, to: periodEndDate)
        let ovulationCount = datesRange(from: ovulationEndDate, to: ovulationEndDate)
        let pregnancyCount = datesRange(from: lowFertilityStartDate, to: lowFertilityEndDate)

        // Schedule notifications
        schedulePeriodReminders(for: periodStartDate)

        return (menstruation: menstruation, ovulation: ovulationCount, pregnancyCount: pregnancyCount)
    }
    
    
    private func schedulePeriodReminders(for startDate: Date) {
        let time = DateComponents(hour: 10, minute: 0, second: 0) // 8:00 AM
        let sevenDaySubtractedDate = Calendar.current.date(byAdding: .day, value: -7, to: startDate)
        scheduleNotification(title: "Period Reminder!!", body: "7 days until next period", date: sevenDaySubtractedDate, time: time)
        
        let oneDaySubtractedDate = Calendar.current.date(byAdding: .day, value: -1, to: startDate)
        scheduleNotification(title: "Period Reminder!!", body: "1 days until next period", date: oneDaySubtractedDate, time: time)
    }

    private func scheduleNotification(title: String, body: String, date: Date?, time: DateComponents) {
        guard let fireDate = date else { return }
        
        var triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: fireDate)
            triggerDate.hour = time.hour
            triggerDate.minute = time.minute
            triggerDate.second = time.second
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Period tracker error: \(error)")
                }
            }
    }
    
    func addOrSubtractDay(day:Int)->Date{
      return Calendar.current.date(byAdding: .day, value: day, to: Date())!
    }
    
    func customDateFormatting() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"//"EE" to get short style
        let mydt = dateFormatter.string(from: date).capitalized
        let day = Calendar.current.component(.day, from: date)
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        return "\(mydt)"
    }
    
    func scheduleLocalPNSevenDays(year: Int, month: Int, day: Int) {

            let dateComponents = DateComponents(year: year, month: month, day: day, hour: 09, minute: 00)
            let yourFireDate = Calendar.current.date(from: dateComponents)

            let notification = UILocalNotification()
            notification.fireDate = yourFireDate
            notification.alertBody = "Hey you! Your period is in seven days!"
//            notification.alertAction = "be awesome!"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["CustomField1": "w00t"]
            UIApplication.shared.scheduleLocalNotification(notification)


        }
    
    func scheduleLocalPNOneDay(year: Int, month: Int, day: Int) {

            let dateComponents = DateComponents(year: year, month: month, day: day, hour: 09, minute: 00)
            let yourFireDate = Calendar.current.date(from: dateComponents)

            let notification = UILocalNotification()
            notification.fireDate = yourFireDate
            notification.alertBody = "Hey you! Your period is in one day!"
//            notification.alertAction = "be awesome!"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["CustomField1": "w000t"]
            UIApplication.shared.scheduleLocalNotification(notification)


        }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
}

extension TrackerCalenderCell: FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, weekdayTextFor index: Int) -> String {
            let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
            return weekdays[index]
        }
}
