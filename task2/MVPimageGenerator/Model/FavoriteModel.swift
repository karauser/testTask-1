//
//  FavoriteModel.swift
//  MVPimageGenerator
//
//  Created by Sergey on 21/05/23.
//

import UIKit

class Favorite: NSObject, NSCoding {
    let image: UIImage
    let query: String
    var timestamp: Date
    
    init(image: UIImage, query: String, timestamp: Date) {
        self.image = image
        self.query = query
        self.timestamp = timestamp
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(image, forKey: "image")
        coder.encode(query, forKey: "query")
        coder.encode(timestamp, forKey: "timestamp")
    }
    
    required init?(coder: NSCoder) {
        guard let image = coder.decodeObject(forKey: "image") as? UIImage,
              let query = coder.decodeObject(forKey: "query") as? String,
              let timestamp = coder.decodeObject(forKey: "timestamp") as? Date else {
            return nil
        }
        
        self.image = image
        self.query = query
        self.timestamp = timestamp
    }
}



