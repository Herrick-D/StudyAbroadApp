//
//  BLCategoriesViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 11/13/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class BLCategoriesViewController: UITableViewController {

    //Properties
    
    var databaseRef: DatabaseReference?
    var ref = Database.database().reference()
    var categories: [BudgetListCategory] = []
    var uid: String?
    var budgetTotal: Int?
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:
                Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
                IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BLCategory", for: indexPath)
        let budgetListCat = categories[indexPath.row]
        configureText(for: cell, with: budgetListCat)
        configureQuantity(for: cell, with: budgetListCat)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
                UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let budgetListCat = categories[indexPath.row]
            budgetListCat.ref.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath:
                IndexPath) {
        let key = categories[indexPath.row].key
        let ref = databaseRef!
        let categoryRef = ref.child("Categories")
        
        let alert = UIAlertController(title: "Categories",
                                      message: "Edit Category",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let categoryName = alert.textFields![0]
                                        let value = ["category": categoryName.text!] as
                                            [String : Any]
                                        
                                        let budgetListRef = categoryRef.child(key!)
                                        budgetListRef.updateChildValues(value)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField { textCategory in
            textCategory.placeholder = "Category (Food, Entertainment, etc.)"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetList = categories[indexPath.row]
        performSegue(withIdentifier: "ShowBudgetListItems", sender: budgetList)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
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
    
    func configureText(for cell: UITableViewCell, with item: BudgetListCategory){
        let label = cell.viewWithTag(2000) as! UILabel
        label.text = item.category
    }
    
    func configureQuantity(for cell: UITableViewCell, with item: BudgetListCategory){
        let label1 = cell.viewWithTag(2001) as! UILabel
        label1.text = "$\(item.total!)"
    }
    
    
    @IBAction func addBLCat(_ sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            let ref = databaseRef!
            let categoryRef = ref.child("Categories")
            let categoryKey = categoryRef.childByAutoId().key
           
            
            let alert = UIAlertController(title: "Categories",
                                          message: "Add Category",
                                          preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save",
                                           style: .default) { action in
                                            let categoryName = alert.textFields![0]
                                            let values = ["category": categoryName.text!,
                                                          "total": 0,
                                                          "key": "\(String(describing: categoryKey))",
                                                "ref": "\(String(describing: categoryRef))"]
                                                as [String : Any]
                                            
                                            let budgetListRef = categoryRef.child(categoryKey)
                                            budgetListRef.setValue(values)
            }
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)
            alert.addTextField { textName in
                textName.placeholder = "Category (Food, Entertainment, etc.)"
            }
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBudgetListItems" {
            if let indexpath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! BLItemsViewController
                controller.databaseRef = categories[indexpath.row].ref
            }
        }
    }
    
    func displayLists() {
        if let databaseRef = databaseRef?.child("Categories") {
            databaseRef.queryOrdered(byChild: "category").observe(.value, with: { snapshot in
                var newLists: [BudgetListCategory] = []
                var total = 0
                for category in snapshot.children {
                    let budgetCategories = BudgetListCategory(snapshot: category as! DataSnapshot)
                    newLists.append(budgetCategories)
                    total = total + budgetCategories.total!
                }
                self.categories = newLists
                self.budgetTotal = total
                let value = ["total": self.budgetTotal!] as [String:Any]
                let budgetDatabaseRef = self.databaseRef
                budgetDatabaseRef?.updateChildValues(value)
                self.tableView.reloadData()
            })
        }
        
    }
}
