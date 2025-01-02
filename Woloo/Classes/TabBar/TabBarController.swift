//
//  TabBarController.swift
//  Woloo
//
//  Created by Ashish Khobragade on 22/12/20.
//

import UIKit
import SafariServices

class TabBarController: UITabBarController {
    private let popupView = WolooTabPopUp.instanceFromNib()
    private var isLocatorTapped = false
    private var previousIndex = 0
    var netcoreEvents = NetcoreEvents()
    var isPopUpVisible: Bool? = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        DELEGATE.rootVC?.tabBarVc = self
        self.delegate = self
        if let items = self.tabBar.items {
            print("tab - \(self.tabBar.items?.first?.title ?? "12")")
            let tabBarItem = items[2]
            tabBarItem.image = UIImage(named: "ic_home_tab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            tabBarItem.selectedImage = UIImage(named: "ic_home_tab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            tabBarItem.title = ""
            if UIDevice.current.userInterfaceIdiom == .pad {
                tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom:15, right: 0)
            } else {
                tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom:15, right: 0)
            }
        }
        
        // Navigate to Loo Locate (Map View) Page
        self.selectedIndex = 2
        // Navigate to Home Page
        // self.selectedIndex = 0

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       // print("Selected item")
//        print("myindex - \(self.selectedIndex)")
        previousIndex = self.selectedIndex
        if self.selectedIndex == 0 {
            isLocatorTapped = false
           // Global.addFirebaseEvent(eventName: "shop_click", param: [:])
            Global.addNetcoreEvent(eventname: self.netcoreEvents.shopClick, param: [:])
        } else if self.selectedIndex == 1 {
           // Global.addFirebaseEvent(eventName: "invite_click", param: [:]) //1
            isLocatorTapped = false
        } else if self.selectedIndex == 2 {
            if self.selectedIndex == 2 { // Woloo Log clicked then show pop up
                tabBarController?.selectedIndex = previousIndex
            } else {
                previousIndex = self.selectedIndex
            }
           
//            var param = [String:Any]()
//            if let currentLocation = DELEGATE.locationManager.location {
//                param["location"] = "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))"
//            }
//            Global.addFirebaseEvent(eventName: "host_near_you_click", param: param)
        } else if self.selectedIndex == 3 {
            isLocatorTapped = false
//            Global.addFirebaseEvent(eventName: "my_account_click", param: [:])
        } else if self.selectedIndex == 4 {
            isLocatorTapped = false
//            Global.addFirebaseEvent(eventName: "more_search_click", param: [:])
        }

        UserDefaults.standard.set(1, forKey:"overlay_shown")
        UserDefaults.standard.synchronize()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Private Methods
    
    func hideTabBar() {
        var frame = self.tabBar.frame
        frame.origin.y = self.view.frame.size.height + (frame.size.height)
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBar.frame = frame
        })
    }

    func showTabBar() {
        var frame = self.tabBar.frame
        frame.origin.y = self.view.frame.size.height - (frame.size.height)
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBar.frame = frame
        })
    }
    
    func showPopUpVC(vc: UIViewController) {
           self.popupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 420)
           popupView.handleButtonAction = { tag in
               switch tag {
               case 0:  // Shop
                   self.openShopeVC()
               case 1: // Locator
                   self.isLocatorTapped = true
                   self.selectedIndex = 2
                   break
               case 2: // Period Tracker
                  // self.getPeriodTracker()
                   self.getPeriodTrackerV2()
               case 3: // Expand And collapse
                   UIView.animate(withDuration: 0.5, animations: {
                       self.isPopUpVisible = false
   //                    if self.popupView.frame.origin.y == UIScreen.main.bounds.height {
   //                        self.popupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-470, width: UIScreen.main.bounds.width, height: 420)
   //                    } else {
   //                        self.popupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 420)
   //                    }
                       //hide popup
                       self.popupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 420)
                   })
               case 4: // Thirst Reminder
                   self.openThirstReminder()
               case 5: // Woloo Community
                   self.openWolooCommunity()
               default:
                   break
               }
           }
           vc.view.addSubview(popupView)
           vc.view.bringSubviewToFront(popupView)
       }
}
extension TabBarController: UITabBarControllerDelegate {
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let rootView = self.viewControllers![self.previousIndex] as! UINavigationController
        rootView.popToRootViewController(animated: false)
        if self.selectedIndex == 2 { // Woloo Log clicked then show pop up
            self.selectedIndex = previousIndex // forcely stop to changing tab.
            UIView.animate(withDuration: 0.5, animations: {
                //show popoup view
                if self.isPopUpVisible == false{
                    //show popoup
                    self.popupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-470, width: UIScreen.main.bounds.width, height: 420)
                    self.isPopUpVisible = true
                }
                else{
                    //hide popup
                    self.popupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 420)
                    self.isPopUpVisible = false
                }
               
            })
        } else {
            self.isPopUpVisible = false
            previousIndex = self.selectedIndex
        }
        
        print("myindex - \(self.selectedIndex)")
        UserDefaults.standard.set(1, forKey:"overlay_shown")
        UserDefaults.standard.synchronize()
    }
}

// MARK: - Handle Controllers
extension TabBarController {
    fileprivate func openShopeVC() {
        //snehal_done
        let shopeSB = UIStoryboard(name: "Shop", bundle: nil)
        let shopeVC = shopeSB.instantiateViewController(withIdentifier: "ECommerceDashboardViewController")
        let navigationVC = self.viewControllers![self.previousIndex] as! UINavigationController
        navigationVC.pushViewController(shopeVC, animated: true)
    }

