//
//  Product.swift
//  PunkAPI
//
//  Created by Matthias BUREL on 06.09.19.
//  Copyright © 2019 Matthias BUREL. All rights reserved.
//

import Foundation

struct Product : Codable {
    var name: String
    var imageUrl: String
    var description: String
    var tagline: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl = "image_url"
        case description
        case tagline
    }
}
