//
//  RecordProvider.swift
//  Task7
//
//  Created by neoviso on 9/11/22.
//

import Foundation
import CoreData

class DataProvider {
    
    private weak var fetchedResultControllerDelegate: NSFetchedResultsControllerDelegate?
    
    init(with fetchedResultControllerDelegate: NSFetchedResultsControllerDelegate) {
        self.fetchedResultControllerDelegate = fetchedResultControllerDelegate
    }
    
    lazy var fetchedResultController: NSFetchedResultsController<ItemEntity> = {
        let fetchRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            print(error)
        }
        
        return controller
    }()
    
    func addItem(parentItem: RecordEntity?, title: String, itemType: itemType) {
        CoreDataStack.shared.persistentContainer.performBackgroundTask { backgroundContext in
            
            switch itemType {
            case .recordEntity:
                let recordEntity = NSEntityDescription.insertNewObject(forEntityName: "RecordEntity", into: backgroundContext) as! RecordEntity
                recordEntity.id = UUID()
                recordEntity.title = title
                if parentItem != nil {
                    recordEntity.parent = backgroundContext.object(with: parentItem!.objectID) as? RecordEntity
                } else {
                    recordEntity.parent = nil
                }
                
            case .pictureEntity:
                let pictureEntity = NSEntityDescription.insertNewObject(forEntityName: "PictureEntity", into: backgroundContext) as! PictureEntity
                pictureEntity.id = UUID()
                pictureEntity.title = title
                if parentItem != nil {
                    pictureEntity.parent = backgroundContext.object(with: parentItem!.objectID) as? RecordEntity
                } else {
                    pictureEntity.parent = nil
                }
            }
            CoreDataStack.shared.printThreadStats()
            //CoreDataStack.shared.saveContext()
            
            do {
                try backgroundContext.save()
            } catch let err {
                print("Failed to save:", err)
            }
        }
    }
    
    func deleteItem(item: ItemEntity) {
        CoreDataStack.shared.persistentContainer.performBackgroundTask { backgroundContext in
            
            let backgroundContextItem = backgroundContext.object(with: item.objectID) as! ItemEntity
            
            backgroundContext.delete(backgroundContextItem)
            //CoreDataStack.shared.printThreadStats()
            
            do {
                try backgroundContext.save()
            } catch let err {
                print("Failed to save:", err)
            }
        }
    }
    
    func editItem(item: ItemEntity?, newTitle: String) {
        CoreDataStack.shared.persistentContainer.performBackgroundTask { backgroundContext in
            
            let backgroundContextItem = backgroundContext.object(with: item!.objectID) as! ItemEntity
            
            backgroundContextItem.title = newTitle
            //CoreDataStack.shared.printThreadStats()
            
            do {
                try backgroundContext.save()
            } catch let err {
                print("Failed to save:", err)
            }
        }
    }
}

