//
//  ImageRealmModel.swift
//  CatImages-test
//
//  Created by Henrique Ormonde on 04/04/20.
//  Copyright © 2020 Henrique Ormonde. All rights reserved.
//

import RealmSwift

class ImageModelRealm: Object {
    
    @objc dynamic var url: String? = nil
    @objc dynamic var data: Data? = nil
    
    override class func primaryKey() -> String? {
        return "url"
    }
}
