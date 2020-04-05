//
//  RealmMigrationSettings.swift
//  CatImages-test
//
//  Created by Henrique Ormonde on 04/04/20.
//  Copyright © 2020 Henrique Ormonde. All rights reserved.
//

import UIKit

class RealmMigrationSettings: NSObject {
    
    static let sharedInstance = RealmMigrationSettings()
    
    var realmMigration: RealmMigration!
    
    override init() {
        super.init()
        self.loadItems()
    }
    
    func loadItems() {
        
        self.realmMigration = self.getCurrentRealmMigrationModel()
    }
    
    func getRealmModelItem(item :String) -> AnyObject
    {
        let filePath = Bundle.main.path(forResource: "RealmMigrationSettings", ofType: "plist")!
        let stylesheet : NSDictionary! = NSDictionary(contentsOfFile:filePath)
        
        return stylesheet.object(forKey: item)! as AnyObject
    }
    
    func getCurrentRealmMigrationModel() -> RealmMigration {
        let rlms = self.getRealmModelItem(item: "RealmModel") as! NSArray
        let currentRealmMigrationModel: RealmMigration? = RealmMigration()
        currentRealmMigrationModel?.objectsMigration = Array()
        for rlm in rlms {
            let realmModel: RealmMigrationModel? = RealmMigrationModel()
            
            realmModel?.objClassRealm = ((rlm as! NSDictionary).object(forKey:"class") as! String)
            realmModel?.version = ((rlm as! NSDictionary).object(forKey:"version") as! String)
            realmModel?.property = ((rlm as! NSDictionary).object(forKey:"property") as! Array<String>)
            
            currentRealmMigrationModel?.objectsMigration.append(realmModel!)
        }
        
        return currentRealmMigrationModel!
    }
}
