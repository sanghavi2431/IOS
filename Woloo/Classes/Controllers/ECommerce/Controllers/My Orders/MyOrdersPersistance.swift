//
//  MyOrdersPersistance.swift
//  Woloo
//
//  Created by Rahul Patra on 31/08/21.
//

import Foundation

class MyOrdersPersistance {
    
    var myOrders: [MyOrder]?
    
    ///Getting My Products
    func getMyProducts(_ completion: @escaping FinalCompletion) {
        let id = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
        let params = ["user_id": "\(id)"]
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getMyOrders("\(id)"), params: [:], headers: [:], method: .get, completion: { [weak self]  result in
            switch result {
            case .success(let data):
                do {
                    let decodedJson = try JSONDecoder().decode(MyOrders.self, from: data)
                    self?.myOrders = decodedJson.first
                    completion(true, "Success")
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
    
    
    func returnOrderWithOrder(order: MyOrder?, completion: @escaping FinalCompletion) {
        let id = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .returnOrders("\(id)", "\(order?.orderID ?? "")"), params: [:], headers: [:], method: .get, completion: { [weak self]  result in
            switch result {
            case .success(let data):
                completion(true, "Success")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true) 
    }
}
