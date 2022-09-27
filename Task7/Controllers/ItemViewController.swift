//
//  TableViewController.swift
//  Task7
//
//  Created by neoviso on 9/10/22.
//

import UIKit
import CoreData

class ItemViewController: UITableViewController {

    var selectedRecord: RecordEntity?
    
    var currentPredicate = NSPredicate(format: "parent == %@", 0)
    
    lazy var dataProvider: DataProvider = {
        let dataProvider = DataProvider(with: self)
        dataProvider.fetchedResultController.fetchRequest.predicate = currentPredicate
        try? dataProvider.fetchedResultController.performFetch()
        return dataProvider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.navigationItem.title = self.selectedRecord?.title ?? "Items"
            self.tableView.tableFooterView = UIView()
        }
    }
    
    @IBAction func addPictureButton(_ sender: UIBarButtonItem) {
        createItemAlert(with: "Add New Picture", "", "Add", "Cancel", "Enter here", items: dataProvider.fetchedResultController.fetchedObjects) { text in
            self.dataProvider.addItem(parentItem: self.selectedRecord, title: text, itemType: itemType.pictureEntity)
            //CoreDataStack.shared.printThreadStats()
        }
    }
    
    @IBAction func addRecordButton(_ sender: UIBarButtonItem) {
        createItemAlert(with: "Add New Record", "", "Add", "Cancel", "Enter here", items: dataProvider.fetchedResultController.fetchedObjects) { text in
            self.dataProvider.addItem(parentItem: self.selectedRecord, title: text, itemType: itemType.recordEntity)
            //CoreDataStack.shared.printThreadStats()
        }
    }
}

