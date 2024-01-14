//
//  ShowDocumentViewController.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 24/01/2022.
//

import UIKit
import PDFKit
import QuickLook
import DocX
import GoogleMobileAds

class ShowDocumentViewController: BaseViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var bannerViewHeight: NSLayoutConstraint!
    
    var urlArray = [URL]()
    var selectedindex = -1
    var index: IndexPath = []
    var documentURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        tableView.register(UINib(nibName: "ShowDocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowDocumentTableViewCell")
        fetchFileNames()
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

    @IBAction func removeAllTapped(_ sender: UIButton) {
        
        for url in urlArray{
            DeleteFile(url: url) {
                print("Files Removed")
            }
        }
        urlArray.removeAll()
        self.tableView.reloadData()
    }
    func fetchFileNames(){
        let docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last) as NSURL?
        do{
            //put the contents in an array.
            urlArray = (try FileManager.default.contentsOfDirectory(at: docURL! as URL,
                                                                    includingPropertiesForKeys: nil,
                                                                    options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles))
            tableView.reloadData()
        }
        catch{
            print("Error")
        }
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        if super.showAdAtClicked() == false{
            self.navigationController?.popViewController(animated: true)
        }else{
            super.adDismissed = { [self] in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func shareFile(url:URL){
        
        // Create the Array which includes the filesyou want to share
        var filesToShare = [Any]()

        // Add the path of the file to the Array
        filesToShare.append(url)

        // Make the activityViewContoller which shows the share-view
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)

        // Show the share-view
        self.present(activityViewController, animated: true, completion: nil)
    }
    func DeleteFile(url:URL,completion:@escaping()->Void){
        do {
            try FileManager.default.removeItem(at: url)
            completion()
        } catch  {
            print("error occur while removing ",error)
            
        }
    }
}

// MARK: -                  Extension TableView

extension ShowDocumentViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowDocumentTableViewCell", for: indexPath) as! ShowDocumentTableViewCell
        cell.setData(url: urlArray[indexPath.row])
        cell.cellclickedprotocol = self
        cell.indexPath = indexPath
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") {[self](contextualAction, view, boolValue) in
            print("Delete tapped")
            DeleteFile(url: urlArray[indexPath.row]) {
                urlArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            }
            
        }
        let shareItem = UIContextualAction(style: .normal, title: "Share") { [self] (contextualAction, view, boolValue) in
            //share tapped
            shareFile(url: urlArray[indexPath.row])
            print("share tapped")
            
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem,shareItem])
        return swipeActions
    }
    
}

// MARK: -                  Protocol Extension

extension ShowDocumentViewController: CellClickProtocol{
    
    func CellClicked(indexPath: IndexPath) {
        
        let fileName = getFileName(url: urlArray[indexPath.row])
        let fileNameTokens = fileName.components(separatedBy: ".")
        print("fileNameTokens \(fileNameTokens)")
        
        if fileNameTokens[1] == "pdf"{
            
            let vc =  PdfPreviewViewController()
            vc.url = urlArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)

        }else if fileNameTokens[1] == "txt"{
            
            let vc = TextPreviewViewController()
            vc.url = urlArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)

        }else if fileNameTokens[1] == "docx"{
            documentURL = urlArray[indexPath.row]
            showDocx()
        }
        else{
            print("invalid format")
        }
    }
}

//MARK: -                       DOCX FILE VIEW
extension ShowDocumentViewController:QLPreviewControllerDelegate,QLPreviewControllerDataSource{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return self.documentURL != nil ? 1 : 0
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let url=self.documentURL else{return NSURL(fileURLWithPath: "")}
        return url as NSURL
    }
    func showDocx(){
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.delegate = self
        self.navigationController?.pushViewController(previewController, animated: true)
        
    }
}




