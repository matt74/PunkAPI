//
//  ProductService.swift
//  PunkAPI
//
//  Created by Matthias BUREL on 06.09.19.
//  Copyright © 2019 Matthias BUREL. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: Error {
    case jsonParsingError
    case serverError
    case other
    
    var localizedDescription: String {
        return "Error!"
    }
}

class ProductService {
    
    func getProduct(pageIndex: Int, completion: @escaping (_ error: Error?, _ productList:[Product]) -> Void) {
        
        let baseUrl = "https://api.punkapi.com/v2/beers"
        let method: HTTPMethod = .get
        
        let parameters: Parameters = [
            "malt": "extra_pale",
            "page": pageIndex,
            "per_page":25
        ]
        
        Alamofire.request(baseUrl, method: method, parameters: parameters, encoding: URLEncoding.default)
            
        .validate()
        .responseData { (response) in
        
            guard response.result.isSuccess,
                let data = response.result.value else {
                    print(APIError.serverError)
                    return
                }
    
            guard let products = self.parseProductResponse(data) else {
                completion(APIError.jsonParsingError, [])
                return
            }
            
            completion(nil, products)
        }
    }
        
    func parseProductResponse(_ data: Data) -> [Product]? {
        do {
            let decoder = JSONDecoder()
            let productList = try decoder.decode([Product].self, from: data)
            return productList
        }
        catch {
            return nil
        }
    }
}
