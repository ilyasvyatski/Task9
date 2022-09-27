//
//  UIViewControllerExtensions.swift
//  Task7
//
//  Created by neoviso on 9/14/22.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    func createItemAlert(with title: String, _ message: String, _ actionButtonTitle: String, _ cancelButtonTitle: String, _ placeholder: String, items: [Any]?, completion: @escaping(String) -> ()) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: actionButtonTitle, style: .default) { action in
            completion(alertController.textFields?.first?.text ?? "")
        }
        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        actionButton.isEnabled = false
        alertController.addAction(actionButton)
        alertController.addAction(cancelButton)
        
        alertController.addTextField { (textField) in
            textField.placeholder = placeholder
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                {_ in
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    guard items?.contains(where: { ($0 as AnyObject).title == textField.text }) == false else { actionButton.isEnabled = false; return }
                    actionButton.isEnabled = textIsNotEmpty
            })
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteRecordAlert(with title: String, _ message: String, _ actionButtonTitle: String, _ cancelButtonTitle: String, completion: @escaping() -> ()) {
       
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: actionButtonTitle, style: .default) { action in
            completion()
        }
        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)

        present(alertController, animated: true, completion: nil)
    }
    
    func editRecordAlert(with title: String, _ message: String, _ actionButtonTitle: String, _ cancelButtonTitle: String, _ placeholder: String, _ defaultTitle: String, completion: @escaping(String) -> ()) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: actionButtonTitle, style: .default) { action in
            completion(alertController.textFields?.first?.text ?? "")
        }
        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        actionButton.isEnabled = false
        alertController.addAction(actionButton)
        alertController.addAction(cancelButton)
        
        alertController.addTextField { (textField) in
            textField.text = defaultTitle
            textField.placeholder = placeholder
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                {_ in
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    actionButton.isEnabled = textIsNotEmpty
            })
        }
        present(alertController, animated: true, completion: nil)
    }
}
