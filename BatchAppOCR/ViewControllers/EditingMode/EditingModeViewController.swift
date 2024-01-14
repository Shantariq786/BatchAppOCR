//
//  EditingViewViewController.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 19/01/2022.
//

import UIKit
import CropViewController
import Alamofire
import GoogleMobileAds

class EditingModeViewController: BaseViewController {
   
    @IBOutlet weak var imageView:UIImageView!

    var adIncrement = 0
    var updateImageIndex:Int?
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    var image:UIImage?
    var uneditedImage:UIImage?
    var imageProtocol:ImageSendingProtocol!
    
    var editedImageSetDelegate:EditedImageSetDelegate?

    //private var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.imageView.image = image
        self.uneditedImage = self.image
    }
   
    @IBAction func goBackCustom(){

        if super.showAdAtClicked() == false{
            goBackButton()
        }else{
            super.adDismissed = { [self] in
                goBackButton()
            }
        }
    }
    func goBackButton(){
        if self.editedImageSetDelegate != nil {
            if let image = self.image,
               let updateIndex = self.updateImageIndex{
                self.editedImageSetDelegate?.sendBackEditedImage(image: image, updateIndex: updateIndex)
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }

    // ENHANCE Button
    @IBAction func EnhanceImage(_ sender: UIButton) {
        
        if super.showAdAtClicked() == false{
            moveToEnhanceScreen()
        }else{
            super.adDismissed = { [self] in
                moveToEnhanceScreen()
            }
        }
    }
    func moveToEnhanceScreen(){
      //  print("INDEX: - \(String(describing: updateImageIndex))")
        let vc = EnhanceImageViewController()
        vc.image = self.image!
        vc.index = updateImageIndex
        //vc.enhanceImageSetDelegate = self
        vc.imageSendingProtocol = imageProtocol
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    @IBAction func shareImage(_ sender: UIButton) {
        
        if super.showAdAtClicked() == false{
            shareTheImage(sender)
        }else{
            shareTheImage(sender)
        }
    }
    func shareTheImage(_ sender:UIButton){
            let imageShare = [ self.image! ]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = sender
            self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func exportImage(_ sender: UIButton) {
        if super.showAdAtClicked() == false{
            UIImageWriteToSavedPhotosAlbum(self.image!, nil, nil, nil)
        }else{
            super.adDismissed = { [self] in
                UIImageWriteToSavedPhotosAlbum(self.image!, nil, nil, nil)
            }
        }
    }
    
    @IBAction func rotate(){
        
        if super.showAdAtClicked() == false{
            rotateImage()
        }else{
            super.adDismissed = { [self] in
                rotateImage()
            }
        }
    }
    func rotateImage(){
        if let img = self.image{
            let rotatedImage = img.myRotate(radians: .pi/2)

            self.image = rotatedImage
            self.imageView.image = rotatedImage
            layoutImageView()
    }
}
 
    @IBAction func cropViewController(){
        //        let vc = CropImageViewController()
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        // When tapping the image view, restore the image to the previous cropping state
        let cropViewController = CropViewController(croppingStyle: .default, image: self.image!)
        cropViewController.delegate = self
        let viewFrame = view.convert(imageView.frame, to: navigationController!.view)
        
        cropViewController.presentAnimatedFrom(self,
                                               fromImage: self.imageView.image,
                                               fromView: nil,
                                               fromFrame: viewFrame,
                                               angle: self.croppedAngle,
                                               toImageFrame: self.croppedRect,
                                               setup: { self.imageView.isHidden = true },
                                               completion: nil)
        
        
        
    }
}

// MARK: - Extensions


extension EditingModeViewController:CropViewControllerDelegate{
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
        imageView.isHidden = false
        self.imageView.image = image

    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        imageView.image = image
        self.image = image
        layoutImageView()
         
        
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
            imageView.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: imageView,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: {
                                                    self.imageView.isHidden = false })
        }
        else {
            self.imageView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }

    public func layoutImageView() {
        guard imageView.image != nil else { return }
        
        let padding: CGFloat = 20.0
        
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))
        
        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;
        
        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        }
        else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
}

extension EditingModeViewController{
    
    func downloadImages(imageView:UIImageView,image:UIImage){
        
        let httpHeaders: HTTPHeaders = ["Content-Type" : "multipart/form-data"]
        
        let body:[String:Any] = ["post_image":image]
        
        AF.upload(multipartFormData: { (multiPart) in
            for (key, value) in body{
                //Check for String Data
                if let temp = value as? String {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                //Check for Int Data
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                
                //Check for Boolean Values
                if let temp = value as? Bool{
                    multiPart.append(temp.description.data(using: .utf8)!, withName: key)
                }
                //Check for Arrays
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
                //Check for Images
                if let temp = value as? UIImage{
                    if let jpegImage = temp.jpegData(compressionQuality: 1){
                        multiPart.append(jpegImage, withName: key, fileName: "\(String(Date().timeIntervalSince1970)).jpeg", mimeType: "image/jpeg")
                    }
                }
            }
        }, to: "https://batchapps.net/api/uload2.php", method: .post, headers: httpHeaders).uploadProgress(queue: .main) { (progress) in
            print("Upload Progress \(progress.fractionCompleted)")
        }.response { (response) in
            // response.description
            
            if let error = response.error{
                self.showErrorAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            if let data = response.data{
                if let image = UIImage(data: data){
                    self.image = image
                    imageView.image = image
                }else{
                    self.image = image
                    imageView.image = image
                }
            }else{
                print("Data Not Found")
            }
        }
    }
}

extension UIImage {
    func myRotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

extension EditingModeViewController:EnhanceImageSetDelegate{
    func sendBackManualImage(image: UIImage) {
        self.image = image
        self.imageView.image = image
    }
}

protocol EditedImageSetDelegate {
    func sendBackEditedImage(image:UIImage,updateIndex:Int)
}

