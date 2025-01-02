//
//  PeriodCalenderCell.swift
//  Woloo
//
//  Created on 04/08/21.
//

import UIKit

class PeriodCalenderCell: UITableViewCell {

    @IBOutlet weak var circularView: PeriodCalendarView!
    @IBOutlet weak var lastPeriodDateLabel: UILabel!
    
    var infoHandler: (() -> Void)?
    
    var allMonthtrackerInfo: [UserTrackerInfo]?
    
    var allMonthtrackerInfoV2: [ViewPeriodTrackerModel]?
    
    private var currentMonth:Int = 0
    private var currentYear:Int = 0
    private var currentDay:Int = 0
    var menstrationList: [Int] = [] //[ClosedRange<Int>] = [0...0]
    var ovalutionList: [Int] = [] //[ClosedRange<Int>] = [0...0]
    var pregnancyList: [Int] = [] //[ClosedRange<Int>] = [0...0]
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        circularView.setPeriodCycle(menstruation: 1...5, ovulation: 15...17, pregnancy: 18...31)
//        circularView.setPeriodDays(days: 4)
    }
    
//    func setData(_ info: UserTrackerInfo) {
//        lastPeriodDateLabel.text = info.periodDate ?? ""
//    }
    
//    func setDays() {
//        if let trackerInfo = allMonthtrackerInfo?.first//(where: {$0.periodDate?.toDate().get(.month) == Date().get(.month)})
//        {
//        let periodstartDate = Int(trackerInfo.periodDate?.toDate().convertDateToString("dd") ?? "1") ?? 1
//        currentDay = trackerInfo.periodDate?.toDate().get(.month) == Date().get(.month) ? Date().get(.day) : 0
//        currentMonth = trackerInfo.periodDate?.toDate().get(.month) == Date().get(.month) ? Date().get(.month) : trackerInfo.periodDate?.toDate().get(.month) ?? 0
//        currentYear =  trackerInfo.periodDate?.toDate().get(.year) == Date().get(.year) ? Date().get(.year) : trackerInfo.periodDate?.toDate().get(.year) ?? 0
//        circularView.setCalendar(day: currentDay, month: currentMonth, year: currentYear)
//        fillListOfCycles()
//        circularView.setPeriodCycle(menstruation: menstrationList, ovulation: ovalutionList, pregnancy: pregnancyList)
//        // Calculate the day in with given period startdate
//        let days = Calendar.current.dateComponents([.day], from: allMonthtrackerInfo?.first?.periodDate?.toDate() ?? Date(), to: Date()).day ?? -1
//        if days >= 0 {
//            circularView.setPeriodDays(days: days+1)
//        }
//            // Set inner circle image and color
//            var periodType = PeriodType.Period
//            menstrationList.forEach { (dateRange) in
//                if dateRange == (periodstartDate + (days)){
//                    periodType = PeriodType.Menstruation
//                }
//            }
//            ovalutionList.forEach { (dateRange) in
//                if dateRange == (periodstartDate + (days)) {
//                    periodType = PeriodType.Ovulation
//                }
//            }
//            pregnancyList.forEach { (dateRange) in
//                if dateRange == (periodstartDate + (days)){
//                    periodType = PeriodType.Pregnancy
//                }
//            }
//            circularView.setPeroidType(periodItem: periodType)
//        }
//    }
    func setDays() {
        if let trackerInfo = allMonthtrackerInfo?.first {
            // Call the function and destructure the tuple
            let cycleDates = makeCycleDatesList(info: trackerInfo)
            
            // Use the correct tuple members
            menstrationList = cycleDates.menstruation
            ovalutionList = cycleDates.ovulation
            pregnancyList = cycleDates.pregnancyCount
            
            guard let periodStartDate = trackerInfo.periodDate?.toDate() else {
                return
            }
            
            currentDay = trackerInfo.periodDate?.toDate().get(.month) == Date().get(.month) ? Date().get(.day) : 0
            currentMonth = trackerInfo.periodDate?.toDate().get(.month) == Date().get(.month) ? Date().get(.month) : trackerInfo.periodDate?.toDate().get(.month) ?? 0
            currentYear = trackerInfo.periodDate?.toDate().get(.year) == Date().get(.year) ? Date().get(.year) : trackerInfo.periodDate?.toDate().get(.year) ?? 0
            
            circularView.setCalendar(day: currentDay, month: currentMonth, year: currentYear)
            fillListOfCycles()
            circularView.setPeriodCycle(menstruation: menstrationList, ovulation: ovalutionList, pregnancy: pregnancyList)
            //-----MARK: - ---------
            // Calculate the next period start date
                   let cycleLength = trackerInfo.cycleLength ?? 28
                   let nextPeriodStartDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: periodStartDate)
                   
                   // Calculate days between period start date and today
                   let daysSincePeriodStart = Calendar.current.dateComponents([.day], from: periodStartDate, to: Date()).day ?? -1
                   let daysSinceNextPeriodStart = Calendar.current.dateComponents([.day], from: nextPeriodStartDate ?? Date(), to: Date()).day ?? -1
            
            // Reset and increment period days accordingly
                   if daysSinceNextPeriodStart == 0 {
                       circularView.setPeriodDays(days: 1)
                   } else if daysSinceNextPeriodStart > 0 {
                       circularView.setPeriodDays(days: daysSinceNextPeriodStart + 1)
                   } else if daysSincePeriodStart >= 0 {
                       circularView.setPeriodDays(days: daysSincePeriodStart + 1)
                   }
                   
            //-----MARK: - ---------
//            let days = Calendar.current.dateComponents([.day], from: periodStartDate, to: Date()).day ?? -1
//            if days >= 0 {
//                circularView.setPeriodDays(days: days + 1)
//            }
            
            var periodType = PeriodType.Period
            let currentDate = Date()
            let currentDayOfMonth = Calendar.current.component(.day, from: currentDate)
            
            if menstrationList.contains(currentDayOfMonth) {
                periodType = PeriodType.Menstruation
            } else if ovalutionList.contains(currentDayOfMonth) {
                periodType = PeriodType.Ovulation
            } else if pregnancyList.contains(currentDayOfMonth) {
                periodType = PeriodType.Pregnancy
            }
            
            let value = allMonthtrackerInfo?.first?.periodDate ?? ""
            if periodType.title == "Menstruation"{
                
            let valueSet = "Your last period cycle ended on \(value), You are currently in Menstruation phase."
            self.lastPeriodDateLabel.text = valueSet
            }else if periodType.title == "Ovulation"{
                let valueSet = "Your last period cycle ended on \(value), You are currently in Ovulation phase."
                self.lastPeriodDateLabel.text = valueSet
            }
            else if periodType.title == "Pregnancy"{
                let valueSet = "Your last period cycle ended on \(value), You are currently in Pregnancy phase."
                self.lastPeriodDateLabel.text = valueSet
            }
            else{
                let valueSet = "Your last period cycle ended on \(value), You are currently in Normal phase."
                self.lastPeriodDateLabel.text = valueSet
            }
            
            circularView.setPeroidType(periodItem: periodType)
            // Calculate and display the next period start date
                   if let cycleLength = trackerInfo.cycleLength {
                       let nextPeriodStartDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: periodStartDate)
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateStyle = .medium
                       let nextPeriodStartDateString = dateFormatter.string(from: nextPeriodStartDate ?? Date())
                       
                       let nextPeriodMessage = "Your next period is expected to start on \(nextPeriodStartDateString)."
                       print(nextPeriodMessage)
                   }
        }
    }


    func setDaysV2() {
        if let trackerInfo = allMonthtrackerInfoV2?.first {
            // Call the function and destructure the tuple
            let cycleDates = makeCycleDatesListV2(info: trackerInfo)
            
            menstrationList = cycleDates.menstruation
            ovalutionList = cycleDates.ovulation
            pregnancyList = cycleDates.pregnancyCount
            
            guard let periodStartDate = trackerInfo.periodDate?.toDate() else {
                return
            }
            
            // Get the current date and current day
            let currentDate = Date()
            let currentDay = Calendar.current.component(.day, from: currentDate)
            let currentMonth = Calendar.current.component(.month, from: currentDate)
            let periodDay = Calendar.current.component(.day, from: periodStartDate)
            let periodMonth = Calendar.current.component(.month, from: periodStartDate)
            
            print("Current date: \(currentDate)")
            print("Period start day: \(periodDay)")

            // Case 1: Current date has passed the current period date
            if currentDay > periodDay && currentMonth == periodMonth {
                print("The current month's period date has passed.")
                
                // Print the previous period end date
                let previousPeriodStartDate = Calendar.current.date(byAdding: .day, value: -(trackerInfo.cycleLength ?? 28), to: periodStartDate) ?? periodStartDate
                let previousPeriodEndDate = Calendar.current.date(byAdding: .day, value: (trackerInfo.periodLength ?? 4) - 1, to: previousPeriodStartDate) ?? previousPeriodStartDate
                print("Previous period ended on: \(previousPeriodEndDate)")

                // Set the next period date to the next month
                let nextPeriodStartDate = Calendar.current.date(byAdding: .month, value: 1, to: periodStartDate) ?? periodStartDate
                let nextPeriodMessage = "Your next period is expected to start on \(nextPeriodStartDate)."
                print(nextPeriodMessage)

            // Case 2: Current day is the same as the period date
            } else if currentDay == periodDay && currentMonth == periodMonth {
                print("The current day is the same as the period start day.")

                // Print the previous month's period end date
                let previousPeriodStartDate = Calendar.current.date(byAdding: .day, value: -(trackerInfo.cycleLength ?? 28), to: periodStartDate) ?? periodStartDate
                let previousPeriodEndDate = Calendar.current.date(byAdding: .day, value: (trackerInfo.periodLength ?? 4) - 1, to: previousPeriodStartDate) ?? previousPeriodStartDate
                print("Previous period ended on: \(previousPeriodEndDate)")
            }
            
            // Continue with existing logic for menstruation, ovulation, and pregnancy phases
            circularView.setCalendar(day: currentDay, month: currentMonth, year: Calendar.current.component(.year, from: currentDate))
            fillListOfCycles()
            circularView.setPeriodCycle(menstruation: menstrationList, ovulation: ovalutionList, pregnancy: pregnancyList)
            
            var periodType = PeriodType.Period
            
            if menstrationList.contains(currentDay) {
                periodType = PeriodType.Menstruation
            } else if ovalutionList.contains(currentDay) {
                periodType = PeriodType.Ovulation
            } else if pregnancyList.contains(currentDay) {
                periodType = PeriodType.Pregnancy
            }
            
            let value = trackerInfo.periodDate ?? ""
            if periodType.title == "Menstruation" {
                let valueSet = "You are currently in Menstruation phase, your last period cycle ended on \(value)."
                self.lastPeriodDateLabel.text = valueSet
            } else if periodType.title == "Ovulation" {
                let valueSet = "Currently in Ovulation phase. Your last period cycle ended on \(value)"
                self.lastPeriodDateLabel.text = valueSet
            } else if periodType.title == "Pregnancy" {
                let valueSet = "Currently in Pregnancy phase. Your last period cycle ended on \(value)."
                self.lastPeriodDateLabel.text = valueSet
            } else {
                let valueSet = "You are currently in the Normal phase. Your last period cycle ended on \(value)"
                self.lastPeriodDateLabel.text = valueSet
            }
            
            circularView.setPeroidType(periodItem: periodType)
            
            // Continue calculating the next period start date
            if let cycleLength = trackerInfo.cycleLength {
                let nextPeriodStartDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: periodStartDate)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                let nextPeriodStartDateString = dateFormatter.string(from: nextPeriodStartDate ?? Date())
                let nextPeriodMessage = "Your next period is expected to start on \(nextPeriodStartDateString)."
                print(nextPeriodMessage)
            }
        }
    }







    func setDaysV3() {
        if let trackerInfo = allMonthtrackerInfoV2?.first {
            // Call the function and destructure the tuple
            let cycleDates = makeCycleDatesListV2(info: trackerInfo)
            
            // Use the correct tuple members
            menstrationList = cycleDates.menstruation
            ovalutionList = cycleDates.ovulation
            pregnancyList = cycleDates.pregnancyCount
            
            guard let periodStartDate = trackerInfo.periodDate?.toDate() else {
                return
            }
            
            currentDay = trackerInfo.periodDate?.toDate().get(.month) == Date().get(.month) ? Date().get(.day) : 0
            currentMonth = trackerInfo.periodDate?.toDate().get(.month) == Date().get(.month) ? Date().get(.month) : trackerInfo.periodDate?.toDate().get(.month) ?? 0
            currentYear = trackerInfo.periodDate?.toDate().get(.year) == Date().get(.year) ? Date().get(.year) : trackerInfo.periodDate?.toDate().get(.year) ?? 0
            
            circularView.setCalendar(day: currentDay, month: currentMonth, year: currentYear)
            fillListOfCycles()
            circularView.setPeriodCycle(menstruation: menstrationList, ovulation: ovalutionList, pregnancy: pregnancyList)
            
            //-----MARK: - Calculate the next period start date and update period days ---------
            let cycleLength = trackerInfo.cycleLength ?? 28
            let nextPeriodStartDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: periodStartDate)
            let daysSincePeriodStart = Calendar.current.dateComponents([.day], from: periodStartDate, to: Date()).day ?? -1
            let daysSinceNextPeriodStart = Calendar.current.dateComponents([.day], from: nextPeriodStartDate ?? Date(), to: Date()).day ?? -1
            
            if daysSinceNextPeriodStart == 0 {
                circularView.setPeriodDays(days: 1)
            } else if daysSinceNextPeriodStart > 0 {
                circularView.setPeriodDays(days: daysSinceNextPeriodStart + 1)
            } else if daysSincePeriodStart >= 0 {
                circularView.setPeriodDays(days: daysSincePeriodStart + 1)
            }
            
            // Determine the current phase
            var periodType = PeriodType.Period
            let currentDate = Date()
            let currentDayOfMonth = Calendar.current.component(.day, from: currentDate)
            
            if menstrationList.contains(currentDayOfMonth) {
                periodType = PeriodType.Menstruation
            } else if ovalutionList.contains(currentDayOfMonth) {
                periodType = PeriodType.Ovulation
            } else if pregnancyList.contains(currentDayOfMonth) {
                periodType = PeriodType.Pregnancy
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            // Show current date range for menstruation
            if periodType.title == "Menstruation" {
                let periodStartDate = (trackerInfo.periodDate?.toDate() ?? Date()) - 1
                let periodEndDate = Calendar.current.date(byAdding: .day, value: (trackerInfo.periodLength ?? 4) - 1, to: periodStartDate) ?? Date()
                
                let periodStartString = dateFormatter.string(from: periodStartDate)
                let periodEndString = dateFormatter.string(from: periodEndDate)
                
                let valueSet = "Currently in the Menstruation phase \(periodStartString) to \(periodEndString), Your last period cycle ended on \(allMonthtrackerInfoV2?.first?.periodDate ?? "")"
                self.lastPeriodDateLabel.text = valueSet
            } else if periodType.title == "Ovulation" {
                let valueSet = "Currently in Ovulation phase. Your last period cycle ended on \(allMonthtrackerInfoV2?.first?.periodDate ?? "")."
                self.lastPeriodDateLabel.text = valueSet
            } else if periodType.title == "Pregnancy" {
                let valueSet = "Currently in Pregnancy phase. Your last period cycle ended on \(allMonthtrackerInfoV2?.first?.periodDate ?? "")."
                self.lastPeriodDateLabel.text = valueSet
            } else {
                let valueSet = "Currently in Normal phase. Your last period cycle ended on \(allMonthtrackerInfoV2?.first?.periodDate ?? "")."
                self.lastPeriodDateLabel.text = valueSet
            }
            
            circularView.setPeroidType(periodItem: periodType)
            
            // Display next period start date
            if let cycleLength = trackerInfo.cycleLength {
                let nextPeriodStartDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: periodStartDate)
                let nextPeriodStartDateString = dateFormatter.string(from: nextPeriodStartDate ?? Date())
                let nextPeriodMessage = "Your next period is expected to start on \(nextPeriodStartDateString)."
                print(nextPeriodMessage)
            }
        }
    }



    
    
    private func fillListOfCycles() {
        menstrationList.removeAll()
        ovalutionList.removeAll()
        pregnancyList.removeAll()
       /* allMonthtrackerInfo?.forEach({ (info) in
            let getCyclesRange = makeCycleDates(info: info)
            menstrationList.append(getCyclesRange.menustration)
            ovalutionList.append(getCyclesRange.ovalution)
            pregnancyList.append(getCyclesRange.preganancyCount)
        })*/
        if let info = allMonthtrackerInfoV2?.first {
        let getCyclesRange = makeCycleDatesListV2(info: info)
        menstrationList.append(contentsOf: getCyclesRange.menstruation)
        ovalutionList.append(contentsOf: getCyclesRange.ovulation)
        pregnancyList.append(contentsOf: getCyclesRange.pregnancyCount)
//            print("Period Calendar Cell")
//        print("CircularViewList")
//            print("Set seven dyas pn: \(menstrationList[0] - 7)")
        print("Menustration Lit:\(menstrationList)")
        print("ovalutionList Lit:\(ovalutionList)")
        print("pregnancyList Lit:\(pregnancyList)")
        }
    }
    
   /* private func makeCycleDates(info: UserTrackerInfo) -> (menustration: ClosedRange<Int>,ovalution: ClosedRange<Int>,preganancyCount: ClosedRange<Int>) {
        let periodstartDate = Int(info.periodDate?.toDate().convertDateToString("dd") ?? "1") ?? 1
        let periodEndDate = periodstartDate + (info.periodLength ?? 4) - 1
        let cycleEndDate = periodstartDate + (info.cycleLength ?? 28) - 1
        let leutalPhaseDays  = 14
        let ovulationStart = cycleEndDate - leutalPhaseDays
        let menstruationCount = Int(periodstartDate)...periodEndDate
        let ovalutionCount = ovulationStart...ovulationStart
        let pregnancyCount = Int(ovulationStart - 6)...(ovulationStart + 4)
        return (menustration: menstruationCount,ovalution: ovalutionCount, preganancyCount: pregnancyCount)
    } */
    
