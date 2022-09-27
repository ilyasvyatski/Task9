//
//  PersistentStorage.swift
//  Task7
//
//  Created by neoviso on 9/11/22.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    //Singleton
    static let shared = CoreDataStack()
    private init() {}
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Task7")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        })
        return container
    }()
    
    lazy var mainContext = persistentContainer.viewContext

    // MARK: - Core Data Saving support

    func saveContext () {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func printThreadStats() {
        if Thread.isMainThread {
            print("on the main thread")
        } else {
            print("off the main thread")
        }
    }
}
