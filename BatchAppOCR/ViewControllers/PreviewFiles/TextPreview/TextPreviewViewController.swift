//
//  TextPreviewViewController.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 24/01/2022.
//

import UIKit

class TextPreviewViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var url:URL!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        TextDataView()
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func TextDataView(){
        
        let file = url
        var result = ""
        
        //prepare file url
        let fileURL = file
        do {
            result = try NSString(contentsOf: fileURL!, encoding: String.Encoding.utf8.rawValue) as String
            textView.text = result
        }
        catch {
            print(error)
        }
        print(result)
    }

}
