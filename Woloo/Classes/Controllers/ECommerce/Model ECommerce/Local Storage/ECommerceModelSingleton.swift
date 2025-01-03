//
//  ECommerceModelSingleton.swift
//  Woloo
//
//  Created by Rahul Patra on 08/08/21.
//

import Foundation
import CoreData

class EcommerceModelSingleton {
    static var instance: EcommerceModelSingleton? = EcommerceModelSingleton()
    
    var mainContaxt : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ECommerceModel")
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
