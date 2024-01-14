//
//  ExtractingTextViewController.swift
//  BatchAppOCR
//
//  Created by Hexacrew on 21/01/2022.
//

import UIKit
import Firebase
import Lottie
import PopupDialog
import MLKit
import MLKitTextRecognition
import MLKitTextRecognitionCommon
import GoogleMobileAds

import MLKitLanguageID
import MLKitTranslate
import NaturalLanguage

class ExtractingTextViewController: BaseViewController {
    
    @IBOutlet weak var loadingAnimation: AnimationView!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    
    lazy var languageId = LanguageIdentification.languageIdentification()

//    lazy var vision = Vision.vision()
//    var textDetector: VisionTextDetector?
//
    let textRecognizer = TextRecognizer.textRecognizer()
    var rewardedAd: GADRewardedAd?
    var number = 0
    var selectedImages = [UIImage]()
    var textArray = [String]()
    var totalImageConvertedCount = 0

    var popup:PopupDialog!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        
        // setting lottie
        loadingAnimation.isHidden = false
        setUpAnimation(animationView: loadingAnimation, isScaleToFit: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.loadingAnimation.isHidden = true
        }
        
       
        self.imagesCollectionView.register(UINib(nibName: "ExtractingTextColelctionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExtractingTextColelctionViewCell")
        
        textArray = Array(repeating: "", count: selectedImages.count)
        extractTextFromImagesArray()
        
        loadRewardAd()
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
    
    func extractTextFromImagesArray(){
        for i in 0..<selectedImages.count{
            detectText(image: selectedImages[i]) {[self] imageText in
                textArray[i] = imageText
                
                totalImageConvertedCount = totalImageConvertedCount+1
                
                // print when everything will be done
                if totalImageConvertedCount == selectedImages.count{
                    topTextView.text = textArray.joined(separator: "\n\n")
                }
            }
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        guard let langStr = Locale.current.languageCode else{return}
        
        if super.showAdAtClicked() == false{
            showAlertPopUp(headerText: "Do you want to go back?".localized(langStr), subHeaderText: "The process of extracting text from image will stop.".localized(langStr))
        }else{
            showAlertPopUp(headerText: "Do you want to go back?".localized(langStr), subHeaderText: "The process of extracting text from image will stop.".localized(langStr))
        }
    }
    
    @IBAction func languageChangeBtn(_ sender: UIButton) {
        
        showAlert {
            let vc = LanguageSelectionViewController()
            vc.extractedText = self.topTextView.text
            self.navigationController?.modalPresentationStyle = .overCurrentContext
            self.navigationController?.modalTransitionStyle = .crossDissolve

            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    func showAlert(completion:@escaping()->Void){
        // create the alert
        let alert = UIAlertController(title: "Alert", message: "It would user internet data around 30MB per language.", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK, CONTINUE", style: UIAlertAction.Style.default, handler: { action in

            // do something like...
            completion()

        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
   
    @IBAction func topPDFBtnTapped(_ sender: Any) {
        number = 1
        if PurchaseStatusUserDefualt.value != 1{
            showRewardAd()
        }else{
            saveFile()
        }
    }
    
    @IBAction func topDocxBtnTapped(_ sender: Any) {
        number = 2
        if PurchaseStatusUserDefualt.value != 1{
            showRewardAd()
        }else{
            saveFile()
        }
    }
    
    @IBAction func toTextBtnTapped(_ sender: Any) {
        number = 3
        if PurchaseStatusUserDefualt.value != 1{
            showRewardAd()
        }else{
            saveFile()
        }
    }
    
    func saveFile(){
        if number == 1{
            createPDF(text: topTextView.text) {
                self.showAlertWithMassage("SUCCESS", "PDF file saved successfully")
            }
        }else if number == 2{
            CreateDoc(text: topTextView.text) {
                self.showAlertWithMassage("SUCCESS", "DOCX file saved successfully")
            }
        }else if number == 3{
            CreateTextFile(text: topTextView.text) {
                self.showAlertWithMassage("SUCCESS", "TEXT file saved successfully")
            }
        }
    }
    
    func showAlertPopUp(headerText:String,subHeaderText:String){
        
        let timePicker = AlertPopUpViewController(nibName: "AlertPopUpViewController", bundle: nil)
        popup = PopupDialog(viewController: timePicker, buttonAlignment: .horizontal, transitionStyle: .fadeIn, tapGestureDismissal: false,panGestureDismissal: false)

        
        timePicker.setUpData(headerText: headerText, subHeaderText: subHeaderText, animation: "remove-button")
        timePicker.noButton.addTarget(self, action: #selector(dismisspopup), for: .touchUpInside)
        timePicker.yesButton.addTarget(self, action: #selector(yesAction), for: .touchUpInside)
        present(popup, animated: true, completion: nil)
        
    }
    
    @objc func dismisspopup(){
        
        if super.showAdAtClicked() == false{
            popup.dismiss()
        }else{
            super.adDismissed = { [self] in
                popup.dismiss()
            }
        }
    }
    
    @objc func yesAction(){
        
        if super.showAdAtClicked() == false{
            popup.dismiss()
            self.navigationController?.popViewController(animated: true)
        }else{
            super.adDismissed = { [self] in
                popup.dismiss()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}


//MARK: -                        COLLECTIONVIEW PROTOCOLS
extension ExtractingTextViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtractingTextColelctionViewCell", for: indexPath) as! ExtractingTextColelctionViewCell
        cell.imageview.image = selectedImages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped at \(indexPath)")

       topTextView.text = textArray[indexPath.row]
     
    }
}


//MARK: -                           REWARD ADD DELEGATE

//extension ExtractingTextViewController: GADRewardedAdDelegate{
//
//    /// Tells the delegate that the user earned a reward.
//    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
//      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
//    }
//    /// Tells the delegate that the rewarded ad was presented.
//    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
//      print("Rewarded ad presented.")
//    }
//    /// Tells the delegate that the rewarded ad was dismissed.
//
//    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
//      print("Rewarded ad dismissed.")
//
//        saveFile()
//
//        //load ad again
////        self.rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
//        loadRewardAd()
//
//
//    }
//
//    /// Tells the delegate that the rewarded ad failed to present.
//    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
//      print("Rewarded ad failed to present.")
//    }
//}

//MARK: -                             TEXTVIEW DELEGETES
extension ExtractingTextViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if topTextView.textColor == UIColor.lightGray {
            topTextView.text = nil
            topTextView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if topTextView.text.isEmpty {
            topTextView.text = "Tap Image to edit Text"
            topTextView.textColor = UIColor.lightGray
        }
    }
}


// MARK: -                              DETEXT TEXT
extension ExtractingTextViewController{
//    func detectText (image: UIImage, completion:@escaping (String)->Void){
//
//        textDetector = vision.textDetector()
//        let visionImage = VisionImage(image: image)
//
//        textDetector?.detect(in: visionImage) { (features, error) in
//            guard error == nil, let features = features, !features.isEmpty else {
//                return
//            }
//            debugPrint("Feature blocks in th image: \(features.count)")
//
//            var detectedText = [String]()
//            for feature in features {
//                let value = feature.text
//                detectedText.append("\(value) ")
//            }
//            print("detectedText \(detectedText)")
//            completion(detectedText.joined(separator: "\n"))
//        }
//    }
    
    
    
    func detectText (image: UIImage, completion:@escaping (String)->Void){
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { result, error in
         guard error == nil, let result = result else {
          // Error handling
          return
         }
         // Recognized text
          completion(result.text)
        }
      }
}
