//
//  LanguageSelectionViewController.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 07/02/2022.
//

import UIKit
import MLKit
import MLKitLanguageID
import NaturalLanguage

class LanguageSelectionViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchtextField: UITextField!
    @IBOutlet weak var backgroundBlackView: UIView!
    
    @IBOutlet weak var propertiesView: UIView!
    @IBOutlet weak var bgfullscreenView: UIView!
    
    var filteredData:[String]!
    var extractedText: String = ""
    var selectedIndex:Int!
    var indexPath:IndexPath!
    
    var LanguageArray :[String] = ["Afrikaans","Dutch","French","Indonesian","Italian","Portguese","Spanish","Swedish","Turkish","Polish","Czech","Slovak","Romanian","Danish","Croatian","Albanian","Estonian","Finnish","Latvian","Malay","Norwegian Bokmål","Vietnamese","Catalan"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bgfullscreenView.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        propertiesView.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        
        tableView.register(UINib(nibName: "LanguageSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "LanguageSelectionTableViewCell")
        searchtextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        backgroundBlackView.addGestureRecognizer(tapGesture)
        filteredData = LanguageArray
        searchtextField.addTarget(self, action: #selector(textFieldDidChange(_:)),for: .editingChanged)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(remoteModelDownloadDidComplete(notification:)),name: .mlkitModelDownloadDidSucceed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(remoteModelDownloadDidComplete(notification:)),name: .mlkitModelDownloadDidFail, object: nil)
        
    }
    
    @IBAction func crossBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            filteredData = LanguageArray
        }else{
            let searchText = textField.text!
            filteredData = []
            filteredData = LanguageArray.filter{
                $0.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    @objc func handleTap() {
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { (complete) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}


//MARK: -               Extension TABLEVIEW

extension LanguageSelectionViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageSelectionTableViewCell", for: indexPath) as! LanguageSelectionTableViewCell
        cell.selectionStyle = .none
        cell.languageNameLbl.text = filteredData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.indexPath = indexPath
        self.handleDownloadDelete(indexpath: indexPath)
    }
    
    func getModel(indexPath:IndexPath)->TranslateRemoteModel{
        
        var model = TranslateRemoteModel.translateRemoteModel(language: .english)
        
        if indexPath.row == 0{
            model = TranslateRemoteModel.translateRemoteModel(language: .afrikaans)
        }
        else if indexPath.row == 1{
            model = TranslateRemoteModel.translateRemoteModel(language: .dutch)
        }
        else if indexPath.row == 2{
            model = TranslateRemoteModel.translateRemoteModel(language: .french)
        }
        else if indexPath.row == 3{
            model = TranslateRemoteModel.translateRemoteModel(language: .indonesian)
        }
        else if indexPath.row == 4{
            model = TranslateRemoteModel.translateRemoteModel(language: .italian)
        }
        else if indexPath.row == 5{
            model = TranslateRemoteModel.translateRemoteModel(language: .portuguese)
        }
        else if indexPath.row == 6{
            model = TranslateRemoteModel.translateRemoteModel(language: .spanish)
        }
        else if indexPath.row == 7{
            model = TranslateRemoteModel.translateRemoteModel(language: .swedish)
        }
        else if indexPath.row == 8{
            model = TranslateRemoteModel.translateRemoteModel(language: .turkish)
        }
        else if indexPath.row == 9{
            model = TranslateRemoteModel.translateRemoteModel(language: .polish)
        }
        else if indexPath.row == 10{
            model = TranslateRemoteModel.translateRemoteModel(language: .czech)
        }
        else if indexPath.row == 11{
            model = TranslateRemoteModel.translateRemoteModel(language: .slovak)
        }
        else if indexPath.row == 12{
            model = TranslateRemoteModel.translateRemoteModel(language: .romanian)
        }
        else if indexPath.row == 13{
            model = TranslateRemoteModel.translateRemoteModel(language: .danish)
        }
        else if indexPath.row == 14{
            model = TranslateRemoteModel.translateRemoteModel(language: .croatian)
        }
        else if indexPath.row == 15{
            model = TranslateRemoteModel.translateRemoteModel(language: .albanian)
        }
        else if indexPath.row == 16{
            model = TranslateRemoteModel.translateRemoteModel(language: .estonian)
        }
        else if indexPath.row == 17{
            model = TranslateRemoteModel.translateRemoteModel(language: .finnish)
        }
        //        else if indexPath.row == 16{
        //            model = TranslateRemoteModel.translateRemoteModel(language: .lat)
        //        }
        else if indexPath.row == 18{
            model = TranslateRemoteModel.translateRemoteModel(language: .latvian)
        }
        else if indexPath.row == 19{
            model = TranslateRemoteModel.translateRemoteModel(language: .malay)
        }
        else if indexPath.row == 20{
            model = TranslateRemoteModel.translateRemoteModel(language: .norwegian)
        }
        //        else if indexPath.row == 20{
        //            model = TranslateRemoteModel.translateRemoteModel(language: .serbian)
        //        }
        else if indexPath.row == 21{
            model = TranslateRemoteModel.translateRemoteModel(language: .vietnamese)
        }
        else if indexPath.row == 22{
            model = TranslateRemoteModel.translateRemoteModel(language: .catalan)
        }
        return model
        
    }
    
    func handleDownloadDelete(indexpath: IndexPath) {
        
        let model = getModel(indexPath: indexpath)
        let modelManager = ModelManager.modelManager()
        let languageName = model.language.rawValue
        
        showHud(customMessage: "while downloading the language pack")
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: true,
            allowsBackgroundDownloading: true
        )
        modelManager.download(model, conditions: conditions)
        
    }
    
    
    @objc func remoteModelDownloadDidComplete(notification: NSNotification) {
        let userInfo = notification.userInfo!
        guard
            let remoteModel = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? TranslateRemoteModel
        else {
            return
        }
        DispatchQueue.main.async {
            let languageName = remoteModel.language.rawValue
            if notification.name == .mlkitModelDownloadDidSucceed {
                hideHud()
                print("Download succeeded for \(languageName)")
                
                let options = self.getTranslatorOption()
                let vc = TextTranslatedViewController()
                vc.options = options
                vc.extractedText = self.extractedText
                vc.titleheader = self.LanguageArray[self.indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                hideHud()
                print("Download failed for \(languageName)")
            }
        }
    }
    
    func getTranslatorOption()->TranslatorOptions{
        var options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .english)
        
        if indexPath.row == 0{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .afrikaans)
        }
        else if indexPath.row == 1{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .dutch)
        }
        else if indexPath.row == 2{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .french)
        }
        else if indexPath.row == 3{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .indonesian)
        }
        else if indexPath.row == 4{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .italian)
        }
        else if indexPath.row == 5{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .portuguese)
        }
        else if indexPath.row == 6{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .spanish)
        }
        else if indexPath.row == 7{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .swedish)
        }
        else if indexPath.row == 8{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .turkish)
        }
        else if indexPath.row == 9 {
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .polish)
        }
        else if indexPath.row == 10{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .czech)
        }
        else if indexPath.row == 11{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .slovak)
        }
        else if indexPath.row == 12{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .romanian)
        }
        else if indexPath.row == 13{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .danish)
        }
        else if indexPath.row == 14{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .croatian)
        }
        else if indexPath.row == 15{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .albanian)
        }
        //        else if indexPath.row == 14{ -> not in xcode
        //             options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .Filipino)
        //        }
        else if indexPath.row == 16{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .estonian)
            
        }
        //        else if indexPath.row == 16{  -> not in xcode
        //            model = TranslateRemoteModel.translateRemoteModel(language: .lat)
        //        }
        else if indexPath.row == 17{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .finnish)
        }
        else if indexPath.row == 18{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .latvian)
        }
        else if indexPath.row == 19{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .malay)
        }
        //        else if indexPath.row == 20{  -> not in xcode
        //            model = TranslateRemoteModel.translateRemoteModel(language: .serbian)
        //        }
        else if indexPath.row == 20{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .norwegian)
        }
        else if indexPath.row == 21{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .vietnamese)
        }
        else if indexPath.row == 22{
            options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .catalan)
        }
        return options
        
    }
    
}


