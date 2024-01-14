//
//  EnhanceImageViewController.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 21/01/2022.
//

import UIKit
import GoogleMobileAds

protocol ImageSendingProtocol {
    func imageSending(image:UIImage,index:Int)
}

class EnhanceImageViewController: BaseViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var enhanceImageSetDelegate:EnhanceImageSetDelegate?
    var editedImageSetDelegate:EditedImageSetDelegate?
    var index: Int?
    
    var origionalImage:UIImage!
    var context = CIContext(options: nil)
    var imageSendingProtocol : ImageSendingProtocol!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        imageView.image = image
        origionalImage = imageView.image
        
    }
    
    @IBAction func rotateImageBtn(_ sender: UIButton) {
        
        if super.showAdAtClicked() == false{
            let rotatedImage = imageView.image?.rotate(radians: .pi / 2 )
            imageView.image = rotatedImage
            
        }else{
            super.adDismissed = { [self] in
                let rotatedImage = imageView.image?.rotate(radians: .pi / 2 )
                imageView.image = rotatedImage
            }
        }
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
       
        imageSendingProtocol.imageSending(image: imageView.image ?? image, index: index!)
        if PurchaseStatusUserDefualt.value != 1{
            // show ad
//            if super.interstitial?.isReady == true {
//                interstitial?.present(fromRootViewController: self)
//                userClickUserDefault.value = 0
//            }
            
            if interstitial != nil{
                interstitial?.present(fromRootViewController: self)
                userClickUserDefault.value = 0
            }
        }
        
        // dismiss the screens
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if(aViewController is ChooseImageViewController){
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    @IBAction func goBackCustom(_ sender: UIButton) {
        if super.showAdAtClicked() == false{
            self.navigationController?.popViewController(animated: true)
        }else{
            super.adDismissed = { [self] in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func originalImageBtn(_ sender: UIButton) {
        
        if super.showAdAtClicked() == false{
            imageView.image = origionalImage
        }else{
            super.adDismissed = { [self] in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func blackandwhiteBtn(_ sender: UIButton) {
        
        if super.showAdAtClicked() == false{
            let image = imageView.image?.ImageBlackandWhite(image: imageView.image!, completion: { image in
                self.imageView.image = image
            })
        }else{
            super.adDismissed = { [self] in
                let image = imageView.image?.ImageBlackandWhite(image: imageView.image!, completion: { image in
                    self.imageView.image = image
                })
            }
        }
    }
    
    @IBAction func imageMagicBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func imageGrayscaleBtn(_ sender: UIButton) {
        
        if super.showAdAtClicked() == false{
            let image = imageView.image?.ImageGrayScale(image: imageView.image!, completion: { image in
                self.imageView.image = image
            })
        }else{
            super.adDismissed = { [self] in
                let image = imageView.image?.ImageGrayScale(image: imageView.image!, completion: { image in
                    self.imageView.image = image
                })
            }
        }
    }
}


protocol EnhanceImageSetDelegate {
    func sendBackManualImage(image:UIImage)
}
