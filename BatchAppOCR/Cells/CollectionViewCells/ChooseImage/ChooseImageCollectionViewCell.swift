//
//  ChooseImageCollectionViewCell.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 19/01/2022.
//

import UIKit

class ChooseImageCollectionViewCell: UICollectionViewCell {

    
    var atIndex:Int?
    var deleteImageDelegate:DeleteImageDelegate?
    
    static let reuseIdentifier = "ChooseImageCollectionViewCell"
    
    
    @IBOutlet weak var dummyView:UIView!
    @IBOutlet weak var ImageView:UIView!
    
    @IBOutlet weak var crossButton:UIButton!
    
    @IBOutlet weak var selectedImage:UIImageView!
    @IBOutlet weak var placeHolderImage:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    override func draw(_ rect: CGRect) {
       dummyView.addDashedBorder()
    }
    
    @IBAction func crossAction(_ sender:UIButton){
        
        if self.deleteImageDelegate != nil{
            if let atIndex = self.atIndex{
                self.deleteImageDelegate?.deleteImage(atIndex: atIndex)
            }
        }
    }
}

extension UIView {
    func addDashedBorder() {
        let color = UIColor.darkGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}

