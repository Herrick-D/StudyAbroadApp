//
//  BLItemsViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 11/13/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class BLItemsViewController: UITableViewController {

    //Properties
    
    var databaseRef: DatabaseReference?
    var ref = Database.database().reference()
    var items: [BudgetListItem] = []
    var uid: String?
    
    //UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            let currUser = Auth.auth().currentUser
            uid = currUser?.uid
        }
        backgroundImage()
        displayLists()
    }
    
    //UITableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BLItems", for: indexPath)
        let budgetListItems = items[indexPath.row]
        configureText(for: cell, with: budgetListItems)
        configureQuantity(for: cell, with: budgetListItems)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let budgetListItem = items[indexPath.row]
            budgetListItem.ref.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let key = items[indexPath.row].key
        let ref = databaseRef!
        let itemRef = ref.child("Items")
        
        let alert = UIAlertController(title: "Budget Items",
                                      message: "Edit Item",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let itemName = alert.textFields![0]
                                        let cost = alert.textFields![1]
                                        let value = ["item": itemName.text!,
                                                     "cost": cost.text!] as [String : Any]
                                        
                                        let budgetListRef = itemRef.child(key!)
                                        budgetListRef.updateChildValues(value)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField { textItem in
            textItem.placeholder = "Item"
        }
        alert.addTextField { textCost in
            textCost.placeholder = "Cost"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.75)
        cell.textLabel?.textColor = UIColor.black
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.borderWidth = 0.5
    }
    
    //Functions
    
    func backgroundImage() {
        let backgroundImage = UIImage(named: "for-budget.jpeg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundColor = .lightGray
    }
    
    func configureText(for cell: UITableViewCell, with item: BudgetListItem){
        let label = cell.viewWithTag(2100) as! UILabel
        label.text = item.item
    }
    
    func configureQuantity(for cell: UITableViewCell, with item: BudgetListItem){
        let label = cell.viewWithTag(2101) as! UILabel
        label.text = item.cost
    }
    
    @IBAction func addBLItems(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            let ref = databaseRef!
            let key = ref.key
            let itemRef = ref.child("Items")
            let itemKey = itemRef.childByAutoId().key
            
            
            let alert = UIAlertController(title: "Budget Items",
                                          message: "Add Items",
                                          preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save",
                                           style: .default) { action in
                                            let itemName = alert.textFields![0]
                                            let cost = alert.textFields![1]
                                            let values = ["item": itemName.text!,
                                                          "cost": cost.text!,
                                                "key": "\(String(describing: itemKey))",
                                                "ref": "\(String(describing: itemRef))"] as [String : Any]
                                            
                                            let budgetListRef = itemRef.child(itemKey)
                                            budgetListRef.setValue(values)
            }
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)
            alert.addTextField { textItem in
                textItem.placeholder = "Item"
            }
            alert.addTextField { textCost in
                textCost.placeholder = "Cost"
            }
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func displayLists() {
        if let databaseRef = databaseRef?.child("Items") {
            databaseRef.queryOrdered(byChild: "item").observe(.value, with: { snapshot in
                var newLists: [BudgetListItem] = []
                for item in snapshot.children {
                    let budgetItems = BudgetListItem(snapshot: item as! DataSnapshot)
                    newLists.append(budgetItems)
                }
                self.items = newLists
                self.tableView.reloadData()
            })
        }
        
    }
    
}


















