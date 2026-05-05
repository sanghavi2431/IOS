//
//  Products+CoreDataClass.swift
//  Woloo
//
//  Created by Rahul Patra on 08/08/21.
//
//

import Foundation
import CoreData

@objc(LocalProducts)
public class LocalProducts: NSManagedObject {
    
    
    var isErrorShown: Bool = false
    var errorMessage: String?
    
    var getCouponAppliedPrice: Double {
        get {
            (((productPrice * Double(qty)) * coupon_value) / 100)
        }
    }
    
    var getDesc: String {
        get {
            "\(name ?? ""), Price: \(productPrice), Discount: \(getFinalPrice)"
        }
    }
    
    
    var getFinalPrice: Double {
        get {
            price.rounded()
        }
    }
    
    var getFinalusedCoins: Double {
        get {
            offPoints.rounded()
        }
    }
    
    func setAddPrice(withPoints points: inout Int, clientTotalCoins: Int = 0) {
        if isPointsUsed {
            var price = (productPrice * Double(qty)) - offPoints
            let productPrice = self.productPrice
            var usedCoin = offPoints
            var userCoins = points
            let productCoin = self.points
            
            //            for _ in (0..<Int(qty)) {
            //                if userCoins > Int(productCoin) {
            //                    price -= productCoin
            //                    usedCoin += Double(Int(productCoin))
            //                    points -= Int(Double(Int(productCoin)))
            //                    break
            //                } else {
            ////                        price += productPrice
            //                }
            //            }
            
            let cc = Double(clientTotalCoins) - usedCoin
            if !((Double(clientTotalCoins) - usedCoin) > productCoin) {
                self.price += productPrice
                self.offPoints = Double(usedCoin)
                self.price = price
                return
            }
            
            if points >= Int(productCoin) {
                price += (productPrice - productCoin)
                usedCoin += productCoin
                points -= Int(productCoin)
            } else {
                self.price += productPrice
            }
            //
            //
            
            self.offPoints = Double(usedCoin)
            self.price = price
        } else {
            self.price += productPrice
        }
    }
    
    func setMinusPrice(withPoints points: inout Int) {
        var productPrice = self.productPrice
        var usedCoing = offPoints
        var usedPrice = price
        var productCoin = self.points
        
        var usedCoinQty = (usedCoing / productCoin).rounded()
        
        
        //        if Int(qty) >= 1 {
        //
        //            if usedCoing >= productCoin {
        //                usedPrice -= (productPrice - productCoin)
        //                usedCoing -= productCoin
        //                points += Int(productCoin)
        //            } else {
        //                usedPrice -= productPrice
        //            }
        //
        ////            if Int(usedCoinQty) <= Int(qty) {
        ////
        ////            } else {
        ////
        ////            }
        //        }
        
        if Int(qty) >= 1 {
            
            if usedCoing >= productCoin {
                usedPrice -= (productPrice - productCoin)
                usedCoing -= productCoin
                points += Int(productCoin)
            } else {
                usedPrice -= productPrice
            }
        }
        
        
        
        
        self.price = usedPrice
        self.offPoints = usedCoing
    }
}
