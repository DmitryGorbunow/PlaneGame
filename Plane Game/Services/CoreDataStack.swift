//
//  CoreDataStack.swift
//  Plane Game
//
//  Created by Dmitry Gorbunow on 9/11/23.
//

import Foundation

import CoreData

final class CoreDataStack {
    
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PlaneGame")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return persistentContainer.viewContext }
    static var fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
