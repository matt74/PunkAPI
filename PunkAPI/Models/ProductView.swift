//
//  ProductView.swift
//  PunkAPI
//
//  Created by Matthias BUREL on 06.09.19.
//  Copyright © 2019 Matthias BUREL. All rights reserved.
//

import Foundation

struct ProductView {
    private let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    var productNameText: String {
        return product.name
    }
    
    var productDescriptionText: String {
        return product.description
    }
    
    var productTaglineText: String {
        return product.tagline
    }
    
    var productImageUrl: URL? {
        return URL(string: product.imageUrl)
    }
}
