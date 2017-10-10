//
//  PackingListViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/26/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class PackingListViewController: UITableViewController { //}, ItemDetailViewControllerDelegate {
    //Properties:
    var items: [DatabasePackingListItem] = []
    let ref = Database.database().reference(withPath: "packingList-items")
    let usersRef = Database.database().reference(withPath: "online")
    var user: User!
    
    
    
    
    
    
    //var packingList: PackingList!
    
//    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: DatabasePackingListItem) {
//        let newRowIndex = packingList.items.count
//        packingList.items.append(item)
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
//        dismiss(animated: true, completion: nil)
//    }
//
//    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: DatabasePackingListItem) {
//        if let index = items. {
//        //if let index = packingList.items.index(of: item) {
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) {
//                configureText(for: cell, with: item)
//                configureQuantity(for: cell, with: item)
//            }
//        }
//        dismiss(animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        ref.queryOrdered(byChild: "itemName").observe(.value, with: { snapshot in
            var newItems: [DatabasePackingListItem] = []
            for item in snapshot.children {
                let packingListItem = DatabasePackingListItem(snapshot: item as! DataSnapshot)
                newItems.append(packingListItem)
            }
            self.items = newItems
            self.tableView.reloadData()
        })
//        Auth.auth().addStateDidChangeListener { auth, user in
//            guard let user = user else { return }
//            self.user = User(authData: user)
//            let currentUserRef = self.usersRef.child(self.user.uid)
//            currentUserRef.setValue(self.user.email)
//            currentUserRef.onDisconnectRemoveValue()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        //return packingList.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackingListItem", for: indexPath)
        let packingListItem = items[indexPath.row]
        
        //let item = packingList.items[indexPath.row]
        configureText(for: cell, with: packingListItem)
        configureCheckmark(for: cell, with: packingListItem)
        configureQuantity(for: cell, with: packingListItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Packing List Item",
                                      message: "Edit Item",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
            let item = alert.textFields![0]
            let quantity = alert.textFields![1]
            let packingListItem = DatabasePackingListItem(itemName: item.text!, quantity: quantity.text!, checked: false)
            let packingListItemRef = self.ref.child((item.text?.lowercased())!)
            packingListItemRef.setValue(packingListItem.toAnyObject())
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField { textItem in
            textItem.placeholder = "Item"
        }
        alert.addTextField { textQuantity in
            textQuantity.placeholder = "Quantity"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            var packingListItem = items[indexPath.row]
            //let item = packingList.items[indexPath.row]
            packingListItem.toggleChecked()
            configureCheckmark(for: cell, with: packingListItem)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let packingListItem = items[indexPath.row]
            packingListItem.ref?.removeValue()
        }
//        items.remove(at: indexPath.row)
//        //packingList.items.remove(at: indexPath.row)
//        let indexPaths = [indexPath]
//        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: DatabasePackingListItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "✓"
        } else {
            label.text = ""
        }
        label.textColor = view.tintColor
    }
    
    func configureText(for cell: UITableViewCell, with item: DatabasePackingListItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.itemName
    }
    
    func configureQuantity(for cell: UITableViewCell, with item: DatabasePackingListItem){
        let label = cell.viewWithTag(1500) as! UILabel
        label.text = item.quantity
    }
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Packing List Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
            let item = alert.textFields![0]
            let quantity = alert.textFields![1]
            let packingListItem = DatabasePackingListItem(itemName: item.text!, quantity: quantity.text!, checked: false)
            let packingListItemRef = self.ref.child((item.text?.lowercased())!)
            packingListItemRef.setValue(packingListItem.toAnyObject())
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField { textItem in
            textItem.placeholder = "Item"
        }
        alert.addTextField { textQuantity in
            textQuantity.placeholder = "Quantity"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "AddItem" {
//            let navigationController = segue.destination as! UINavigationController
//            let controller = navigationController.topViewController as! ItemDetailViewController
//            controller.delegate = self
//        } else if segue.identifier == "EditItem" {
//            let navigationController = segue.destination as! UINavigationController
//            let controller = navigationController.topViewController as! ItemDetailViewController
//            controller.delegate = self
//            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
//                controller.itemToEdit = packingList.items[indexPath.row]
//            }
//        }
//    }
}
