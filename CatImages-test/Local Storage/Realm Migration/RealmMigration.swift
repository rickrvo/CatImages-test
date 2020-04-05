//
//  RealmMigration.swift
//  CatImages-test
//
//  Created by Henrique Ormonde on 04/04/20.
//  Copyright © 2020 Henrique Ormonde. All rights reserved.
//

import UIKit

class RealmMigration: NSObject {
    
    var objectsMigration: Array<RealmMigrationModel>!
}


enum EnumRealmMigrationVersion: String {
    case kEmptyMigration = ""
    case kImageMigration = "ImageRealmModel"
}
