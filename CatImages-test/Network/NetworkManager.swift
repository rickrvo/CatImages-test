//
//  NetworkManager.swift
//  CatImages-test
//
//  Created by Henrique Ormonde on 04/04/20.
//  Copyright © 2020 Henrique Ormonde. All rights reserved.
//

import Foundation

enum NetworkConfig : String {
    case clientId = "1ceddedc03a5d71"
    case clientSecret = "63775118a9f912fd91ed99574becf3b375d9eeca"
    case catUrl = "https://api.imgur.com/3/gallery/search/?q=cats"
}


class NetworkManager {
    
    public static let shared = NetworkManager()
    
    public func getCatImages(success: @escaping (_ responseObject: CatImageResponse?) -> (), errorResponse: @escaping (Error?) -> ()) {
        
        var catImageResponse : CatImageResponse?
        
        if let url = URL(string: NetworkConfig.catUrl.rawValue) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Client-ID \(NetworkConfig.clientId.rawValue)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else { print(error!); errorResponse(error); return }
                
                guard let data = data else { print("*** No data received"); errorResponse(error); return }

//                if let str = String(data: data, encoding: .utf8) {
                
//                do{
//                     //here dataResponse received from a network request
//                    if let jsonResponse = try JSONSerialization.jsonObject(with:
//                        data, options: []) as? [String: Any] {
//
//                        #if DEBUG
//                         print(jsonResponse) //Response result
//                        #endif
//
//                        let decoder = JSONDecoder()
//                        catImages = try decoder.decode([CatImage].self, from: jsonResponse["data"] as! Data)
//                        success(catImages)
//                        return
//                    }
//                    errorResponse(error)
//
//                  } catch let parsingError {
//                     print("Error", parsingError)
//                    errorResponse(error)
//                }
                
                let decoder = JSONDecoder()
                do {
                    #if DEBUG
                    if let str = String(data: data, encoding: .utf8) {
                       print(str)
                    }
                    #endif
                    catImageResponse = try decoder.decode(CatImageResponse.self, from: data)
                    print(catImageResponse)
                    success(catImageResponse)
                } catch {
                    print(error.localizedDescription)
                    errorResponse(error)
                }
                    
//                }
            }.resume()
        }
        
    }
}
