//
//  Model.swift
//  Batch4App
//
//  Created by Muhammad Yousaf on 19/05/2021.
//

import Foundation
import StoreKit

class Model {
    
    struct GameData: Codable, SettingsManageable {
//        var extraLives: Int = 0
//        
//        var superPowers: Int = 0
//        
////        var didUnlockAllMaps = false
        var didPurchasePro = false
    }
    
    var gameData = GameData()
    var products = [SKProduct]()
    
    
    init() {
        _ = gameData.load()
    }
    
    
    func getProduct(containing keyword: String) -> SKProduct? {
        return products.filter { $0.productIdentifier.contains(keyword) }.first
    }
}
