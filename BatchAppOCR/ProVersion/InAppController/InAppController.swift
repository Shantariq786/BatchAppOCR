//
//  InAppController.swift
//  Batch4App
//
//  Created by Muhammad Yousaf on 19/05/2021.
//

import Foundation
import StoreKit
import SwiftyStoreKit

public typealias ProductIdentifier = String

class IAPController: NSObject{
    static let shared = IAPController()
    
    var product = SKProduct()
    var localizedProduct = String()
    var localizedProductDescription = String()
    var localizedPrice = String()
    let sharedSecret = "ac2792ed813b444da2b22ef167784fd0"
    
    let productIDsNonRenewing = ["com.batchapps.ocrdocumentcreator.monthly"]
    
//    let productIDsNonRenewingTurkey = ["nl.tirato.RoomEasy.oneWeekPremiumSubsciptionPackageTurkey","nl.tirato.RoomEasy.oneMonthPremiumSubscriptionPackageTurkey","nl.tirato.RoomEasy.threeMonthPremiumSubscriptionPackageTurkey"]
    
    var products = [SKProduct]()
    
    enum IAPControllerError: Error {
        case noProductIDsFound
        case noProductsFound
        case paymentWasCancelled
        case productRequestFailed
    }
    
    private override init() {
        super.init()
    }
    
    func retrieveProductInfo(productId: String,completion:@escaping ((SKProduct) -> ()))
    {
        SwiftyStoreKit.retrieveProductsInfo([productId])
        { (result) in
            if let product = result.retrievedProducts.first
            {
                completion(product)
                self.product = product
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
        
//        SwiftyStoreKit.retrieveProductsInfo(productIDsNonRenewing) { (retriveResults) in
//
//            for retriveProduct in retriveResults.retrievedProducts{
//
//                print("product re",retriveProduct.localizedTitle)
//                self.products.append(retriveProduct)
//
//
//
//
//
////                self.products.sort {
////                    $0.
////                }
////
//            }
//
//
//
//        }
        
        
        
        
//        for productId in productIDsNonRenewing{
//            SwiftyStoreKit.retrieveProductsInfo([productId]) { result in
//                if let product = result.retrievedProducts.first {
//
//                    print("product Id re",productId)
//                    print("product re",product.localizedTitle)
//                    self.products.append(product)
//
//                    print("sare products: ", self.products)
//
////                    let priceString = product.localizedPrice!
////                    self.product = product
////                    self.localizedProduct = product.localizedTitle
////                    self.localizedProductDescription = product.localizedDescription
////                    self.localizedPrice = priceString
////                    print("Product: \(product), price: \(priceString)")
//                }
//                else if let invalidProductId = result.invalidProductIDs.first {
//                    print("Invalid product identifier: \(invalidProductId)")
//                }
//                else {
//                    print("Error: \(result.error)")
//                }
//            }
//        }
    }
    
    
    func purchase(completion: @escaping (Result<Any, Error>) -> Void)
    {
        print("produc re: ",product)
        
        
        SwiftyStoreKit.purchaseProduct(product, atomically: true) { result in
            
            
            if case .success(let purchase) = result
            {
                // Deliver content from server, then:
                print("subscription success")
                
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                
                completion(.success(true))

            } else if case .error(let error) = result{
                completion(.failure(error))
            }
        }
    }
}

extension IAPController.IAPControllerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
        case .noProductsFound: return "No In-App Purchases were found."
        case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
        case .paymentWasCancelled: return "In-App Purchase process was cancelled."
        }
    }
}
