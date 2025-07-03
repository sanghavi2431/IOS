//
//  DailyLogViewController.swift
//  Woloo
//
//  Created on 04/08/21.
//

import UIKit

protocol DailyLogViewControllerDelegate: NSObjectProtocol{
    
    func didCalledSetPeriodTrackerAPI()
}

class DailyLogViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var handleSelectedCategory:((_ category: DailyLogInfo?) -> Void)?
    var trackerInfo: ViewPeriodTrackerModel?
    var delegate: DailyLogViewControllerDelegate?
    var objEditProfileViewModel = EditCycleViewModel()
    var objPeriodTracker = ViewPeriodTrackerModel()
    
    /// Daily Log List Enum
    private enum DailyLogSection: Int, CaseIterable {
        case premenstration
        case menstration
        case diseasesandMedication
        case habits
        case bleeding
        case mood
        case sexAndSexDrive
        
        var title: String {
            switch self {
            case .habits:
                return "Habits"
            case .diseasesandMedication:
                return "Diseases and Medication"
            case .bleeding:
                return "Bleeding"
            case .mood:
                return "Mood"
            case .premenstration:
                return "Symptoms-Mostly During Pre Mensturation"
            case .menstration:
                return "Symptoms-Mostly During Mensturation"
            case .sexAndSexDrive:
                return "Sex and Sex Drive"
            }
        }
    }
    
    var selectedCategory = DailyLogInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objEditProfileViewModel.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
       // DELEGATE.rootVC?.tabBarVc?.hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        DELEGATE.rootVC?.tabBarVc?.showTabBar()
//        DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
    }

    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Cell.dailyLogCell, bundle: nil), forCellReuseIdentifier: Cell.dailyLogCell)
        tableView.reloadData()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        handleSelectedCategory?(selectedCategory)
        //setperiodTrackerAPI()
        self.setperiodTrackerAPICall()
    }
    
    
    func setperiodTrackerAPICall(){
        let bleedigList = selectedCategory.bleedig.compactMap({$0.title.lowercased()})
        let moodList = selectedCategory.mood.compactMap({$0.title.lowercased()})
        let preMenstruation = selectedCategory.preMenstruation.compactMap({$0.title.lowercased()})
        let menstruation = selectedCategory.menstruation.compactMap({$0.title.lowercased()})
        let habits = selectedCategory.habits.compactMap({$0.title.lowercased()})
        let diseasMediaction = selectedCategory.diseasAndMediaction.compactMap({$0.title.lowercased()})
        let sexDriveList = selectedCategory.sexDrive.compactMap({$0.title.lowercased()})
        
        self.objPeriodTracker.periodDate = trackerInfo?.periodDate?.toDate().convertDateToString("yyyy-MM-dd") ?? ""
        self.objPeriodTracker.cycleLength = trackerInfo?.cycleLength ?? 0
        self.objPeriodTracker.periodLength = trackerInfo?.periodLength ?? 0
        
        self.objPeriodTracker.periodLength = trackerInfo?.periodLength ?? 0
        
        self.objPeriodTracker.lutealLength = 14
        self.objPeriodTracker.log = [
            "bleeding": bleedigList,
            "mood": moodList,
            "menstruation": menstruation,
            "premenstruation": preMenstruation,
            "habits": habits,
            "diseasesandmedication": diseasMediaction,
            "sexDrive": sexDriveList,
        ]
        
        Global.showIndicator()
        self.objEditProfileViewModel.setPeriodTracker(objPeriodTracker: self.objPeriodTracker)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension DailyLogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DailyLogSection.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.dailyLogCell, for: indexPath) as? DailyLogCell ?? DailyLogCell()
        cell.selectedCategory = selectedCategory
        cell.sectionForDailyLogs = indexPath.section
        cell.bgView.backgroundColor = .white
        cell.bgView.layer.applySketchShadow()
        cell.delegate = self
        cell.titleLabel.text = DailyLogSection.allCases[indexPath.section].title.capitalized
        return cell
    }
}

