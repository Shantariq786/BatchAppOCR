

import Foundation
struct  userDefaultNames {
    struct Keys {
        static let userDataUserDefaultName = "clickCount"
        static let purchaseStatusUserDefualtName = "purchaseStatus"
    }
}


struct userClickUserDefault {
    static let keyforLaunch = userDefaultNames.Keys.userDataUserDefaultName
    static var value: Int {
        get {
            return UserDefaults.standard.integer(forKey: keyforLaunch)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyforLaunch)
        }
    }
}



struct PurchaseStatusUserDefualt {
    static let keyforLaunch = userDefaultNames.Keys.purchaseStatusUserDefualtName
    static var value: Int {
        get {
            return UserDefaults.standard.integer(forKey: keyforLaunch)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyforLaunch)
        }
    }
}
