//
//  InAppPurchase.swift
//  VideoCopy
//
//  Created by ideveloper on 12/02/21.
//  Copyright © 2021 ideveloper3. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStoreKit
import StoreKit
import SystemConfiguration

class InAppPurchase: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate {
    
    static let shared = InAppPurchase()
    var productIDs: [String] = []
    var productsArray: [SKProduct] = []
    var identifer: String = ""
    var controllerOpen = UIViewController()
    let receiptURL = Bundle.main.appStoreReceiptURL
    var reciptProductId = ""
    var handleRestoreCompletion: ((_ status: Bool) -> Void)?
    
    
    #if DEBUG
    let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
    #else
    let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
    #endif
    
    func isApplicationUpgraded() -> Bool {
        #if DEBUG
        return true
        #endif
        let productPurchased = Utils.getDataFromUserDefault(Constant.NCINAPPPURCHASE) as? String ?? ""
        if productPurchased.isEmpty {
            return false
        }
        return true
    }
    
    /*func checkTransaction() {
     SwiftyStoreKit.completeTransactions(atomically: true) { products in
     for product in products {
     if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {
     if product.needsFinishTransaction {
     SwiftyStoreKit.finishTransaction(product.transaction)
     }
     print("purchased: \(product)")
     }
     }
     }
     }
     
     func checkReciptValidation(handler: @escaping((_ success: Bool) -> Void)) {
     if Utils.isConnectedToNetwork() {
     if let purchasedProduct = Utils.getDataFromUserDefault(Constant.NCINAPPPURCHASE) as? String {
     verifySubscriptionReceipt(productId: purchasedProduct) { (productId, _) in
     Utils.saveDataToUserDefault(productId, Constant.NCINAPPPURCHASE)
     handler(true)
     } errorHandler: { (_) in
     Utils.removeDataFromUserDefault(Constant.NCINAPPPURCHASE)
     handler(false)
     }
     }
     } else {
     Global.showAlert(title:  "", message: "No internet! Please connect again after internet back.")
     }
     }
     
     func retriveProducts(complition: @escaping((_ three: String, _ twelve: String, _ lifeTime: String) -> Void), errorHandler: @escaping((_ errorMessage: String) -> Void)) {
     SwiftyStoreKit.retrieveProductsInfo([Constant.NCINAPPPURCHASE, Constant.productIdentifierOneMonth]) { result in
     let products = result.retrievedProducts
     var threeMonths = ""
     var oneYear = ""
     var lifeTime = ""
     /* if let oneMonth = products.filter({ $0.productIdentifier == Constant.productIdentifierOneMonth }).first {
     let priceString = threeMonth
     threeMonths = priceString
     }*/
     
     /*if let year = products.filter({ $0.productIdentifier == productIdentifierOneYear }).first {
     let priceString = year.localizedPrice!
     oneYear = priceString
     }
     
     if let allTime = products.filter({ $0.productIdentifier == productIdentifierLifeTime }).first {
     let priceString = allTime.localizedPrice!
     lifeTime = priceString
     }*/
     
