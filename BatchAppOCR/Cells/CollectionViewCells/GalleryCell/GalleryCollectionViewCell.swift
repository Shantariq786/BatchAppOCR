//
//  GalleryCollectionViewCell.swift
//  Batch4App
//
//  Created by Yousaf Shafiq on 25/04/2021.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    
    static let reuseIdentifier = "GalleryCollectionViewCell"
    
    @IBOutlet weak var outputImageView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
