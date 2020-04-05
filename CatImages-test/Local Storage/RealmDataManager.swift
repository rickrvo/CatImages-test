//
//  RealmDataManager.swift
//  CatImages-test
//
//  Created by Henrique Ormonde on 04/04/20.
//  Copyright © 2020 Henrique Ormonde. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmDataManager : NSObject {
    
    
    static func fetchData<T: Object>(for entity: T.Type ) -> Array<T>? {
        
        guard let database : Realm = try? Realm() else {
            return nil
        }
        #if DEBUG
        print("Realm path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        #endif
        return database.objects(entity as Object.Type).map({ $0 as! T })
    }
    
    static func fetchData<T: Object>(for entity: T.Type, sortedBy : String ) -> Array<T>? {
        
        guard let database : Realm = try? Realm() else {
            return nil
        }
        #if DEBUG
        print("Realm path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        #endif
        return database.objects(entity as Object.Type).sorted(byKeyPath: sortedBy).map({ $0 as! T })
    }
    
    static func fetchDataWith<T>(query: NSPredicate, entity: T.Type, sortedBy : String? = nil) -> Array<T>? {
        
        guard let database : Realm = try? Realm() else {
            return nil
        }
        var dbObj = database.objects(entity as! Object.Type).filter(query)
        
        
        if sortedBy != nil {
            dbObj = dbObj.sorted(byKeyPath: sortedBy!)
        }
        
        return dbObj.map({ $0 as! T })
    }
    
    static func fetchDataWith<T>(query: NSPredicate, entity: T.Type, sortedBy : String) -> Array<T>? {
        
        guard let database : Realm = try? Realm() else {
            return nil
        }
        
        let dbObj = database.objects(entity as! Object.Type).filter(query)
        return dbObj.sorted(byKeyPath: sortedBy).map({ $0 as! T })
    }
    
    static func save(entityList: [Object], shouldUpdate update: Bool = false) {
        
        guard let database : Realm = try? Realm() else  {
            return
        }
        
        database.beginWrite()
        for entity in entityList {
            if let key = type(of: entity).primaryKey(), let value = entity[key] , update {
                if let existingObject = database.object(ofType: type(of: entity), forPrimaryKey: value as AnyObject) {
                    let relationships = existingObject.objectSchema.properties.filter {
                        $0.type == PropertyType.object
                    }
                    for relationship in relationships {
                        if let newObjectRelationship = entity[relationship.name] as? ListBase , newObjectRelationship.count == 0 {
                            entity[relationship.name] = existingObject[relationship.name]
                        }
                    }
                }
            }
            
            
            database.add(entity, update: .all)
        }
        
        do {
            try database.commitWrite()
        } catch let writeError {
            debugPrint("Unable to commit write: \(writeError)")
        }
        
        database.refresh()
    }
    
    
    
    static func replace<T>(entity: Object, type: T.Type) {
        
        let database : Realm = try! Realm()
        let dbObj = database.objects(type as! Object.Type)
        
        database.beginWrite()
        
        if dbObj.count > 0 {
            database.delete(dbObj)
        }
        database.add(entity)
        
        do{
            try database.commitWrite()
            
        } catch let writeError {
            debugPrint("Unable to commit write: \(writeError)")
        }
    }
    
    static func addItem<T>(entity: Object, type: T.Type) {
        
        let database : Realm = try! Realm()
        
        database.beginWrite()
        database.add(entity, update: .all)
        
        do{
            try database.commitWrite()
        } catch let writeError {
            debugPrint("Unable to commit write: \(writeError)")
        }
    }
    
    static func delete<T>(entity: T.Type) {
        
        guard let database : Realm = try? Realm() else  {
            return
        }
        
        let dbObj = database.objects(entity as! Object.Type)
        
        if dbObj.count > 0 {
            database.beginWrite()
            database.delete(dbObj)
            
            do{
                try database.commitWrite()
                
            } catch let writeError {
                debugPrint("Unable to commit write: \(writeError)")
            }
        }
    }
    
    static func deleteWith<T>(query: NSPredicate, entity: T.Type) {
        
        guard let database : Realm = try? Realm() else  {
            return
        }
        
        let dbObj = database.objects(entity as! Object.Type).filter(query)
        
        if dbObj.count > 0 {
            database.beginWrite()
            
            database.delete(dbObj)
            
            do{
                try database.commitWrite()
                
            } catch let writeError {
                debugPrint("Unable to commit write: \(writeError)")
            }
            
        }
    }
    
    static func deleteAll() {
        
        guard let database : Realm = try? Realm() else  {
            return
        }
        
        database.beginWrite()
        database.deleteAll()
        do{
            try database.commitWrite()
            
        } catch let writeError {
            debugPrint("Unable to commit write: \(writeError)")
        }
        
    }
    
}
