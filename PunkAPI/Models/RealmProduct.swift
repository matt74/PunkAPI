//
//  RealmDB.swift
//  PunkAPI
//
//  Created by Matthias BUREL on 07.09.19.
//  Copyright © 2019 Matthias BUREL. All rights reserved.
//

import Foundation
import RealmSwift

class PunkAPI: Object {
    @objc dynamic var uuid: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var tagLine: String = ""
    @objc dynamic var image_url: String = ""
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}


