//
//  DelieveryAddressesPersistance.swift
//  Woloo
//
//  Created by Rahul Patra on 08/08/21.
//

import Foundation

class DelieveryAddressesPersistance {
    
    //MARK:- Variables
    var userData: ProfileMoreResponse?
    var address: Addresses?
    var userId = ""
    var selectedAddressCompletion: ((Address?) -> Void)?
    
    init() {
        let id = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
        self.userId = "\(id)"
    }
    
    //MARK:- Custom Functions
    //Get Address List
    func getAddressList(_ completion: @escaping FinalCompletion) {

        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getAddressList("\(userId)"), params: [:], headers: [:], method: .post, completion: { [weak self]  result in
            switch result {
            case .success(let data):
                do {
                    let decodedJson = try JSONDecoder().decode(Addresses.self, from: data)
                    self?.address = decodedJson
                    completion(true, "Success")
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
    
    func deleteAddress(address: Address?,  completion: @escaping FinalCompletion) {
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .deleteAddress(Int(address?.id ?? "0") ?? 0), params: [:], headers: [:], method: .get, completion: { [weak self]  result in
            switch result {
            case .success(let data):
                if String(data: data, encoding: .utf8) ?? "" == "1" {
                    completion(true, "Success")
                } else {
                    completion(true, "Something went wrong.")
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
}