//    private func makeCycleDatesList(info: UserTrackerInfo) -> (menustration: [Int], ovalution:[Int], preganancyCount: [Int]) {
//        let periodstartDate = info.periodDate?.toDate()
//        
//        print("period start date: ", periodstartDate ?? "")
//        print("Period length: ", info.periodLength ?? 0)
//        
//        let periodEndDate = Calendar.current.date(byAdding: .day, value: (info.periodLength ?? 4) - 1, to: periodstartDate ?? Date())
//        print("Period end date: ", periodEndDate ?? "")
//        
//        let cycleEndDate = Calendar.current.date(byAdding: .day, value: (info.cycleLength ?? 28) - 1, to: periodstartDate ?? Date())
//        print("cycle length: ", info.cycleLength ?? 0)
//        print("cycle end date: ", cycleEndDate ?? "")
//        
//        let leutalPhaseDays  = 14
//        let ovulationDay = Calendar.current.date(byAdding: .day, value: -leutalPhaseDays, to: cycleEndDate ?? Date())//cycleEndDate - leutalPhaseDays
//        let ovulationStart = Calendar.current.date(byAdding: .day, value: -1, to: ovulationDay ?? Date())//cycleEndDate - leutalPhaseDays
//       let ovulationEnd = Calendar.current.date(byAdding: .day, value: +1, to: ovulationDay ?? Date())
//        // Make Dates
//        let menustration = datesRange(from: (periodstartDate ?? Date()), to: (periodEndDate ?? Date()))
//        let ovalutionCount = datesRange(from: (ovulationStart ?? Date()), to: (ovulationEnd ?? Date()))
//        let lowFertilityStartDate = Calendar.current.date(byAdding: .day, value: -4, to: ovulationDay ?? Date())
//        let lowFertilityEndDate = Calendar.current.date(byAdding: .day, value: 4, to: ovulationDay ?? Date())
//        let pregnancyCount = datesRange(from: (lowFertilityStartDate ?? Date()), to: (lowFertilityEndDate ?? Date()))
//        return (menustration: menustration ,ovalution: ovalutionCount, preganancyCount: pregnancyCount)
//    }
    
    private func makeCycleDatesList(info: UserTrackerInfo) -> (menstruation: [Int], ovulation: [Int], pregnancyCount: [Int]) {
        guard let periodStartDate = info.periodDate?.toDate() else {
            return (menstruation: [], ovulation: [], pregnancyCount: [])
        }

        print("Period start date: ", periodStartDate)
        print("Period length: ", info.periodLength ?? 0)
        print("Cycle length: ", info.cycleLength ?? 0)

        // Calculate the next period start date based on cycle length
        let nextPeriodStartDate = Calendar.current.date(byAdding: .day, value: info.cycleLength ?? 28, to: periodStartDate) ?? Date()
        let periodEndDate = Calendar.current.date(byAdding: .day, value: (info.periodLength ?? 4) - 1, to: nextPeriodStartDate) ?? Date()
        print("Next period start date: ", nextPeriodStartDate)
        print("Period end date: ", periodEndDate)

        // Calculate ovulation end date as 14 days before the next period start date
        let ovulationEndDate = Calendar.current.date(byAdding: .day, value: -14, to: nextPeriodStartDate) ?? Date()
        // Calculate ovulation start date as 4 days before the ovulation end date
        let ovulationStartDate = Calendar.current.date(byAdding: .day, value: -4, to: ovulationEndDate) ?? Date()
        
        print("Ovulation start date: ", ovulationStartDate)
        print("Ovulation end date: ", ovulationEndDate)

        // Calculate low fertility period
        let lowFertilityStartDate = Calendar.current.date(byAdding: .day, value: -6, to: ovulationEndDate) ?? Date()
        let lowFertilityEndDate = Calendar.current.date(byAdding: .day, value: 4, to: ovulationEndDate) ?? Date()

        let menstruation = datesRange(from: nextPeriodStartDate, to: periodEndDate)
        let ovulationCount = datesRange(from: ovulationEndDate, to: ovulationEndDate)
        let pregnancyCount = datesRange(from: lowFertilityStartDate, to: lowFertilityEndDate)

        return (menstruation: menstruation, ovulation: ovulationCount, pregnancyCount: pregnancyCount)
    }
    
    
    private func makeCycleDatesListV2(info: ViewPeriodTrackerModel) -> (menstruation: [Int], ovulation: [Int], pregnancyCount: [Int]) {
        guard let periodStartDate = info.periodDate?.toDate() else {
            return (menstruation: [], ovulation: [], pregnancyCount: [])
        }

        print("Period start date: ", periodStartDate)
        print("Period length: ", info.periodLength ?? 0)
        print("Cycle length: ", info.cycleLength ?? 0)

        // Calculate the next period start date based on cycle length
        let nextPeriodStartDate = Calendar.current.date(byAdding: .day, value: info.cycleLength ?? 28, to: periodStartDate) ?? Date()
        let periodEndDate = Calendar.current.date(byAdding: .day, value: (info.periodLength ?? 4) - 1, to: nextPeriodStartDate) ?? Date()
        print("Next period start date: ", nextPeriodStartDate)
        print("Period end date: ", periodEndDate)

        // Calculate ovulation end date as 14 days before the next period start date
        let ovulationEndDate = Calendar.current.date(byAdding: .day, value: -14, to: nextPeriodStartDate) ?? Date()
        // Calculate ovulation start date as 4 days before the ovulation end date
        let ovulationStartDate = Calendar.current.date(byAdding: .day, value: -4, to: ovulationEndDate) ?? Date()
        
        print("Ovulation start date: ", ovulationStartDate)
        print("Ovulation end date: ", ovulationEndDate)

        // Calculate low fertility period
        let lowFertilityStartDate = Calendar.current.date(byAdding: .day, value: -6, to: ovulationEndDate) ?? Date()
        let lowFertilityEndDate = Calendar.current.date(byAdding: .day, value: 4, to: ovulationEndDate) ?? Date()

        let menstruation = datesRange(from: nextPeriodStartDate, to: periodEndDate)
        let ovulationCount = datesRange(from: ovulationEndDate, to: ovulationEndDate)
        let pregnancyCount = datesRange(from: lowFertilityStartDate, to: lowFertilityEndDate)

        return (menstruation: menstruation, ovulation: ovulationCount, pregnancyCount: pregnancyCount)
    }

    func datesRange(from startDate: Date, to endDate: Date) -> [Int] {
        var dates: [Int] = []
        var currentDate = startDate
        while currentDate <= endDate {
            let day = Calendar.current.component(.day, from: currentDate)
            dates.append(day)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        return dates
    }
    


    @IBAction func didTapInfoButton(_ sender: Any) {
        infoHandler?()
    }
}


