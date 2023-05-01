//
//  Persistence.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/26/23.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecipeCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//         context is container reference
// MARK: To Save
//        context.insert(Object)
//
//        do {
//            try context.save()
//        } catch {
//            print("oh no")
//        }


//let fetchRequest = NSFetchRequest<ObjectType>(entityName: "EntityName")
//
//do {
//    let results = try context.fetch(fetchRequest)
//
//    for result in results {
//        result is of type Object saved in Core Data
//    }
//} catch let error as NSError {
//    print("you oofed")
//}