     if let invalidProductId = result.invalidProductIDs.first {
     errorHandler("Invalid product identifier: \(invalidProductId)")
     print("Invalid product identifier: \(invalidProductId)")
     } else if let error = result.error {
     errorHandler("Error: \(String(describing: error))")
     print("Error: \(String(describing: error))")
     } else {
     complition(threeMonths, oneYear, lifeTime)
     }
     }
     }
     
     func purchaseProduct(productId: String, complition: @escaping((_ message: String) -> Void), errorHandler: @escaping((_ message: String) -> Void)) {
     SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
     switch result {
     case .success(let product):
     if product.needsFinishTransaction {
     SwiftyStoreKit.finishTransaction(product.transaction)
     }
     complition("Purchase Successfully")
     print("Purchase Success: \(product.productId)")
     case .error(let error):
     var message = ""
     if let err = error.userInfo["NSUnderlyingError"] as? NSError, err.code == 3532 {
     complition("Restore Successfully")
     print("Restore Successfully")
     } else {
     switch error.code {
     case .unknown: message = "Unknown error. Please contact support at Woloo Admin"
     case .clientInvalid: message = "Not allowed to make the payment"
     case .paymentCancelled: break
     case .paymentInvalid: message = "The purchase identifier was invalid"
     case .paymentNotAllowed: message = "The device is not allowed to make the payment"
     case .storeProductNotAvailable: message = "The product is not available in the current storefront"
     case .cloudServicePermissionDenied: message = "Access to cloud service information is not allowed"
     case .cloudServiceNetworkConnectionFailed: message = "Could not connect to the network"
     case .cloudServiceRevoked: message = "User has revoked permission to use this cloud service"
     default: message = (error as NSError).localizedDescription
     }
     errorHandler(message)
     }
     }
     }
     }
     
     func restoreProduct(complition: @escaping((_ productId: String) -> Void), errorHandler: @escaping((_ message: String) -> Void)) {
     SwiftyStoreKit.restorePurchases(atomically: true) { results in
     if results.restoreFailedPurchases.count > 0 {
     print("Restore Failed: \(results.restoreFailedPurchases)")
     errorHandler("Restore Failed: \(results.restoreFailedPurchases)")
     } else if results.restoredPurchases.count > 0 {
     
     for product in results.restoredPurchases where product.needsFinishTransaction {
     SwiftyStoreKit.finishTransaction(product.transaction)
     }
     
     var isThereLifetimeProduct = false
     // Need to check if is there any lifetime in-app purchase or not.
     /*for product in results.restoredPurchases where product.productId == productIdentifierLifeTime {
     isThereLifetimeProduct = true
     }*/
     //complition(isThereLifetimeProduct ?  productIdentifierLifeTime: results.restoredPurchases.first?.productId ?? "")
     complition(results.restoredPurchases.first?.productId ?? "")
     print("Restore Success: \(results.restoredPurchases)")
     } else {
     errorHandler("Nothing to Restore")
     print("Nothing to Restore")
     }
     }
     }
     
     func verifySubscriptionReceipt(productId: String, complition: @escaping((_ productId: String, _ expireDate: Date) -> Void), errorHandler: @escaping((_ message: String) -> Void)) {
     #warning("WHEN YOU PUSH APP ON APPSTORE UPDATE THIS SANDBOX TO PRODUCTION")
     let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: Constant.inAppPurchaseReceiptValidationKey)
     SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
     switch result {
     case .success(let receipt):
     /*if productId == Constant.productIdentifierLifeTime { // lifetime plan - consumable in-app purchase
     let purchaseResult = SwiftyStoreKit.verifyPurchase(
     productId: productId,
     inReceipt: receipt)
     
     switch purchaseResult {
     case .purchased(let receiptItem):
     complition(productId, Date())
     print("\(productId) is purchased: \(receiptItem)")
     case .notPurchased:
     errorHandler("The user has never purchased \(productId)")
     print("The user has never purchased \(productId)")
     }
     } else { // subscription plan
     */   let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productId, inReceipt: receipt)
     
     switch purchaseResult {
     case .purchased(let expiryDate, let items):
     complition(productId, expiryDate)
     print("\(productId) is valid until \(expiryDate)\n\(items)\n")
     case .expired(let expiryDate, let items):
     errorHandler("\(productId) is expired since \(expiryDate)\n\(items)\n")
     print("\(productId) is expired since \(expiryDate)\n\(items)\n")
     case .notPurchased:
     errorHandler("The user has never purchased \(productId)")
     print("The user has never purchased \(productId)")
     }
     //}
     case .error(let error):
     print("Receipt verification failed: \(error)")
     }
     }
     }*/
    
    /* func productPurchaseMultiple(productIdentifier: [String], flgRestore: Bool, toGetPrice: Bool, controller: UIViewController) {
     //isToGetPrice = toGetPrice
     controllerOpen = controller
     let productID: NSSet = NSSet(array: productIdentifier)
     let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as? Set<String> ?? Set<String>() )
     productsRequest.delegate = self
     productsRequest.start()
     } */
    
    func productPurchase(productIdentifier: String, toGetPrice: Bool, controller: UIViewController) {
        // isToGetPrice = toGetPrice
        controllerOpen = controller
        identifer = productIdentifier
        let  productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: Set([productIdentifier as String]))
        productsRequest.delegate = self
        productsRequest.start()
        Global.showIndicator(isInteractionEnable: false)
    }
    func getAllProducts() {
        let  productsRequest: SKProductsRequest = SKProductsRequest()
        productsRequest.delegate = self
        productsRequest.start()
    }
    func restoreInAppPurchase() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequest
