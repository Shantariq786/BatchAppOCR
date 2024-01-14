//
//  AlertPopUpViewController.swift
//  Batch4App
//
//  Created by Muhammad Yousaf on 11/05/2021.
//

import UIKit
import Lottie

class AlertPopUpViewController: BaseViewController {
    
    @IBOutlet weak var noButton:UIButton!
    @IBOutlet weak var yesButton:UIButton!
    @IBOutlet weak var headerLabel:UILabel!
    @IBOutlet weak var subHeaderLabel:UILabel!
    @IBOutlet weak var animationView:AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpAnimation(animationView: animationView, isScaleToFit: false)
    }

    func setUpData(headerText:String,subHeaderText:String,animation:String){
        self.headerLabel.text = headerText
        self.subHeaderLabel.text = subHeaderText
        //alert-animation
        if let animation = Animation.named(animation){
            animationView.animation = animation
            animationView.loopMode = .loop
            animationView.animationSpeed = 1
            animationView.play()
        }
    }
    

}
