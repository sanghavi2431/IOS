//
//  EditCycleViewController.swift
//  Woloo
//
//  Created on 11/08/21.
//

import UIKit

class EditCycleViewController: UIViewController {

    @IBOutlet var dayTextField: UITextField!
    @IBOutlet var monthTextField: UITextField!
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var cycleLengthTextField: UITextField!
    @IBOutlet var periodLengthTextField: UITextField!
    @IBOutlet var titleForCycleLabel: UILabel!
    
    let datePicker = UIDatePicker()
    var handleEditCycle: ((_ info: ViewPeriodTrackerModel) -> Void)?
    var selectedDate: Date?
    var periodLength = 4
    var cycleLength = 28
    var isEditScreen = false
    var loginfo: [String: [String]]?
    var netcoreEvents = NetcoreEvents()
    
    var objPeriodTrackerViewModel = EditCycleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objPeriodTrackerViewModel.delegate = self
        
        titleForCycleLabel.text = isEditScreen ? "Edit Cycle": "Add Cycle"
        self.navigationController?.navigationBar.isHidden = true
        DELEGATE.rootVC?.tabBarVc?.hideTabBar()
        setupUI()
    }
    
    private func setupUI() {
        
        dayTextField.text = selectedDate?.convertDateToString("dd")
        monthTextField.text = selectedDate?.convertDateToString("MMM")
        yearTextField.text = selectedDate?.convertDateToString("yyyy")
        periodLengthTextField.text = "\(periodLength)"
        cycleLengthTextField.text = "\(cycleLength)"
        
        let allTextfield = [dayTextField, monthTextField, yearTextField]
        allTextfield.forEach { (textField) in
            
            textField?.inputView = datePicker
        }
        cycleLengthTextField?.delegate = self
        periodLengthTextField?.delegate = self
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: -35, to: Date())
        datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.addTarget(self, action: #selector(datePickerAction(_:)), for: .valueChanged)
    }
}

// MARK: - @IBActions
extension EditCycleViewController {
    @IBAction func saveAction(_ sender: Any) { // Added validation for add or update Cycle.
        if let date = selectedDate, let dateLast35Days = Calendar.current.date(byAdding: .day, value: -35, to: Date()) {
           // date 35 days ago
           let days = Calendar.current.dateComponents([.day], from: dateLast35Days, to: date).day ?? 0
           if days < 0 {
            Global.showAlert(title: "", message: "Date cannot be earlier than 35 Days from today")
            return
           }
       }
         else if let periodLength = Int(periodLengthTextField.text ?? "0"), let cycleLength = Int(cycleLengthTextField.text ?? "0")
        {
            if periodLength < 2 || periodLength > 5 {
                Global.showAlert(title: "", message: "Bleeding Days should be between 2-5 days")
                return
            } else if cycleLength < 24 || cycleLength > 35 {
                Global.showAlert(title: "", message: "Cycle Length should be between 24-35 days")
                return
            }
        }
        
        //setperiodTrackerAPI()
        setPeriodTrackerAPICall()
        
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func datePickerAction(_ sender: UIDatePicker) {
        let date = sender.date
        selectedDate = date
        dayTextField.text = date.convertDateToString("dd")
        monthTextField.text = date.convertDateToString("MMM")
        yearTextField.text = date.convertDateToString("yyyy")
        
    }
}

// MARK: - UITextFieldDelegate
extension EditCycleViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == periodLengthTextField || textField == cycleLengthTextField {
            self.dayTextField.resignFirstResponder()
            self.monthTextField.resignFirstResponder()
            self.yearTextField.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == periodLengthTextField || textField == cycleLengthTextField {
            if (textField.text?.count ?? 0) > 2 {
                return false
            }
        }
        return true
    }
}

// MARK: - API calling
extension EditCycleViewController {
    
    func setPeriodTrackerAPICall(){
        
        var editPeriodTracker = ViewPeriodTrackerModel()
        
        editPeriodTracker.cycleLength = Int(cycleLengthTextField.text ?? "0") ?? 0
        editPeriodTracker.periodDate = selectedDate?.convertDateToString("yyyy-MM-dd") ?? ""
        
        editPeriodTracker.periodLength = Int(periodLengthTextField.text ?? "0") ?? 0
        
        editPeriodTracker.lutealLength = Int(periodLengthTextField.text ?? "0") ?? 0
        
        editPeriodTracker.log = loginfo ?? [:]
        
        Global.showIndicator()
        self.objPeriodTrackerViewModel.setPeriodTracker(objPeriodTracker: editPeriodTracker)
        
    }
    
    
//    private func setperiodTrackerAPI() {
//        let param: [String: Any] = [ "period_date": selectedDate?.convertDateToString("yyyy-MM-dd") ?? "",
//                                     "cycle_lenght": Int(cycleLengthTextField.text ?? "0") ?? 0,
//                                     "period_length": Int(periodLengthTextField.text ?? "0") ?? 0,
//                                     "luteal_length": 14,
//                                     "log": loginfo ?? [:]]
//        APIManager.shared.setPeriodTracker(param: param) { (trackerInfo, message) in
//            if let info = trackerInfo {
//                print(info.toJSONString() ?? "")
//                self.handleEditCycle?(info)
//                if self.isEditScreen {
//                    self.navigationController?.popViewController(animated: true)
//                    Global.addNetcoreEvent(eventname: self.netcoreEvents.periodTrackerUpdateClick, param: ["period_date":"\(info.periodDate ?? "")","cycle_length":"\(info.cycleLength ?? 0)","period_length":"\(info.periodLength ?? 0)","luteal_length":"\(info.lutealLength ?? 0)", "user_id":"\(UserModel.user?.userId ?? 0)", "platform":"iOS"])
//                    print("Edit cycle info: \(info)")
//                } else {
//                    self.openTrackerVC()
//                }
//               
//            }
//            print(message)
//        }
//    }
}
extension EditCycleViewController: EditCycleViewModelDelegate {
    
    
    //MARK: - EditCycleViewModelDelegate
    func didReceivePeriodTrackerResponse(objResponse: BaseResponse<ViewPeriodTrackerModel>) {
        Global.hideIndicator()
        self.openTrackerVC()
    }
    
    func didReceievPeriodTrackerError(strError: String) {
        Global.hideIndicator()
    }
    
    
    
    fileprivate func openTrackerVC() {
        let trackerSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let trackerVC = trackerSB.instantiateViewController(withIdentifier: "PeriodTrackerViewController") as? PeriodTrackerViewController {
//            trackerVC.isFromDashBoard = true
            navigationController?.pushViewController(trackerVC, animated: true)
        }
    }
}
