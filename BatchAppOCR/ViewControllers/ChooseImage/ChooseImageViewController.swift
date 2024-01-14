//
//  HomeViewController.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 19/01/2022.
//

import UIKit
import BSImagePicker
import Photos
import GoogleMobileAds
import Lottie
import PopupDialog
import FirebaseCrashlytics

class ChooseImageViewController: BaseViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var autoRemoveBtn:UIButton!
    @IBOutlet weak var removeAllBtn:UIButton!

    @IBOutlet weak var headerLabel:UILabel!
    @IBOutlet weak var headerImage:UIImageView!
    @IBOutlet weak var subHeaderLabel:UILabel!

    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var showDocumentButton:UIButton!
    
    @IBOutlet weak var bannerViewHeight: NSLayoutConstraint!
    
    var selectedImages = [UIImage]()
    var limit = 5
    var pickerController = UIImagePickerController()

    var popup:PopupDialog!
    
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PurchaseStatusUserDefualt.value == 1{
            limit = 20
        }
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.collectionView.register(UINib(nibName: ChooseImageCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ChooseImageCollectionViewCell.reuseIdentifier)
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if PurchaseStatusUserDefualt.value == 1{
            print("purchased")
            bannerViewHeight.constant = 0
            return
        }
        super.bannerView.adUnitID = google_banner_id
        super.bannerView.rootViewController = self
        super.bannerView.load(GADRequest())
        super.bannerView.delegate = self
    }
    
    
    @IBAction func showDocumentClicked(_ sender: UIButton) {
        
        if super.showAdAtClicked() == false{
            let controller = ShowDocumentViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = ShowDocumentViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func autoRemoveBtnTapped(_ sender: Any) {
        
        if super.showAdAtClicked() == false{
            let vc = ExtractingTextViewController()
            vc.selectedImages = selectedImages
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ExtractingTextViewController()
            vc.selectedImages = selectedImages
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    
    @IBAction func crossBtnTapped(_ sender: Any) {
        guard let langStr = Locale.current.languageCode else{return}
        
        if super.showAdAtClicked() == false{
            showAlertPopUp(headerText: "Do you want to clear selected image list?".localized(langStr), subHeaderText: "Listcleared".localized(langStr))
        }else{
            super.adDismissed = { [self] in
                showAlertPopUp(headerText: "Do you want to clear selected image list?".localized(langStr), subHeaderText: "Listcleared".localized(langStr))
            }
        }
    }
    
    func showAlertPopUp(headerText:String,subHeaderText:String){
        
        let timePicker = AlertPopUpViewController(nibName: "AlertPopUpViewController", bundle: nil)
        popup = PopupDialog(viewController: timePicker, buttonAlignment: .horizontal, transitionStyle: .fadeIn, tapGestureDismissal: false,panGestureDismissal: false)

        
        timePicker.setUpData(headerText: headerText, subHeaderText: subHeaderText, animation: "remove_button")
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
            selectedImages.removeAll()
            collectionView.reloadData()
        }else{
            super.adDismissed = { [self] in
                popup.dismiss()
                selectedImages.removeAll()
                collectionView.reloadData()
            }
        }
    }
    
    
    @IBAction func showSideMenu(){
        if super.showAdAtClicked() == false{
            presentSideMenu()
        }else{
            super.adDismissed = { [self] in
                presentSideMenu()
            }
        }
    }
    func presentSideMenu(){
        let menuVC : SideMenuViewController = SideMenuViewController()

        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        //self.navigationController?.navigationBar.bringSubviewToFront(menuVC.view)
        
        menuVC.view.layoutIfNeeded()
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);

        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }, completion:nil)
    }
    
}
//MARK: -                   IMAGE PICKER DELEGETES
extension ChooseImageViewController: ImagePickerDelegate {
    
    
    
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        
        self.selectedImages.append(image)
        if selectedImages.count == 0{
            self.removeAllBtn.isHidden = true
            self.autoRemoveBtn.isHidden = true
        }else{
            self.removeAllBtn.isHidden = false
            self.autoRemoveBtn.isHidden = false
        }
        collectionView.reloadData()
    }
    
    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}

    

//MARK: -                   COLLECTIONVIEW PROTOCOLS

