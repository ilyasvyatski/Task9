//
//  RecordVCExtensions.swift
//  Task7
//
//  Created by neoviso on 9/14/22.
//

import Foundation
import UIKit
import CoreData

extension ItemViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = dataProvider.fetchedResultController.sections else { return 0 }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = dataProvider.fetchedResultController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = dataProvider.fetchedResultController.object(at: indexPath)
        if item is RecordEntity {
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(String(item.children?.count ?? 0)) child"
        } else if item is PictureEntity {
            cell.textLabel?.text = item.title
            cell.backgroundColor = .systemFill
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let item = self.dataProvider.fetchedResultController.object(at: indexPath)
            
            guard !item.children!.isEmpty else {
                self.deleteRecordAlert(with: "Delete Item", "Are you sure you want to delete \(item.title ?? "name") item?", "Delete", "Cancel") {
                    //self.dataProvider.fetchedResultController.managedObjectContext.delete(item)
                    self.dataProvider.deleteItem(item: item)
                }
                return
            }
            self.deleteRecordAlert(with: "Delete Item", "Are you sure you want to delete \(item.title ?? "name") item with \(String(item.children?.count ?? 0)) child?", "Delete", "Cancel") {
                //self.dataProvider.fetchedResultController.managedObjectContext.delete(item)
                self.dataProvider.deleteItem(item: item)
            }
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (action, view, completionHandler) in
            let item = self.dataProvider.fetchedResultController.object(at: indexPath)
            self.editRecordAlert(with: "Edit Item", "", "Edit", "Cancel", "Enter here", item.title ?? "item") { text in
                //item.title = text
                self.dataProvider.editItem(item: item, newTitle: text)
            }
            completionHandler(true)
        }
        editAction.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataProvider.fetchedResultController.object(at: indexPath)
        
        if item is RecordEntity {
            if let vc = self.storyboard?.instantiateViewController(identifier: "recordViewController") as? ItemViewController {
                vc.selectedRecord = self.dataProvider.fetchedResultController.object(at: indexPath) as? RecordEntity
                guard vc.selectedRecord != nil else { vc.currentPredicate = NSPredicate(format: "parent == %@", 0); return }
                vc.currentPredicate = NSPredicate(format: "parent == %@", vc.selectedRecord!)
                self.show(vc, sender: self)
            }
        } else {
            if let vc = self.storyboard?.instantiateViewController(identifier: "canvasViewController") as? CanvasViewController {
                vc.selectedPicture = self.dataProvider.fetchedResultController.object(at: indexPath) as? PictureEntity
                self.show(vc, sender: self)
                //print("lines count \(vc.selectedPicture?.lines.count)")
            }
        }
    }
}

extension ItemViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
           switch type {
           case .insert:
               tableView.insertSections(IndexSet(integer: sectionIndex), with: .none)
           case .delete:
               tableView.deleteSections(IndexSet(integer: sectionIndex), with: .none)
           default:
               break
           }
       }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

