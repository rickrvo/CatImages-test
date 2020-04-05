//
//  RealmMigrationManager.swift
//  CatImages-test
//
//  Created by Henrique Ormonde on 04/04/20.
//  Copyright © 2020 Henrique Ormonde. All rights reserved.
//

import RealmSwift

class RealmMigrationManager: Object {
    
    static func configureMigration() {
        
        if let path = Bundle.main.path(forResource: "RealmMigrationSettings", ofType: "plist") {
            
            let myDict = NSDictionary(contentsOfFile: path)
            if let newVersion = myDict?.object(forKey: "RealmMigrationVersion") as? String {
                
                let config = Realm.Configuration(
                    schemaVersion: UInt64(newVersion)!,
                    migrationBlock: { migration, oldSchemaVersion in
                        print("migration")
                })
                
                Realm.Configuration.defaultConfiguration = config
                
                do {
                    try Realm()
                } catch {
                    print("Realm not started")
                }
            }
        }
    }
}
