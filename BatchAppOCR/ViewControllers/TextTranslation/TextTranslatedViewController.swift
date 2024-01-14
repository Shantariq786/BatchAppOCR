//
//  TextTranslatedViewController.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 08/02/2022.
//

import UIKit
import MLKit
import MLKitLanguageID
import NaturalLanguage
import GoogleMobileAds


class TextTranslatedViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var textView:UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var number = 0
    var extractedText: String = ""
    var titleheader:String = ""
    var rewardedAd: GADRewardedAd?

    var options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .german)
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        loadRewardAd()

        titleLabel.text = "Translate to  \(titleheader)"
        let translator = Translator.translator(options: options)
        translator.translate(extractedText) { text, error in
            if let err = error{
                print(err.localizedDescription)
                return
            }
            print("text ",text ?? "")
            self.textView.text = text
        }
    }
    func loadRewardAd(){
        //setting reward ad
        
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: rewardVideoId, request: request) { rewardAd, error in
            if let error = error {
              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
            }
            self.rewardedAd = rewardAd
          }
    }
    func showRewardAd(){
        
      if rewardedAd != nil {
            rewardedAd?.present(fromRootViewController: self, userDidEarnRewardHandler: {
                self.saveFile()
                self.loadRewardAd()
            })
            userClickUserDefault.value = 0
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func PDFBtnTapped(_ sender: Any) {
        number = 1
        if PurchaseStatusUserDefualt.value != 1{
            showRewardAd()
        }else{
            saveFile()
        }
        
    }
    
    @IBAction func DocxBtnTapped(_ sender: Any) {
        number = 2
        if PurchaseStatusUserDefualt.value != 1{
            showRewardAd()
        }else{
            saveFile()
        }
    }
    
    @IBAction func TextBtnTapped(_ sender: Any) {
        number = 3
        if PurchaseStatusUserDefualt.value != 1{
            showRewardAd()
        }
        else{
            saveFile()
        }
    }
    
    func saveFile(){
        if number == 1{
            createPDF(text: textView.text) {
                self.showAlertWithMassage("SUCCESS", "PDF file saved successfully")
            }
        }
        else if number == 2{
            CreateDoc(text: textView.text) {
                self.showAlertWithMassage("SUCCESS", "DOCX file saved successfully")
            }
        }
        else if number == 3{
            CreateTextFile(text: textView.text) {
                self.showAlertWithMassage("SUCCESS", "TEXT file saved successfully")
            }
        }
    }
}
