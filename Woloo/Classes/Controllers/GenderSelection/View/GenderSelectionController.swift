//
//  GenderSelectionController.swift
//  Woloo
//
//  Created on 02/08/21.
//

import UIKit
import Alamofire

class GenderSelectionController: UIViewController {
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var preferNotButton: UIButton!
    
    private var selectedGender = -1
    
    var objGenderSelectionViewModel = GenderSelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
//        let buttons = [maleButton, femaleButton, othersButton, preferNotButton]
//        buttons.forEach { (btn) in
//            btn?.layer.cornerRadius = (btn?.frame.height ?? 0)/2
//        }
        fillSelectedGender(sender: 1)
        self.objGenderSelectionViewModel.delegate = self
    }

    // MARK: - @IBAction's
    
    @IBAction func genderAction(_ sender: UIButton) {
        selectedGender = sender.tag
        fillSelectedGender(sender: sender.tag)
    }
    
    @IBAction func nextAction(_ sender: Any) { // Next Action
        if selectedGender == 0 || selectedGender == 1 {
           // editProfileAPI(gender: selectedGender)
            editProfileAPICall(gender: selectedGender)
//
          //  self.editGenderAPICall(gender: selectedGender)
        } else {
            openTopicScreen()
        }
    }
}


// MARK: - API's
extension GenderSelectionController {
    
    func editProfileAPICall(gender: Int){
        var selectedGender = ""
        switch gender {
        case 0: // Male
            selectedGender = "Male"
        case 1: // Female
            selectedGender = "Female"
        case 2: // Others
            break
        case 3: // prefer not to say
            break
        default:
            break
        }
        
        Global.showIndicator()
        self.objGenderSelectionViewModel.editProfileGenderAPI(gender: selectedGender)
    }
    
    
    
    private func editProfileAPI(gender: Int) {
        var selectedGender = ""
        switch gender {
        case 0: // Male
            selectedGender = "Male"
        case 1: // Female
            selectedGender = "Female"
        case 2: // Others
            break
        case 3: // prefer not to say
            break
        default:
            break
        }
        let param = [Key.name: UserModel.getAuthorizedUserInfo()?.name, Key.email: UserModel.getAuthorizedUserInfo()?.email, Key.city: UserModel.getAuthorizedUserInfo()?.city, Key.pincode: UserModel.getAuthorizedUserInfo()?.pincode, Key.address: UserModel.getAuthorizedUserInfo()?.address, "gender": selectedGender, "dob": UserModel.getAuthorizedUserInfo()?.dob]
        Global.showIndicator()
        APIManager.shared.postEditProfileData(param: param as [String : Any]) { [weak self] (result, errorMessage) in
            guard let weak = self else { return }
            if result != nil {
            DispatchQueue.main.async {
                Global.hideIndicator()
            }
                weak.openTopicScreen()
            }
        }
    }
}

// MARK: - Logics
extension GenderSelectionController {
    /// Change button action tag related.
    /// - Parameter sender: **Tag**
    private func fillSelectedGender(sender: Int) {
        maleButton.isSelected = sender == 0
        femaleButton.isSelected = sender == 1
        othersButton.isSelected = sender == 2
        preferNotButton.isSelected = sender == 3
    }
}

// MARK: - Handle Other Controller
extension GenderSelectionController {
    private func openTopicScreen() {
        let topicSB = UIStoryboard(name: "Authentication", bundle: nil)
        if let topicVC = topicSB.instantiateViewController(withIdentifier: "IntrestedTopicVC") as? IntrestedTopicVC {
            navigationController?.pushViewController(topicVC, animated: true)
        }
    }
    
    private func openTrackerScreen() {
        let trackerSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let trackerVC = trackerSB.instantiateViewController(withIdentifier: "PeriodTrackerViewController") as? PeriodTrackerViewController {
            navigationController?.pushViewController(trackerVC, animated: true)
        }
    }
}

extension GenderSelectionController: GenderSelectionViewModelDelegate{
    
    func editGenderAPICall(gender: Int?){
        var selectedGender = ""
        switch gender {
        case 0: // Male
            selectedGender = "Male"
        case 1: // Female
            selectedGender = "Female"
        case 2: // Others
            break
        case 3: // prefer not to say
            break
        default:
            break
        }
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        let data = [ "gender" : "\(selectedGender)",
                       "id" : "\(UserDefaultsManager.fetchUserID())"] as [String : Any]
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        let systemVersion = UIDevice.current.systemVersion
        let iOS = "IOS"
        let userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent,
                       "Content-Type": "application/x-www-form-urlencoded"]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .wolooGuest, method: .put, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<Profile>, Error>) in
            switch result{
            case .success(let response):
                print("gender changed")
                Global.hideIndicator()
                UserDefaultsManager.storeUserProfile(value: response.results)
                self.openTopicScreen()
               
            case .failure(let error):
                print("gender changed: \(error)")
                Global.hideIndicator()
               
            }
        }
    }
    
    
    func didReceiveEditProfileResponse(objResponse: BaseResponse<Profile>) {
        Global.hideIndicator()
        UserDefaultsManager.storeUserProfile(value: objResponse.results)
        self.openTopicScreen()
    }
    
    func didReceiceEditProfileError(strError: String) {
        Global.hideIndicator()
        //
    }
}
