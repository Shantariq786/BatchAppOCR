//
//  CustomControllers.swift
//  BatchAppOCR
//
//  Created by HexaCrew on 19/01/2022.
//

import Foundation
import UIKit

@IBDesignable//
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
   
}

class RoundTextView: UITextView {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}

class RoundCollectionView: UICollectionView {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
//check

@IBDesignable
class RoundUIView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
}
//check
@IBDesignable
class RoundTextField: UITextField
{
    @IBInspectable var cornerRadius :CGFloat = 0 {
        didSet
        {
            self.layer.cornerRadius = cornerRadius
        }
     }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet
        {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet
        {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var leftImage : UIImage? {
        didSet {
            if let image = leftImage{
                leftViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 24, y: 8, width: 16, height: 16))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                
                imageView.image = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                imageView.tintColor = .lightGray
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 64, height: 32))
                view.addSubview(imageView)
                leftView = view
            }else {
                leftViewMode = .never
            }
        }
    }
    @IBInspectable var rightImage : UIImage?
    {
            didSet
            {
                if let image = rightImage
                {
                    rightViewMode = .always
                    let imageview = UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
                    imageview.image = image
                    imageview.tintColor = tintColor
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                    view.addSubview(imageview)
                    rightView = view
                }
                else
                {
                    rightViewMode = .never
                }
                
            }
      }
    @IBInspectable var leftpadding : CGFloat = 0.0
    {
        didSet{
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftpadding, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        
    }
    
    
    
    
   
//    //for padding
//    @IBInspectable var inset: CGFloat = 0
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: inset, dy: inset)
//    }
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return textRect(forBounds: bounds)
//    }
 
    
}

//check
@IBDesignable
class RoundView: UIView {
    @IBInspectable var cornorradius : CGFloat = 0
    {
        didSet
        {
            layer.cornerRadius = cornorradius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet
        {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet
        {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var shadowColor : UIColor?{
        didSet
        {
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOpacity = 0.6
        }
    }
   
}
@IBDesignable
class RoundImageView: UIImageView {
    @IBInspectable var cornorradius : CGFloat = 0
        {
        didSet
        {
            layer.cornerRadius = cornorradius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet
        {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet
        {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var shadowColor : UIColor?{
        didSet
        {
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOpacity = 0.6
        }
    }
}

@IBDesignable//
class RoundLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}

@IBDesignable
class LeftAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        
        //UIEdgeInsetsInsetRect(bounds, contentEdgeInsets)
        
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 2, bottom: 0, right: 0)
    }
}

@IBDesignable//
class FilterRoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .right
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (availableWidth / 2)-10)
    }
}
