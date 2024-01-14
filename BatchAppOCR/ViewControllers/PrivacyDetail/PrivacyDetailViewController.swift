//
//  PrivacyDetailViewController.swift
//  Batch4App
//
//  Created by Muhammad Yousaf on 03/06/2021.
//

import UIKit
import GoogleMobileAds
import WebKit

class PrivacyDetailViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !ViewModel().didPurchasedPro{
          //  bottomBannerConstraint.constant = 50
            bannerView.adUnitID = google_banner_id
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
          
        }else{
            bannerView.isHidden = true
           // bottomBannerConstraint.constant = 0
        }

    }

}
