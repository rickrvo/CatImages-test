//
//  CatImage.swift
//  CatImages-test
//
//  Created by Henrique Ormonde on 04/04/20.
//  Copyright © 2020 Henrique Ormonde. All rights reserved.
//

import Foundation


struct CatImageResponse : Codable {
    var data : [CatImage]? = nil
    var success : Bool? = nil
    var status : Int? = nil
}

struct CatImage: Codable {
    var id : String? = nil
    var title : String? = nil
    var description : String? = nil
    var datetime : Double? = nil
    var type : String? = nil
    var animated : Bool? = nil
    var width : Int? = nil
    var height : Int? = nil
    var name : String? = nil
    var link : String? = nil
    var images : [CatImage]? = nil
    
//    init?(json: [String: Any]) {
//      guard let title = json["title"] as? String,
//        let id = json["id"] as? Int,
//        let userId = json["userId"] as? Int,
//        let completed = json["completed"] as? Int else {
//          return nil
//      }
//      self.title = title
//      self.userId = userId
//      self.completed = completed
//      self.id = id
//    }
}