extension ChooseImageViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ChooseImageCollectionViewCell
        
        cell.shadowDecorate()
        cell.deleteImageDelegate = self
        cell.atIndex = indexPath.item
        
        if selectedImages.count == 0{
            cell.ImageView.isHidden = true
            cell.dummyView.isHidden = false
            if indexPath.item == 0 {
                cell.placeHolderImage.image = UIImage(named: "add_photo")
            }else if indexPath.item == 1 {
                cell.placeHolderImage.image = UIImage(named: "photo_camera")
            }
         return cell
        }else{
            
            if (indexPath.item) < selectedImages.count  {
                cell.ImageView.isHidden = false
                cell.dummyView.isHidden = true
                cell.selectedImage.image = self.selectedImages[indexPath.item]
            }else if indexPath.item == selectedImages.count{
                cell.ImageView.isHidden = true
                cell.dummyView.isHidden = false
                //this is library
                cell.placeHolderImage.image = UIImage(named: "add_photo")
            }else{
                cell.ImageView.isHidden = true
                cell.dummyView.isHidden = false
                //this is camera
                cell.placeHolderImage.image = UIImage(named: "photo_camera")
            }
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if (indexPath.item) < selectedImages.count  {
//            cell.selectedImage.image = self.selectedImages[indexPath.item]
            
            let vc = EditingModeViewController()
            vc.editedImageSetDelegate = self
            vc.image = selectedImages[indexPath.item]
            vc.updateImageIndex = indexPath.item
            vc.imageProtocol = self
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.item == selectedImages.count{
            //this is library
//            imagePicker.photoGalleryAsscessRequest()
            
            if self.selectedImages.count >= self.limit{
                self.showErrorAlert(title: "Error", message: "Your limit is full")
                return
            }
            
            
            
            
            let imagePicker = ImagePickerController()
            imagePicker.settings.selection.max = self.limit - self.selectedImages.count
            
            presentImagePicker(imagePicker, select: { (asset) in
        
                // User selected an asset. Do something with it. Perhaps begin processing/upload?
            }, deselect: { (asset) in
                // User deselected an asset. Cancel whatever you did when asset was selected.
            }, cancel: { (assets) in
                // User canceled selection.
            }, finish: { (assets) in
                // User finished selection assets.
                
              
                
                let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
                options.resizeMode = .exact
                
                var pickerAssets = [UIImage]()

            
                for asset in assets{
//                    PHImageManager.default().reqimage
                    PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { (image, info) in
                        // Do something with image
                        if let image = image{
                            pickerAssets.append(image)
                            if pickerAssets.count == assets.count{
                                self.selectedImages.append(contentsOf: pickerAssets)
                                if self.selectedImages.count == 0{
                                    self.removeAllBtn.isHidden = true
                                    self.autoRemoveBtn.isHidden = true
                                }else{
                                    self.removeAllBtn.isHidden = false
                                    self.autoRemoveBtn.isHidden = false
                                }
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            })
        }else{
            if self.selectedImages.count >= self.limit{
                self.showErrorAlert(title: "Error", message: "Your limit is full")
                return
            }
            //this is camera
            imagePicker.cameraAsscessRequest()
        }
    }

}


// MARK: -              PROTOCOL DElEGATE

extension ChooseImageViewController:EditedImageSetDelegate{
    func sendBackEditedImage(image: UIImage, updateIndex: Int) {
        selectedImages[updateIndex] = image
        let indexPath = IndexPath(item: updateIndex, section: 0)
        collectionView.reloadItems(at: [indexPath])

    }
}

// MARK: -                  PROTOCOL DElEGATE

extension ChooseImageViewController:DeleteImageDelegate{
    func deleteImage(atIndex: Int) {
        self.selectedImages.remove(at: atIndex)
        
        if selectedImages.count == 0{
            self.removeAllBtn.isHidden = true
            self.autoRemoveBtn.isHidden = true
        }else{
            self.removeAllBtn.isHidden = false
            self.autoRemoveBtn.isHidden = false
        }
        
//        let indexPath = IndexPath(item: atIndex, section: 0)
//        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
}


// MARK: -                  PROTOCOL

protocol DeleteImageDelegate {
    func deleteImage(atIndex:Int)
}

// MARK: -                  PROTOCOL DElEGATE

extension ChooseImageViewController:ImageSendingProtocol{
    
    func imageSending(image: UIImage, index: Int) {
        selectedImages[index] = image
        collectionView.reloadData()
    }
}
