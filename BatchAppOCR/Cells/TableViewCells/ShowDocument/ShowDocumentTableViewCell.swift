//
//  ShowDocumentTableViewCell.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 24/01/2022.
//

import UIKit

protocol CellClickProtocol {
    func CellClicked(indexPath:IndexPath)

}

class ShowDocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var fileimageView: UIImageView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    var cellclickedprotocol : CellClickProtocol! = nil
    var indexPath:IndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CellClicked))
        bgView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func setData(url:URL){
        lblName.text = getFileName(url: url)
        
        // image set
        let fileNameArray = lblName.text!.components(separatedBy: ".")
        if fileNameArray[1] == "txt"{
            fileimageView.image = UIImage(named: "ic_text")!
        }else if fileNameArray[1] == "pdf"{
            fileimageView.image = UIImage(named: "ic_pdf")!
        }else{
            fileimageView.image = UIImage(named: "ic_word")!
        }
        
        setTime(fileNameLeftpart: fileNameArray[0])
    }
    
    func setTime(fileNameLeftpart:String){
        let token = fileNameLeftpart.components(separatedBy: "_")
        let stringTimeStamp = token[token.count-1]
        let date = Date.init(milliseconds: Int64(stringTimeStamp)!)
        lblDate.text = "\(date)"
    }
    
    @objc func CellClicked() {
        cellclickedprotocol.CellClicked(indexPath: indexPath)

    }
    
}
