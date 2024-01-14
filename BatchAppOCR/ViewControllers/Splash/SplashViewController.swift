//
//  SplashViewController.swift
//  Batch4App
//
//  Created by Muhammad Yousaf on 20/04/2021.
//


import UIKit
import Lottie

class SplashViewController: BaseViewController{

    @IBOutlet weak var backGroundAnimation:AnimationView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setUpAnimation(animationView: backGroundAnimation, isScaleToFit: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {

            let vc = ChooseImageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
