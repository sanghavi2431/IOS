//
//  EditPeriodTrackerPopUp.swift
//  Woloo
//
//  Created by CEPL on 10/02/25.
//

import UIKit
import STPopup

protocol EditPeriodTrackerPopUpDelegate: NSObjectProtocol{
    
    func didUpdatePeriodTracker(objViewPeriodTrackerModel: ViewPeriodTrackerModel?)
    
}

class EditPeriodTrackerPopUp: UIViewController, UITextFieldDelegate {
   
    @IBOutlet var dayTextField: UITextField!
    @IBOutlet var monthTextField: UITextField!
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var cycleLengthTextField: UITextField!
    @IBOutlet var periodLengthTextField: UITextField!
    
    let datePicker = UIDatePicker()
    var selectedDate: Date?
    var periodLength = 4
    var cycleLength = 28
    var objPeriodTrackerViewModel = EditCycleViewModel()
    var netcoreEvents = NetcoreEvents()
    var loginfo: [String: [String]]?
    weak var delegate: EditPeriodTrackerPopUpDelegate?
    var objViewPeriodTrackerModel = ViewPeriodTrackerModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }


    func loadInitialSettings(){
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width - 32, height: 580)
        self.popupController?.containerView.layer.cornerRadius = 8.0
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        
        self.setupUI()
    }
    
    func setupUI() {
        
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
    
    @objc func datePickerAction(_ sender: UIDatePicker) {
        let date = sender.date
        selectedDate = date
        print("Selected date: ", selectedDate ?? Date())
        dayTextField.text = date.convertDateToString("dd")
        monthTextField.text = date.convertDateToString("MMM")
        yearTextField.text = date.convertDateToString("yyyy")
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    
    @IBAction func clickedSaveBtn(_ sender: UIButton) {
        let periodLength = Int(periodLengthTextField.text ?? "0")
            let cycleLength = Int(cycleLengthTextField.text ?? "0")
            
            let validation = validatePeriodTrackingInputs(selectedDate: selectedDate, periodLength: periodLength, cycleLength: cycleLength)
            if !validation.isValid {
                Global.showAlert(title: "", message: validation.errorMessage ?? "Invalid input")
                return
            }
        self.setPeriodTrackerAPICall()
    }
    
    func validatePeriodTrackingInputs(selectedDate: Date?, periodLength: Int?, cycleLength: Int?) -> (isValid: Bool, errorMessage: String?) {
            if let date = selectedDate, let dateLast35Days = Calendar.current.date(byAdding: .day, value: -35, to: Date()) {
                let days = Calendar.current.dateComponents([.day], from: dateLast35Days, to: date).day ?? 0
                if days < 0 {
                    return (false, "Date cannot be earlier than 35 Days from today")
                }
            }
            
            if let periodLength = periodLength, let cycleLength = cycleLength {
                if periodLength < 2 || periodLength > 5 {
                    return (false, "Bleeding Days should be between 2-5 days")
                } else if cycleLength < 24 || cycleLength > 35 {
                    return (false, "Cycle Length should be between 24-35 days")
                }
            }
            
            return (true, nil)
        }
    
    
   
    func openTrackerVC() {
       let trackerSB = UIStoryboard(name: "Tracker", bundle: nil)
       if let trackerVC = trackerSB.instantiateViewController(withIdentifier: "PeriodTrackerViewController") as? PeriodTrackerViewController {
//            trackerVC.isFromDashBoard = true
           navigationController?.pushViewController(trackerVC, animated: true)
       }
   }
    
    func setPeriodTrackerAPICall(){
        
        var editPeriodTracker = ViewPeriodTrackerModel()
        
        editPeriodTracker.cycleLength = Int(cycleLengthTextField.text ?? "0") ?? 0
        editPeriodTracker.periodDate = selectedDate?.convertDateToString("yyyy-MM-dd") ?? ""
        
        editPeriodTracker.periodLength = Int(periodLengthTextField.text ?? "0") ?? 0
        
        editPeriodTracker.lutealLength = Int(periodLengthTextField.text ?? "0") ?? 0
        
        editPeriodTracker.log = loginfo ?? [:]
        
        if self.delegate != nil{
            self.dismiss(animated: true)
            self.delegate?.didUpdatePeriodTracker(objViewPeriodTrackerModel: editPeriodTracker)
        }
        //Global.showIndicator()
        
     //   self.objPeriodTrackerViewModel.setPeriodTracker(objPeriodTracker: editPeriodTracker)
        
    }
   
}