    fileprivate func openTrackerVC() {
        let trackerSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let trackerVC = trackerSB.instantiateViewController(withIdentifier: "PeriodTrackerViewController") as? PeriodTrackerViewController {
//            trackerVC.isFromDashBoard = true
            let navigationVC = self.viewControllers![self.previousIndex] as! UINavigationController
            navigationVC.pushViewController(trackerVC, animated: true)
        }
    }
    
    fileprivate func openThirstReminder() {
        let wolooDashboardSB = UIStoryboard(name: "WolooDashBoard", bundle: nil)
        if let dashboardVC = wolooDashboardSB.instantiateViewController(withIdentifier: "WolooDashBoardVC") as? WolooDashBoardVC {
            dashboardVC.isFromDashBoard = true
            let navigationVC = self.viewControllers![self.previousIndex] as! UINavigationController
            navigationVC.pushViewController(dashboardVC, animated: true)
        }
    }
    
    fileprivate func openWolooCommunity() {
        guard let url = URL(string: "https://iamhere.app/community/women_hygiene_1624314543470") else {
            return
        }
        // Present SFSafariViewController
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    fileprivate func editCycleVC(_ info: UserTrackerInfo? = nil) {
        let editCycleSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let editCycleVc = editCycleSB.instantiateViewController(withIdentifier: "EditCycleViewController") as? EditCycleViewController {
            editCycleVc.isEditScreen = false
            if let editCycleInfo = info {
                editCycleVc.selectedDate = editCycleInfo.periodDate?.toDate()
                editCycleVc.cycleLength = editCycleInfo.cycleLength ?? 28
                editCycleVc.periodLength = editCycleInfo.periodLength ?? 4
                editCycleVc.loginfo = editCycleInfo.log
            }
            let navigationVC = self.viewControllers![self.previousIndex] as! UINavigationController
            navigationVC.pushViewController(editCycleVc, animated: true)
        }
    }
    
    func openEditCycleVC(info: ViewPeriodTrackerModel?){
        let editCycleSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let editCycleVc = editCycleSB.instantiateViewController(withIdentifier: "EditCycleViewController") as? EditCycleViewController {
            editCycleVc.isEditScreen = false
           // if let editCycleInfo = info {
            editCycleVc.selectedDate = info?.periodDate?.toDate() ?? Date()
            print("period date: ", info?.periodDate?.toDate() ?? Date())
                
            editCycleVc.cycleLength = info?.cycleLength ?? 28
            editCycleVc.periodLength = info?.periodLength ?? 4
            editCycleVc.loginfo = info?.log
         //   }
            let navigationVC = self.viewControllers![self.previousIndex] as! UINavigationController
            navigationVC.pushViewController(editCycleVc, animated: true)
        }
    }
}

// MARK: - API Calling
extension TabBarController {
    private func getPeriodTracker() {
           APIManager.shared.getPeriodTracker { [weak self] (trackerInfo, message) in
               guard let weak = self else { return }
               if let info = trackerInfo {
                   
                   if info.id == nil {
                       weak.editCycleVC(info)
                   } else if let date = info.periodDate?.toDate(), let dateLast35Days = Calendar.current.date(byAdding: .day, value: -35, to: Date()) {
                       // date 35 days ago
                       let days = Calendar.current.dateComponents([.day], from: dateLast35Days, to: date).day ?? 0
                       if days < 0 {
                           weak.editCycleVC(info)
                           return
                       } else {
                           weak.openTrackerVC()
                           return
                       }
                   }
                   else {
                       weak.editCycleVC()
                       return
                   }
                   
                   print("period tracker info: \(info)")
                   //                print(info.toJSONString() ?? "")
                   Global.addNetcoreEvent(eventname: self!.netcoreEvents.periodTrackerUpdateClick, param: ["period_date":"\(info.periodDate)","cycle_length":"\(info.cycleLength)","period_length":"\(info.periodLength)","luteal_length":"\(info.lutealLength)", "user_id":"\(UserModel.user?.userId ?? 0)", "platform":"iOS"])
               }
               print(message)
           }
    }

    
    private func getPeriodTrackerV2(){
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(headers: headers, url: nil, service: .viewperiodtracker, method: .get, isJSONRequest: false).executeQuery {(result: Result<BaseResponse<ViewPeriodTrackerModel>, Error>) in
            switch result{
                
            case .success(let response):
                Global.hideIndicator()
                print("View period tracker: ", response.results)
                if response.results.id == nil{
                    
                    print("open edit cycle")
                    self.openEditCycleVC(info: response.results)
                }else if let date = response.results.periodDate?.toDate(), let dateLast35Days = Calendar.current.date(byAdding: .day, value: -35, to: Date()) {
                    
                    let days = Calendar.current.dateComponents([.day], from: dateLast35Days, to: date).day ?? 0
                    if days < 0 {
                        print("open edit cycle")
                        self.openEditCycleVC(info: response.results)
                        return
                    } else {
                        self.openTrackerVC()
                        return
                    }
                }
                else {
                    print("open edit cycle")
                    self.openEditCycleVC(info: response.results)
                    return
                }
                
                
                
                
                
            case .failure(let error):
                Global.hideIndicator()
                print("View periodTracker API failed: ", error)
            }
        }
    }
}

