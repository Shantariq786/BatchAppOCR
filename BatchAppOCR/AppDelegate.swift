//
//  AppDelegate.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 19/01/2022.
//

import UIKit
import GoogleMobileAds
import Firebase
import SwiftyStoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
            SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
              for purchase in purchases {
                print(purchase)
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                  if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                  }
                case .failed, .purchasing, .deferred:
                  break
                }
              }
            }
            checkIfPurchaed()
        
        
        // check first time launch
        if isAppAlreadyLaunchedOnce() == true{
            //set counter to zero
            userClickUserDefault.value = 0
            PurchaseStatusUserDefualt.value = 0
        }
        
        
        guard #available(iOS 12, *) else { return true }
        self.intialController()
        
        
        return true
    }
    
    
    func intialController(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
            let homeVC = SplashViewController(nibName:String(describing: SplashViewController.self), bundle:nil)
            let homeNavigationController = UINavigationController.init(rootViewController: homeVC)
            window?.rootViewController = homeNavigationController // Your RootViewController in here
            window?.makeKeyAndVisible()
        
    }

    func isAppAlreadyLaunchedOnce()->Bool{
            let defaults = UserDefaults.standard
            
            if defaults.bool(forKey: "isAppAlreadyLaunchedOnce"){
                print("App already launched")
                return false
            }else{
                defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
                print("App launched first time")
                return true
            }
        }
    func checkIfPurchaed () {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
          switch result {
          case .success(let receipt):
            let purchaseResult = SwiftyStoreKit.verifySubscriptions(
              ofType: .autoRenewable,
              productIds: subscriptionPlansId,
              inReceipt: receipt)
            switch purchaseResult {
            case .purchased(let expiryDate, let items):
              print("\(items) is valid until \(expiryDate)\n\(items)\n")
                PurchaseStatusUserDefualt.value = 1
            case .expired(let expiryDate, let items):
                PurchaseStatusUserDefualt.value = 2
              print("\(items) is expired since \(expiryDate)\n\(items)\n")
            case .notPurchased:
              print("The user has never purchased")
                PurchaseStatusUserDefualt.value = 0
            }
          case .error(let error):
            print("Receipt verification failed: \(error)")
          }
        }
      }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

