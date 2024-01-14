//
//  UpgradeAppViewController.swift
//  Batch4App
//
//  Created by Muhammad Yousaf on 19/05/2021.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import SVProgressHUD

class UpgradeAppViewController: BaseViewController ,InAppPurchaseDelegate{
    
    
    
    var iAPHelper = IAPHelper()
    @IBOutlet var monthlyBtn: UIButton!
    @IBOutlet var yearlyBtn: UIButton!
    var selectedBtnIndex = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iAPHelper.getIAPlocalPrice()
        iAPHelper.delegate = self
        
        updateDesgin(index: selectedBtnIndex)
    }
    
    
    func updateDesgin(index: Int){
        if index == 0 {
            monthlyBtn.backgroundColor = UIColor.lightGray
            monthlyBtn.layer.borderColor = UIColor.lightGray.cgColor
            monthlyBtn.setTitleColor( UIColor.black , for: .normal)
            
            yearlyBtn.backgroundColor = UIColor.clear
            yearlyBtn.setTitleColor(UIColor.black, for: .normal)
            yearlyBtn.layer.borderColor = UIColor.lightGray.cgColor
            yearlyBtn.layer.borderWidth = 1
            
        }else if index == 1{
            yearlyBtn.backgroundColor = UIColor.lightGray
            yearlyBtn.layer.borderColor = UIColor.lightGray.cgColor
            yearlyBtn.setTitleColor( UIColor.black , for: .normal)
            
            
            monthlyBtn.backgroundColor = UIColor.clear
            monthlyBtn.setTitleColor(UIColor.black, for: .normal)
            monthlyBtn.layer.borderColor = UIColor.lightGray.cgColor
            monthlyBtn.layer.borderWidth = 1
            
            
        }
    }
    
    
    // MARK: - IBAction Methods
    
    
    
    @IBAction func restorePurchases(_ sender: Any) {
        iAPHelper.restorePurchase()
    }
    
    @IBAction func upgradeApplication(_ sender: Any) {
        //showHud()
        iAPHelper.purchase()
    }
    
    
    @IBAction func monthlySubcribtionBtn(_ sender: UIButton) {
        self.iAPHelper.selectedProductID = monthlySubscriptionId
        updateDesgin(index: 0)
    }
    
    @IBAction func yearlySubcribtionBtn(_ sender: UIButton) {
        self.iAPHelper.selectedProductID = yearlySubscriptionId
        updateDesgin(index: 1)
        
    }
    
}


extension UpgradeAppViewController{
    func restoreDidSucceed() {
        hideHud()
        PurchaseStatusUserDefualt.value = 1
        //MoveToNextScreen()
    }
    func purchaseDidSucceed() {
        hideHud()
        PurchaseStatusUserDefualt.value = 1
        //MoveToNextScreen()
    }
    func nothingToRestore() {
        self.showToast(message: "There is nothing to restore", font: .systemFont(ofSize: 12.0))
    }
    func paymentCancelled() {
        self.showToast(message: "The payment got cancelled", font: .systemFont(ofSize: 12.0))
    }
    func unknowErrorOccur() {
        self.showToast(message: "Unknow error occur", font: .systemFont(ofSize: 12.0))
    }
    
    func returnProduct(product: SKProduct) {
        guard let currencySymbol = product.priceLocale.currencySymbol else {
            return
        }
        print("currencySymbol \(currencySymbol)")
        let originalPrice = (product.price as Decimal * 2.0)
        print("originalPrice \(originalPrice)")
        let priceString = product.localizedPrice!
        let price = priceString
        
        if product.productIdentifier.contains("yearly"){
            let attributedString = NSAttributedString.composing {
              NSAttributedString(string: "\(currencySymbol)\(originalPrice)", attributes: [.strikethroughStyle : NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.colorWithHex(hexString: "#000000", alpha: 0.4), .font: UIFont.systemFont(ofSize: 12, weight: .semibold)])
              NSAttributedString(string: "\(price)/Year" , attributes: [.foregroundColor: UIColor.colorWithHex(hexString: "#000000"), .font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
            }
            self.yearlyBtn.setAttributedTitle(attributedString, for: .normal)
        }
        else{
            self.monthlyBtn.setTitle("\(price)/Month", for: .normal)
        }
    }
}


@_functionBuilder
public class NSAttributedStringBuilder {
    public static func buildBlock(_ components: NSAttributedString...) -> NSAttributedString {
        let result = NSMutableAttributedString(string: "")

        return components.reduce(into: result) { (result, current) in result.append(current) }
    }
}

extension NSAttributedString {
    public class func composing(@NSAttributedStringBuilder _ parts: () -> NSAttributedString) -> NSAttributedString {
        return parts()
    }
}