// MARK: - DailyCellDelegate
extension DailyLogViewController: DailyCellDelegate {
    func didselectLogCategory(_ dailyLogSection: Int,_ selectedIndex: Int) {
        switch dailyLogSection {
        case 0: //premenstration
            if let index = selectedCategory.preMenstruation.firstIndex(where: {$0 == PreMenstruation.allCases[selectedIndex]}) {
                selectedCategory.preMenstruation.remove(at: index)
            } else {
                selectedCategory.preMenstruation.append(PreMenstruation.allCases[selectedIndex])
            }
        case 1: // menstration
            if let index = selectedCategory.menstruation.firstIndex(where: {$0 == Menstruation.allCases[selectedIndex]}) {
                selectedCategory.menstruation.remove(at: index)
            } else {
                selectedCategory.menstruation.append(Menstruation.allCases[selectedIndex])
            }
        case 2: // diseasesandMedication
            if let index = selectedCategory.diseasAndMediaction.firstIndex(where: {$0 == DieasesAndMedication.allCases[selectedIndex]}) {
                selectedCategory.diseasAndMediaction.remove(at: index)
            } else {
                selectedCategory.diseasAndMediaction.append(DieasesAndMedication.allCases[selectedIndex])
            }
        case 3: // habits
            if let index = selectedCategory.habits.firstIndex(where: {$0 == Habits.allCases[selectedIndex]}) {
                selectedCategory.habits.remove(at: index)
            } else {
                selectedCategory.habits.append(Habits.allCases[selectedIndex])
            }
        case 4:
            if let index = selectedCategory.bleedig.firstIndex(where: {$0 == Bleeding.allCases[selectedIndex]}) {
                selectedCategory.bleedig.remove(at: index)
            } else {
                selectedCategory.bleedig.append(Bleeding.allCases[selectedIndex])
            }
           
        case 5:
            if let index = selectedCategory.mood.firstIndex(where: {$0 == Mood.allCases[selectedIndex]}) {
                selectedCategory.mood.remove(at: index)
            } else {
                selectedCategory.mood.append(Mood.allCases[selectedIndex])
            }
        case 6:
            if let index = selectedCategory.sexDrive.firstIndex(where: {$0 == SexDrive.allCases[selectedIndex]}) {
                selectedCategory.sexDrive.remove(at: index)
            } else {
                selectedCategory.sexDrive.append(SexDrive.allCases[selectedIndex])
            }
        default:
                break
        }
        self.tableView.reloadData()
    }
}

// MARK: - API calling
extension DailyLogViewController: EditCycleViewModelDelegate  {
    
    
    //MARK: - EditCycleViewModelDelegate
    func didReceivePeriodTrackerResponse(objResponse: BaseResponse<ViewPeriodTrackerModel>) {
        Global.hideIndicator()
        if (self.delegate) != nil{
            self.delegate?.didCalledSetPeriodTrackerAPI()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func didReceievPeriodTrackerError(strError: String) {
        Global.hideIndicator()
    }
    
    
    private func setperiodTrackerAPI() {
        let bleedigList = selectedCategory.bleedig.compactMap({$0.title.lowercased()})
        let moodList = selectedCategory.mood.compactMap({$0.title.lowercased()})
        let preMenstruation = selectedCategory.preMenstruation.compactMap({$0.title.lowercased()})
        let menstruation = selectedCategory.menstruation.compactMap({$0.title.lowercased()})
        let habits = selectedCategory.habits.compactMap({$0.title.lowercased()})
        let diseasMediaction = selectedCategory.diseasAndMediaction.compactMap({$0.title.lowercased()})
        let sexDriveList = selectedCategory.sexDrive.compactMap({$0.title.lowercased()})
        let param: [String: Any] = [ "period_date": trackerInfo?.periodDate?.toDate().convertDateToString("yyyy-MM-dd") ?? "",
                                     "cycle_lenght": trackerInfo?.cycleLength ?? 0,
                                     "period_length": trackerInfo?.periodLength ?? 0,
                                     "luteal_length": "14",
                                     "log":
                                        [
                                            "bleeding": bleedigList,
                                            "mood": moodList,
                                            "menstruation": menstruation,
                                            "premenstruation": preMenstruation,
                                            "habits": habits,
                                            "diseasesandmedication": diseasMediaction,
                                            "sexDrive": sexDriveList,
                                        ]
                                    ]
        APIManager.shared.setPeriodTracker(param: param) { (trackerInfo, message) in
            if let info = trackerInfo {
                print(info.toJSONString() ?? "")
                if (self.delegate) != nil{
                    self.delegate?.didCalledSetPeriodTrackerAPI()
                }
                self.navigationController?.popViewController(animated: true)
            }
            print(message)
        }
    }
}