extension InAppPurchase {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print(response.invalidProductIdentifiers)
        print("----")
        print(response.products)
        let count: Int = response.products.count
        if count > 0 {
            SKPaymentQueue.default().add(self)
            let validProduct: SKProduct = response.products[0] as SKProduct
            if validProduct.productIdentifier ==  identifer {
                //Purchase/buy
                let payment = SKPayment(product: validProduct)
                SKPaymentQueue.default().add(payment)
            } else {
                print(validProduct.productIdentifier)
                Global.showAlert(title: "", message: "There is no product \(identifer) found. Contact Woloo Admin")
            }
        } else {
            Global.hideIndicator()
            print(response.invalidProductIdentifiers)
            Global.showAlert(title: "", message: "There are no valid products find to purchase or restore. Contact Woloo Admin")
        }
        
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error Fetching product information")
        Global.hideIndicator()
        
//        Global.showAlert(title: "", message:  "Cannot Fetch product information")
        //Flurry.logEvent("VC requestdidFailWithError", withParameters: ["reason": error.localizedDescription])
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var latestTransactionId = ""
        let tra = transactions.filter({ $0.transactionState == .purchased }).sorted(by: { $0.transactionDate?.timeIntervalSinceNow ?? 0 < $1.transactionDate?.timeIntervalSinceNow ?? 0 })
        if tra.count > 0 {
            latestTransactionId = tra.last?.transactionIdentifier ?? ""
        }
        
