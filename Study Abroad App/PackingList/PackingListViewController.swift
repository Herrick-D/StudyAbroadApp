//
//  PackingListViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/26/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class PackingListViewController: UITableViewController {
    //Properties:
    
    var databaseRef: DatabaseReference?
    var items: [DatabasePackingListItem] = []
    var user: User!
    var packingList: DatabasePackingList!
    
    //View Controller lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        loadListItems()
        print(databaseRef!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //UITableView Methods
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.75)
        cell.textLabel?.textColor = UIColor.black
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.borderWidth = 0.5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackingListItem", for: indexPath)
        let packingListItem = items[indexPath.row]
        configureText(for: cell, with: packingListItem)
        configureQuantity(for: cell, with: packingListItem)
        toggleCellCheckbox(cell, isCompleted: packingListItem.checked)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let itemKey = items[indexPath.row].key
        print(itemKey)
        let ref = databaseRef!.child("items")
        let alert = UIAlertController(title: "Packing List Item",
                                      message: "Edit Item",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let item = alert.textFields![0]
                                        let quantity = alert.textFields![1]
                                        let packingListItem = ["itemName": item.text!,
                                                               "quantity": quantity.text!,
                                                               "checked": false,
                                                               "key": itemKey,
                                                               "ref": "\(ref)"] as [String : Any]
                                        
                                        let packingListItemRef = ref.child(itemKey!)
                                        packingListItemRef.setValue(packingListItem)
                                        
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
            let toggleChecked = !packingListItem.checked
            toggleCellCheckbox(cell, isCompleted: toggleChecked)
            packingListItem.ref.updateChildValues(["checked": toggleChecked])
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
    }
    
    //Functions
    
    func backgroundImage() {
        let backgroundImage = UIImage(named: "for-packing.jpeg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundColor = .lightGray
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        let label = cell.viewWithTag(1001) as! UILabel
        if !isCompleted {
            label.text = ""
        } else {
            label.text = "✓"
        }
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
        if Auth.auth().currentUser != nil {
            let currUser = Auth.auth().currentUser
            if let currUser = currUser {
                let uid = currUser.uid
                
                let ref = databaseRef!.child("items")
                let key = ref.childByAutoId().key
                
                let alert = UIAlertController(title: "Packing List Item",
                                              message: "Add an Item",
                                              preferredStyle: .alert)
        
                let saveAction = UIAlertAction(title: "Save",
                                               style: .default) { action in
                                                let item = alert.textFields![0]
                                                let quantity = alert.textFields![1]
                                                let packingListItem = ["itemName": item.text!,
                                                                       "quantity": quantity.text!,
                                                                       "checked": false,
                                                                       "key": "\(key)",
                                                                       "ref": "\(ref)"] as [String : Any]
                                                
                                                let packingListItemRef = ref.child(key)
                                                packingListItemRef.setValue(packingListItem)
                                        
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
        }
    }
    
    func loadListItems() {
        if let databaseRef = databaseRef {
            databaseRef.child("items").queryOrdered(byChild: "itemName").observe(.value, with: { snapshot in
                var newItems: [DatabasePackingListItem] = []
                for item in snapshot.children {
                    let packingListItem = DatabasePackingListItem(snapshot: item as! DataSnapshot)
                    newItems.append(packingListItem)
                }
                self.items = newItems
                self.tableView.reloadData()
            })
        }
    }
}
