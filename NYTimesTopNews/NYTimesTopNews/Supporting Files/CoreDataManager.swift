//
//  CoreDataManager.swift
//  NYTimesTopNews
//
//  Created by Mehmet Akdeniz on 17.05.2023.
//

import CoreData
import UIKit
import NYTimesAPI

protocol CoreDataManagerProtocol {
    func addFavorite(story: StoryResult)
    func isFavorite(story: StoryResult) -> Bool
    func deleteFavorite(story: StoryResult)
}

class CoreDataManager: CoreDataManagerProtocol {
    
    static let shared = CoreDataManager()

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NYTimesTopNews")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {}

    func addFavorite(story: StoryResult) {
        let favorite = FavoriteStory(context: context)
        favorite.title = story.title
        favorite.abstract = story.abstract
        favorite.byline = story.byline
        favorite.url = story.url
        favorite.imageUrl = story.multimedia.first?.url
        do {
            try context.save()
        } catch let error {
            print("Failed to add favorite: ", error)
        }
    }

    func isFavorite(story: StoryResult) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteStory> = FavoriteStory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", story.title )
        do {
            let fetchedStories = try context.fetch(fetchRequest)
            return !fetchedStories.isEmpty
        } catch let error {
            print("Failed to fetch favorite: ", error)
            return false
        }
    }

    func deleteFavorite(story: StoryResult) {
        let fetchRequest: NSFetchRequest<FavoriteStory> = FavoriteStory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", story.title )
        do {
            let fetchedStories = try context.fetch(fetchRequest)
            for story in fetchedStories {
                context.delete(story)
            }
            try context.save()
        } catch let error {
            print("Failed to delete favorite: ", error)
        }
    }
    

}

