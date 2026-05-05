import UIKit



class PeriodCalenderCell: UITableViewCell {

    @IBOutlet weak var circularView: PeriodCalendarView!
    @IBOutlet weak var lastPeriodDateLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var infoHandler: (() -> Void)?
    var infoHandlerEdit: (() -> Void)?
    var buttonHandler: (() -> Void)?
    var allMonthtrackerInfoV2: [ViewPeriodTrackerModel]?
  

    var menstrationList: [Int] = []
    var ovalutionList: [Int] = []
    var pregnancyList: [Int] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setupActionButton()
    }
    
    private func setupActionButton() {
        // Configure button to have image on the left
        self.actionButton.layer.cornerRadius = 5.0
        
        // Ensure button can receive touches
        self.actionButton.isUserInteractionEnabled = true
        self.actionButton.isEnabled = true
        
        actionButton.contentHorizontalAlignment = .left
        actionButton.imageView?.contentMode = .scaleAspectFit
        actionButton.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14)
        actionButton.setTitleColor(UIColor(white: 0.333, alpha: 1.0), for: .normal)
        actionButton.titleLabel?.numberOfLines = 1
        actionButton.titleLabel?.adjustsFontSizeToFitWidth = false
        actionButton.titleLabel?.lineBreakMode = .byTruncatingTail
        
        // Set edit icon image (24x24 px) - prioritize icon_edit_profile
        if let editProfileImage = UIImage(named: "icon_edit_profile") {
            // Resize to 24x24 px
            let resizedImage = editProfileImage.resizeImage(targetSize: CGSize(width: 24, height: 24))
            actionButton.setImage(resizedImage, for: .normal)
        } else if let editImage = UIImage(named: "edit") {
            // Fallback to "edit" image
            let resizedImage = editImage.resizeImage(targetSize: CGSize(width: 24, height: 24))
            actionButton.setImage(resizedImage, for: .normal)
        } else if #available(iOS 13.0, *), let systemEditImage = UIImage(systemName: "pencil") {
            // Fallback to SF Symbol pencil icon
            let resizedImage = systemEditImage.resizeImage(targetSize: CGSize(width: 24, height: 24))
            actionButton.setImage(resizedImage, for: .normal)
        } else if #available(iOS 13.0, *) {
            // Final fallback: Create a simple edit icon using SF Symbols
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
            if let editIcon = UIImage(systemName: "pencil", withConfiguration: config) {
                actionButton.setImage(editIcon, for: .normal)
            }
        }
        
        // Set content edge insets for overall padding: 12pt leading, 12pt trailing
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        // Set image edge insets: right creates space AFTER icon (between icon and text)
        actionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12) // 12pt space between icon and text
        
        // Set title edge insets: left pushes text away from icon, right adds trailing space
        actionButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // Force layout update to prevent text truncation
        actionButton.setNeedsLayout()
        actionButton.layoutIfNeeded()
    }

 func setDaysV2(objViewPeriodTracker: ViewPeriodTrackerModel?) {
        guard let trackerInfo = objViewPeriodTracker,
              let originalPeriodDate = trackerInfo.periodDate?.toDate(),
              let cycleLength = trackerInfo.cycleLength else { return }

        let calendar = Calendar.current
        let currentDate = Date()
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)

        menstrationList.removeAll()
     ovalutionList.removeAll()
        pregnancyList.removeAll()

        // 🔹 Compute previous, current, and next cycle start dates
        var prevPeriodStart = originalPeriodDate
        while let nextPrev = calendar.date(byAdding: .day, value: cycleLength, to: prevPeriodStart),
              nextPrev < currentDate {
            prevPeriodStart = nextPrev
        }

        let currentCycleStart = prevPeriodStart
        let nextCycleStart = calendar.date(byAdding: .day, value: cycleLength, to: currentCycleStart)!

     // 🔹 Calculate current day in the cycle
        let currentDayInCycle = calendar.dateComponents([.day], from: currentCycleStart, to: currentDate).day ?? 0
        let cycleDay = currentDayInCycle + 1 // Start day counts as day 1
     circularView.periodDay = cycleDay
        print("Current day in the cycle: \(cycleDay)")
     
     
        let periodLength = trackerInfo.periodLength ?? 4
        let lutealLength = trackerInfo.lutealLength ?? 14

        // 🔹 Function to add menstruation days for a given start date
        func addMenstruationDays(from startDate: Date) {
            let periodEnd = calendar.date(byAdding: .day, value: periodLength - 1, to: startDate)!
            let days = datesRange(from: startDate, to: periodEnd)
                .filter { calendar.component(.month, from: $0) == currentMonth && calendar.component(.year, from: $0) == currentYear }
                .map { calendar.component(.day, from: $0) }
            menstrationList.append(contentsOf: days)
        }

        // Add previous, current, and next cycle menstruation if they fall in current month
        addMenstruationDays(from: calendar.date(byAdding: .day, value: -cycleLength, to: currentCycleStart) ?? currentCycleStart)
        addMenstruationDays(from: currentCycleStart)
        addMenstruationDays(from: nextCycleStart)

        // 🔹 Ovulation = next cycle start - 14
        let ovulationDate = calendar.date(byAdding: .day, value: -14, to: nextCycleStart)!
        if calendar.component(.month, from: ovulationDate) == currentMonth && calendar.component(.year, from: ovulationDate) == currentYear {
            ovalutionList.append(calendar.component(.day, from: ovulationDate))
        }

        // 🔹 Fertile window = ovulation - 6 to ovulation + 4
        let fertileStart = calendar.date(byAdding: .day, value: -6, to: ovulationDate)!
        let fertileEnd = calendar.date(byAdding: .day, value: 4, to: ovulationDate)!
        let fertileDays = datesRange(from: fertileStart, to: fertileEnd)
            .filter { calendar.component(.month, from: $0) == currentMonth && calendar.component(.year, from: $0) == currentYear }
            .map { calendar.component(.day, from: $0) }
        pregnancyList.append(contentsOf: fertileDays)

        // 🔹 Debug prints
        print("Current cycle period start: \(currentCycleStart)")
        print("Menstruation: \(menstrationList.sorted())")
        print("Ovulation: \(ovalutionList)")
        print("Fertile window: \(pregnancyList.sorted())")
        print("Next period expected on: \(nextCycleStart)")

        // 🔹 Update circular view
        let currentDay = calendar.component(.day, from: currentDate)
        let currentYearComp = calendar.component(.year, from: currentDate)

        circularView.setCalendar(day: currentDay, month: currentMonth, year: currentYearComp)
        circularView.setPeriodCycle(menstruation: menstrationList, ovulation: ovalutionList, pregnancy: pregnancyList)

     
        // 🔹 Determine period type for today
        var periodType = PeriodType.Period
        if menstrationList.contains(currentDay) {
            periodType = PeriodType.Menstruation
        } else if ovalutionList.contains(currentDay) {
            periodType = PeriodType.Ovulation
        } else if pregnancyList.contains(currentDay) {
            periodType = PeriodType.Pregnancy
        }
        circularView.setPeroidType(periodItem: periodType)

        // 🔹 Update label with last and next period
        let lastPeriod = currentCycleStart.convertDateToString("yyyy-MM-dd")
        let nextPeriod = nextCycleStart.convertDateToString("yyyy-MM-dd")
        switch periodType.title {
        case "Menstruation":
            lastPeriodDateLabel.text = "You are currently in Menstruation phase, your last period cycle ended on \(lastPeriod) and next period cycle will start on \(nextPeriod)."
        case "Ovulation":
            lastPeriodDateLabel.text = "Currently in Ovulation phase. Your last period cycle ended on \(lastPeriod) and next period cycle will start on \(nextPeriod)."
        case "Pregnancy":
            lastPeriodDateLabel.text = "Currently in Pregnancy phase. Your last period cycle ended on \(lastPeriod) and next period cycle will start on \(nextPeriod)."
        default:
            lastPeriodDateLabel.text = "You are currently in the Normal phase. Your last period cycle ended on \(lastPeriod) and next period cycle will start on \(nextPeriod)."
        }
    }




    // MARK: - Calculate cycle dates
    private func makeCycleDatesListV2(info: ViewPeriodTrackerModel) -> (menstruation: [Date], ovulation: [Date], pregnancyCount: [Date]) {
        guard let periodStartDate = info.periodDate?.toDate() else { return ([], [], []) }
        let calendar = Calendar.current

        let cycleLength = info.cycleLength ?? 28
        let periodLength = info.periodLength ?? 4
        let lutealLength = info.lutealLength ?? 14

        // 1️⃣ Menstruation: from periodStartDate to periodStartDate + periodLength - 1
        let periodEndDate = calendar.date(byAdding: .day, value: periodLength - 1, to: periodStartDate)!
        let menstruationDates = datesRange(from: periodStartDate, to: periodEndDate)

        // 2️⃣ Ovulation: periodStartDate + (cycleLength - lutealLength)
        let ovulationDate = calendar.date(byAdding: .day, value: cycleLength - lutealLength, to: periodStartDate)!
        let ovulationDates = [ovulationDate]

        // 3️⃣ Fertile window: immediately after menstruation ends until the day before ovulation
        let fertileStart = calendar.date(byAdding: .day, value: periodLength, to: periodStartDate)!
        let fertileEnd = calendar.date(byAdding: .day, value: -1, to: ovulationDate)!
        let fertileDates = datesRange(from: fertileStart, to: fertileEnd)

        return (menstruationDates, ovulationDates, fertileDates)
    }


    private func datesRange(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var current = startDate
        let calendar = Calendar.current
        while current <= endDate {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }
        return dates
    }

    @IBAction func didTapInfoButton(_ sender: Any) {
        infoHandler?()
    }
    
    
    @IBAction func didTapActionButton(_ sender: Any) {
        infoHandlerEdit?()
    }
}
