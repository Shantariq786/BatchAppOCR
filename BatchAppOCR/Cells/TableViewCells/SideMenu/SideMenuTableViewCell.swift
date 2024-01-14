//
//  SideMenuTableViewCell.swift
//  Batch4App
//
//  Created by Muhammad Yousaf on 11/05/2021.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var titleImage:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