        for transaction: AnyObject in transactions {
            if let trans: SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("In App Payment Success")
                    if latestTransactionId == trans.transactionIdentifier {
                        // AJ
                        Global.hideIndicator()
                        // Woloo payment api.
                        // latestTransactionId // used first time when original object is null
                        let param: [String: Any] = ["productId": trans.payment.productIdentifier,
                                                    "transactionId": trans.original?.transactionIdentifier?.count ?? 0 > 0 ? trans.original?.transactionIdentifier ?? latestTransactionId :  latestTransactionId]
                        self.applePaymentSuccessAPI(param: param)
                        SKPaymentQueue.default().finishTransaction(transaction as? SKPaymentTransaction ?? SKPaymentTransaction())
                    }
                case .failed:
                    Global.hideIndicator()
                    SKPaymentQueue.default().finishTransaction(transaction as? SKPaymentTransaction ?? SKPaymentTransaction())
                    
                    let alert = UIAlertController(title: "", message: "Transaction cancelled or failed", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_: UIAlertAction!) in
                    }))
                    
                    controllerOpen.present(alert, animated: true, completion: nil)
                case .restored:
                    Global.hideIndicator()
                    let alert = UIAlertController(title: "", message: "You already have this subscription.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_: UIAlertAction!) in
                    }))
                    SKPaymentQueue.default().finishTransaction(transaction as? SKPaymentTransaction ?? SKPaymentTransaction())
                case .purchasing:
                    print("Purchasing")
                case .deferred:
                    Global.hideIndicator()
                    let alert = UIAlertController(title: "Waiting For Approval", message: "Thank you! You can continue to use Woloo while your purchase is pending an approval from Apple.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_: UIAlertAction!) in
                    }))
                    
                    
                default:
                    break
                }
            }
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("Error Fetching product information1\(error.localizedDescription)")
        //Utils.alert(message: error.localizedDescription)
        
        handleRestoreCompletion?(false)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("paymentQueueRestoreCompletedTransactionsFinished\(queue.transactions.debugDescription)")
        
        handleRestoreCompletion?(true)
        /* for transaction in queue.transactions {
         if transaction.payment.productIdentifier == productIdentifierLifeTime {
         self.setDataForInAppPurchase(transcationIdetifier: "Lifetime" as NSString)
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: NCINAPPPURCHASE), object: "You have restore successfully.")
         Flurry.logEvent("VC Restore Success", withParameters: [transaction.payment.productIdentifier: transaction.transactionIdentifier as Any])
         return
         }
         }
         
         if queue.transactions.count == 0 {
         Utils.alert(message: "You have not purchased lifetime earlier!!. Looking into subscription receipt...")
         //may be user subscribe and not used lifetime purchase
         self.refreshReceipt()
         }*/
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        
    }
    
    // MARK: - Receipt
    func getAppReceipt(completionHandler: ((Bool?, Error?) -> Void)? = nil) {
        /*  let productStatus = Utils.getDataFromUserDefault(Constant.NCINAPPPURCHASE) as? String ?? ""
         
         if productStatus == "Lifetime" {
         completionHandler?(true, nil)
         return
         }
         
         guard let receiptURL = receiptURL else {  /* receiptURL is nil, it would be very weird to end up here */  return }
         do {
         let receipt = try Data(contentsOf: receiptURL)
         receiptValidation(receipt, completionHandler: completionHandler)
         } catch {
         // there is no app receipt, don't panic, ask apple to refresh it
         refreshReceipt()
         }*/
    }
    
    func refreshReceipt() {
        let appReceiptRefreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
        appReceiptRefreshRequest.delegate = self
        appReceiptRefreshRequest.start()
    }
    func requestDidFinish(_ request: SKRequest) {
        // a fresh receipt should now be present at the url
        do {
            let receipt = try Data(contentsOf: receiptURL!) //force unwrap is safe here, control can't land here if receiptURL is nil
            receiptValidation(receipt, completionHandler: nil)
        } catch {
            // still no receipt, possible but unlikely to occur since this is the "success" delegate method
        }
    }
    
    func receiptValidation(_ receipt: Data, completionHandler: ((Bool?, Error?) -> Void)? = nil) {
        let base64encodedReceipt = receipt.base64EncodedString()
        let requestDictionary = ["receipt-data": base64encodedReceipt, "password": Constant.inAppPurchaseReceiptValidationKey]
        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, _, error) in
                if data == nil {
                    completionHandler?(false, error)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                    print("=======>", jsonResponse)
                    UserDefaults.standard.set("", forKey:"allowSubscriptionUpgrade")
                    UserDefaults.standard.synchronize()
                    //call API
                    if let arr = jsonResponse?["latest_receipt_info"] as?  [[String:Any]] {
                            if arr.count > 0 {
                                if let obj = arr.first {
                                    if let original_transaction_id = obj["original_transaction_id"] as? String {
                                        let param = ["original_transaction_id":original_transaction_id]
                                        self?.appleTransactionUserCheckAPI(param: param)
                                    }
                                }
                            }
                        }
                        
                        
                    } catch let parseError {
                        print(parseError)
                        completionHandler?(false, parseError)
                    }
                })
                task.resume()
            } catch let parseError {
                print(parseError)
                completionHandler?(false, parseError)
            }
        }
        private func applePaymentSuccessAPI(param: [String: Any]) {
            APIManager.shared.applePurhcaseAPI(param: param, showLoading: true) { (status, message) in
                if status {
                    NotificationCenter.default.post(name: NSNotification.Name.init("GetPlans"), object: nil, userInfo: nil)
                }
                if !status {
                    print(message)
                }
            }
        }
        private func appleTransactionUserCheckAPI(param: [String: Any]) {
            APIManager.shared.appleTransactionUserCheckAPI(param: param, showLoading: false) { (status, message, allowUser) in
                //set flag
                UserDefaults.standard.set(allowUser, forKey:"allowSubscriptionUpgrade")
                UserDefaults.standard.synchronize()
                
            }
        }
        
    }
    
    extension SKProduct {
        var localizedPrice: String? {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = priceLocale
            return formatter.string(from: price)
        }
        
    }
