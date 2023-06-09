//
//  StorageManager.swift
//  MVPimageGenerator
//
//  Created by Sergey on 22/05/23.
//

import UIKit
import CoreData

class StorageManager {
    static let shared = StorageManager()
    private var favoriteLimit: Int = 10

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteImageEntity")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveImage(_ image: UIImage, query: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteImageEntity", in: context) else { return }
        let favoriteImage = NSManagedObject(entity: entity, insertInto: context) as? Photo
        
        favoriteImage?.image = image
        favoriteImage?.query = query
        favoriteImage?.timestamp = Date()
        saveContext()
        
        if getFavoriteImages().count > favoriteLimit { removeOldestFavoriteImage() }
    }
    
    func getFavoriteImages() -> [FavoriteImageModel] {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()

        do {
            let entities = try self.context.fetch(fetchRequest)
            let data = entities.compactMap { entity -> FavoriteImageModel? in
                if let image = entity.image, let query = entity.query, let timestamp = entity.timestamp {
                    let favorite = FavoriteImageModel(image: image, query: query, timestamp: timestamp)
                    favorite.timestamp = entity.timestamp! // Присвоим значение из свойства dateAdded
                    return favorite
                }
                return nil
            }
            return data
        } catch {
            print("Error fetching favorite images: \(error)")
            return []
        }
    }
    
    func removeFavorite(at index: Int) {
            let favorites = getFavoriteImages()

            guard index >= 0 && index < favorites.count else { return }

            let favoriteToRemove = favorites[index]
            let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "timestamp == %@", favoriteToRemove.timestamp as NSDate)

            do {
                let results = try context.fetch(fetchRequest)
                if let favoriteManagedObject = results.first {
                    context.delete(favoriteManagedObject)
                    saveContext()
                }
            } catch {
                print("Error removing favorite image: \(error)")
            }
        }
    
    func removeOldestFavoriteImage() {
        let favorites = getFavoriteImages()

        if let oldestFavorite = favorites.sorted(by: { $0.timestamp < $1.timestamp }).first {
            let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "timestamp == %@", oldestFavorite.timestamp as NSDate)
            fetchRequest.fetchLimit = 1

            do {
                let results = try context.fetch(fetchRequest)
                if let oldestFavoriteManagedObject = results.first {
                    context.delete(oldestFavoriteManagedObject)
                    saveContext()
                }
            } catch {
                print("Error deleting oldest favorite image: \(error)")
            }
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
