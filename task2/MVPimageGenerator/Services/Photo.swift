//
//  Photo.swift
//  MVPimageGenerator
//
//  Created by Sergey on 24/05/23.
//

import Foundation
import UIKit
import CoreData

@objc(Photo)
class Photo: NSManagedObject{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "FavoriteImageEntity")
    }

    @NSManaged public var image: UIImage?
    @NSManaged public var query: String?
    @NSManaged public var timestamp: Date?
}

extension Photo: Identifiable {
    
}
