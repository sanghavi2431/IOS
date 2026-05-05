//
//  AddAddressPersistance.swift
//  Woloo
//
//  Created by Rahul Patra on 09/08/21.
//

import Foundation


class AddAddressPersistance {
    
    //Save Address
    func saveAddressApi(andPhone phone: String = "", andPincode pincode: String, andCity city: String, andState state: String, andArea area: String, andFlatBuilding flatBuilding: String, andLandmark landmark: String, _ completion: @escaping FinalCompletion) {
        
        
        if pincode == "" {
            completion(false, "Please Enter Pincode")
            return
        }
        
        
        if city == "" {
            completion(false, "Please Enter City")
            return
        }
        
        if state == "" {
            completion(false, "Please Enter State")
            return
        }
        
        if area == "" {
            completion(false, "Please Enter Area")
            return
        }
        
        if flatBuilding == "" {
            completion(false, "Please Enter Flat No and Bulding Name")
            return
        }
        
        if landmark == "" {
            completion(false, "Please Enter Landmark")
            return
        }
        let uid = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
        let mobile = UserDefaults.standard.value(forKey: "user_mobile") as? String ?? ""
        let userName = UserDefaults.standard.value(forKey: "username_") as? String ?? ""
        
        let parameter = ["user_id": uid,
                         "name": userName,
                         "phone": mobile,
                         "pincode": pincode,
                         "city": city,
                         "state": state,
                         "area": area,
                         "flat_builing": flatBuilding,
                         "landmark": landmark] as [String:Any]
        
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .saveAddress, params: parameter, headers: [:], method: .post, completion: { result in
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8) ?? "")
                let addressToBeAdded = [flatBuilding, landmark , city , state , pincode].filter { $0 ?? "" != "" }.map { "\($0 ?? "")"}.joined(separator: ", ")
                //log
                let data: [String:Any] = ["mobile": mobile,
                            "items_in_shoping_cart": addressToBeAdded
                ]
                Global.addFirebaseEvent(eventName: "save_address", param: data)
                completion(true, "Success")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
}
