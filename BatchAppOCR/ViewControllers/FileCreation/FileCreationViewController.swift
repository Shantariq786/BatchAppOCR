//
//  FileCreationViewController.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 21/01/2022.
//

import UIKit

class FileCreationViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        textView.text = "Enter your Text"
        textView.textColor = UIColor.lightGray
    
        // Do any additional setup after loading the view.
    }
    

    @IBAction func savePDFClicked(_ sender: UIButton) {
        //let text = createPDF(text: textView.text)
    }
    
    @IBAction func saveDOCSClicked(_ sender: UIButton) {
    }
    
    @IBAction func saveTextClicked(_ sender: UIButton) {
        //let text = CreateTextFile(text: textView.text)
    }


}
extension FileCreationViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your Text"
            textView.textColor = UIColor.lightGray
        }
    }
}
