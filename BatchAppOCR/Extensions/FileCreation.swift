//
//  FileCreation.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 21/01/2022.
//

import Foundation
import UIKit
import DocX
import QuickLook
import PDFKit

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

func getcurrentDate()->String{
    let formatter = DateFormatter()
    // initially set the format based on your datepicker date / server String
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

    let myString = formatter.string(from: Date()) // string purpose I add here
    // convert your string to date
    let yourDate = formatter.date(from: myString)
    //then again set the date format whhich type of output you need
    formatter.dateFormat = "dd_MM_yyyy_HH_mm_ss"

    // again convert your date to string
    let myStringafd = formatter.string(from: yourDate!)

    return myStringafd
    //print("BA_OCR_\(myStringafd).pdf ")

}

//MARK:                      CREATE PDF FILE
func createPDF(text:String,completion:@escaping()->Void) {
    let html = "<p>\(text)</p>"
    let fmt = UIMarkupTextPrintFormatter(markupText: html)
    
    // 2. Assign print formatter to UIPrintPageRenderer
    let render = UIPrintPageRenderer()
    render.addPrintFormatter(fmt, startingAtPageAt: 0)
    
    // 3. Assign paperRect and printableRect
    let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
    let printable = page.insetBy(dx: 0, dy: 0)
    render.setValue(NSValue(cgRect: page), forKey: "paperRect")
    render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
    
    // 4. Create PDF context and draw
    let pdfData = NSMutableData()
    UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
    
    for i in 1...render.numberOfPages {
        UIGraphicsBeginPDFPage();
        let bounds = UIGraphicsGetPDFContextBounds()
        render.drawPage(at: i - 1, in: bounds)
    }
    UIGraphicsEndPDFContext()
    
    // 5. Save PDF file
    let currentTime = Date().millisecondsSince1970
    pdfData.write(toFile: "\(documentsPath)/BA_OCR_\(currentTime).pdf", atomically: true)
    completion()
    print(documentsPath)
}

//MARK:                      CREATE DOC/WORD FILE
func CreateDoc(text: String,completion:@escaping()->Void){
    
    let string = NSAttributedString(string: text)
    let temp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("docx")
    do{
        try string.writeDocX(to: temp)
    }
    catch let error{
        print("error while creating file ",error)
    }
    let currentTime = Date().millisecondsSince1970
    let file = "BA_OCR_\(currentTime).docx"
    
    do {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentDirectory = URL(fileURLWithPath: path)
        let destinationPath = documentDirectory.appendingPathComponent(file)
        try FileManager.default.moveItem(at: temp, to: destinationPath)
        completion()
    } catch {
        print("error while moving file ",error)
    }
}


//MARK: -                     CREATE TEXT FILE

func CreateTextFile(text: String,completion:@escaping()->Void){
    let currentTime = Date().millisecondsSince1970
    let file = "BA_OCR_\(currentTime).txt"
    
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

        let fileURL = dir.appendingPathComponent(file)
        //writing
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
            completion()
        }
        catch {
            print("error occur while creating text file")
        }

    }

}


//MARK: -                     DATE EXTENSION
extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}



let mutahirContant = "CCCCC"

