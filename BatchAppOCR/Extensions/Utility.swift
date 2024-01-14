//
//  Utility.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 19/01/2022.
//

import Foundation
import UIKit
import StoreKit

var context = CIContext(options: nil)


func showShareActivity(msg:String?, image:UIImage?, url:String?, sourceRect:CGRect?){
    var objectsToShare = [AnyObject]()

    if let url = url {
        objectsToShare = [url as AnyObject]
    }

    if let image = image {
        objectsToShare = [image as AnyObject]
    }

    if let msg = msg {
        objectsToShare = [msg as AnyObject]
    }

    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    activityVC.modalPresentationStyle = .popover
    activityVC.popoverPresentationController?.sourceView = topViewController().view
    if let sourceRect = sourceRect {
        activityVC.popoverPresentationController?.sourceRect = sourceRect
    }

    topViewController().present(activityVC, animated: true, completion: nil)
}



func topViewController()-> UIViewController{
    var topViewController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!

    while ((topViewController.presentedViewController) != nil) {
        topViewController = topViewController.presentedViewController!;
    }

    return topViewController
}



func rateApp() {
    if #available(iOS 10.3, *) {
        SKStoreReviewController.requestReview()

    } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

        } else {
            UIApplication.shared.openURL(url)
        }
    }
}



extension UIColor {
    
    /** Color with Red green and Blue */
    static func colorWithRGB(_ redValue: CGFloat, _ greenValue: CGFloat, _ blueValue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
    
    /** Color with Hex value */
    static func colorWithHex(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(intFromHexString(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    static func intFromHexString(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

extension UIImage{
    
    func ImageBlackandWhite(image: UIImage,completion:@escaping(UIImage)->Void){
        
        guard let currentCGImage = image.cgImage else { return }
        let currentCIImage = CIImage(cgImage: currentCGImage)
        var newimage = image
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")
        
        // set a gray value for the tint color
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        
        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return }
        
        let context = CIContext()
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            var processedImage = UIImage(cgImage: cgimg)
            newimage = processedImage
            completion(newimage)
        }
    }
    
    func ImageGrayScale(image: UIImage,completion:@escaping(UIImage)->Void){
        
        //Auto Adjustment to Input Image
        var inputImage = CIImage(image: image)
        let _:[String : AnyObject] = [CIDetectorImageOrientation:1 as AnyObject]
        let filters = inputImage!.autoAdjustmentFilters()
        var newimage = image
        for filter: CIFilter in filters {
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            inputImage =  filter.outputImage
        }
        let cgImage = context.createCGImage(inputImage!, from: inputImage!.extent)
        newimage = UIImage(cgImage: cgImage!)
        
        //Apply noir Filter
        let currentFilter = CIFilter(name: "CIPhotoEffectTonal")
        currentFilter!.setValue(CIImage(image: UIImage(cgImage: cgImage!)), forKey: kCIInputImageKey)
        
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        newimage = processedImage
        completion(newimage)
    }
}



var hasNotch: Bool {
    let bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    return bottom > 0
}

let google_banner_id = "ca-app-pub-3912056127123695/4010940771"
let google_interstial_id = "ca-app-pub-3912056127123695/5529720783"
let rewardVideoId = "ca-app-pub-3912056127123695/6138410660"


func getFileName(url:URL)->String{
    let stringUrl = url.absoluteString
    let dataArray = stringUrl.components(separatedBy: "/")
    return dataArray[dataArray.count-1]
}






