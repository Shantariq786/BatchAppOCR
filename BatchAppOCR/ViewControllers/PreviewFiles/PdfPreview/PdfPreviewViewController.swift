//
//  PdfPreviewViewController.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 24/01/2022.
//

import UIKit
import PDFKit

class PdfPreviewViewController: UIViewController {

    @IBOutlet weak var backbtn: UIButton!
    var url:URL!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PdfFileView()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "chevron_left.jpeg"),
                        for: UIControl.State.normal)
        button.layer.cornerRadius = 18
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.frame = CGRect(x: 20, y: height-20, width: 36, height: 36)
        button.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func PdfFileView(){
        
        let pdfView = PDFView()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 50).isActive = true
        
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
        self.dismiss(animated: true, completion: nil)
    }
}
