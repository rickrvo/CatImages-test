//
//  UIImageView+.swift
//  CatImages-test
//
//  Created by Henrique Ormonde on 04/04/20.
//  Copyright © 2020 Henrique Ormonde. All rights reserved.
//

import UIKit

let imageCacheExtension = NSCache<AnyObject, AnyObject>()


extension UIImageView {
    
    /// Will get image from memory, disk or server
    ///
    /// - Parameter urlString: A string, containing the URL to the image
    public func getImage(urlString: String) {
        
        if let imageFromCache = imageCacheExtension.object(forKey: urlString as AnyObject) as? UIImage {
            
            self.image = imageFromCache
            return
        }
        
        let query : NSPredicate = NSPredicate(format: "url == '\(urlString)'")
        if let imagesFromDisk = RealmDataManager.fetchDataWith(query: query, entity: ImageModelRealm.self),
            imagesFromDisk.count > 0,
            let image = UIImage(data: imagesFromDisk.first?.data ?? Data())  {
            
            imageCacheExtension.setObject(image, forKey: urlString as AnyObject)
            self.image = image
            return
        }
        
        if let url = URL(string: urlString){
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                
                if error != nil { return }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    if let image = UIImage(data: data!) {
                        
                        imageCacheExtension.setObject(image, forKey: urlString as AnyObject)
                        
                        let dbProfile = RealmDataManager.fetchData(for: ImageModelRealm.self)
                        let imageDataRealm = ImageModelRealm()
                        imageDataRealm.url = url.absoluteString
                        imageDataRealm.data = data
                        RealmDataManager.save(entityList: [imageDataRealm], shouldUpdate: ((dbProfile?.count ?? 0) > 0))
                        
                        self.image = image
                    }
                })
                
            }).resume()
        }
    }
    
}
