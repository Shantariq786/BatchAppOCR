
import UIKit
import GoogleMobileAds
import Lottie

typealias AdDismissed = (()->())

class BaseViewController: UIViewController {
    
    @IBOutlet weak var bannerView:GADBannerView!
    
    @IBOutlet weak var bottomBannerConstraint:NSLayoutConstraint!
    
    var interstitial: GADInterstitialAd?
    var adDismissed:AdDismissed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        
//        interstitial = createAd()
        createAd()
    }
    
    @IBAction func goBack(){
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func goGallery(){
        
    //    let vc = GalleryViewController()
        // self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpAnimation(animationView:AnimationView,animationSpeed :CGFloat = 0.5 , isScaleToFit:Bool ){
        animationView.loopMode = .loop
        animationView.animationSpeed = animationSpeed
        if isScaleToFit == true{
            animationView.contentMode = .scaleAspectFill
        }
        
        animationView.play()
    }
    
    func showErrorAlert(title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showErrorAlertWithDismiss(title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createAd(){
        
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:google_interstial_id,
                                    request: request,
                          completionHandler: { [self] ad, error in
                            if let error = error {
                              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
//                              return nil
                            }
//            return ad
                            interstitial = ad
                          }
        )

//    let request = GADRequest()
//
//        let ad = GADInterstitialAd()
//        ad.adUnitID = google_interstial_id
////        let ad = GADInterstitial(adUnitID: google_interstial_id)
//        ad.delegate = self
//        ad.load(GADRequest())
//        return ad
    }
    
    func showAdAtClicked()->Bool{
        if PurchaseStatusUserDefualt.value == 1{
            userClickUserDefault.value = 0
        }else{
            userClickUserDefault.value = userClickUserDefault.value+1
        }
       
        if userClickUserDefault.value == totalAdsCount{
            //show ad
            if interstitial != nil{
                interstitial?.present(fromRootViewController: self)
                createAd()
            }
            
//            //show ad
//            if interstitial?.isReady == true {
//                interstitial?.present(fromRootViewController: self)
//                interstitial = createAd()
//            }
            userClickUserDefault.value = 0
            return true
        }else{
            return false
        }
    }
}
// MARK: -                  BANNERVIEW DElEGATE

extension BaseViewController: GADBannerViewDelegate{
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("AD Received")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("Fail To Receive AD: \(error.localizedDescription)")
    }
}


//MARK: -                   ADS DELEGETES
//extension BaseViewController:GADInterstitialAdDelegate{
//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        self.adDismissed!()
//        print("screen dismissed")
//    }
//}


