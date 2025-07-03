//
//  IAPManager.swift
//  Woloo
//
//  Created by Kapil Dongre on 26/07/24.
//

import Foundation
import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPManager()
    var products: [SKProduct] = []
    let productIdentifiers: Set<String> = [IAPProduct.oneMonthSubscription.rawValue]
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        for product in products {
            print("Product: \(product.localizedTitle), \(product.price)")
        }
    }
    
    func purchase(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User cannot make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
            case .failed:
                fail(transaction: transaction)
            case .restored:
                restore(transaction: transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                fatalError("Unknown transaction state")
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("Purchase complete")
        // Unlock the feature or content
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        print("Purchase restored")
        // Restore the feature or content
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        if let error = transaction.error as NSError? {
            print("Transaction failed: \(error.localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
