//
//  CustomCell.swift
//  PunkAPI
//
//  Created by Matthias BUREL on 06.09.19.
//  Copyright © 2019 Matthias BUREL. All rights reserved.
//
import UIKit
import Foundation

class CustomCell : UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productTagLabel: UILabel!
    @IBOutlet weak var productdescriptionLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func prepareForReuse() {
        productNameLabel.text = ""
        productTagLabel.text = ""
        productdescriptionLabel.text = ""
        productImage.image = nil
    }
}
