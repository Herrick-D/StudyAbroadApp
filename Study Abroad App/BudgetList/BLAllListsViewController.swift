//
//  BLAllListsViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 11/13/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class BLAllListsViewController: UITableViewController {
    //Properties:
    var databaseRef: DatabaseReference?
    var ref = Database.database().reference(fromURL: "https://studyabroad-42803.firebaseio.com/")
    var lists: [BudgetListName] = []
    var uid: String?
    var backBarButtonItem: UIBarButtonItem!
    
    //View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("Users")
        if Auth.auth().currentUser != nil {
            let currUser = Auth.auth().currentUser
            uid = currUser?.uid
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundImage()
        displayLists()
        makeBackButton()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.75)
        cell.textLabel?.textColor = UIColor.black
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.borderWidth = 0.5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BLCell", for: indexPath)
        let budgetList = lists[indexPath.row]
        cell.textLabel?.text = budgetList.listName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let key = lists[indexPath.row].key
        let ref = databaseRef!.child(uid!).child("BudgetLists")
        let alert = UIAlertController(title: "Budget List",
                                      message: "Add Budget List",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let listName = alert.textFields![0]
                                        let values = ["listName": listName.text!,
                                                      "key": key as Any,
                                            "ref": "\(String(describing: ref))"] as [String : Any]
                                        
                                        let budgetListRef = ref.child(key!)
                                        budgetListRef.setValue(values)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField { textName in
            textName.placeholder = "Budget List Name"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetList = lists[indexPath.row]
        performSegue(withIdentifier: "ShowBudgetListCategories", sender: budgetList)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let budgetList = lists[indexPath.row]
            budgetList.ref?.removeValue()
        }
    }
    
    //Functions
    
    func backgroundImage() {
        let backgroundImage = UIImage(named: "for-budget.jpeg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundColor = .lightGray
    }
    
    func makeBackButton() {
        backBarButtonItem = UIBarButtonItem(title: "Back",
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonDidTouch))
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func backButtonDidTouch() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let features = storyboard.instantiateViewController(withIdentifier: "FeaturesViewController") as! FeaturesViewController //UINavigationController
        self.present(features, animated: true, completion: nil)
    }
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            let ref = databaseRef!.child(uid!).child("BudgetLists")
            let key = ref.childByAutoId().key
            
            let alert = UIAlertController(title: "Budget List",
                                          message: "Add Budget List",
                                          preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save",
                                           style: .default) { action in
                                            let listName = alert.textFields![0]
                                            let values = ["listName": listName.text!,
                                                          "key": "\(String(describing: key))",
                                                "ref": "\(String(describing: ref))"] as [String : Any]
                                            
                                            let budgetListRef = ref.child(key)
                                            budgetListRef.setValue(values)
            }
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)
            alert.addTextField { textName in
                textName.placeholder = "Budget List Name"
            }
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBudgetListCategories" {
            if let indexpath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! BLCategoriesViewController
                controller.databaseRef = lists[indexpath.row].ref
            }
        }
    }

    
    func displayLists() {
        databaseRef!.child(uid!).child("BudgetLists").observe(.value, with: { snapshot in
            var newLists: [BudgetListName] = []
            for list in snapshot.children {
                let budgetList = BudgetListName(snapshot: list as! DataSnapshot)
                newLists.insert(budgetList, at: 0)
            }
            self.lists = newLists
            self.tableView.reloadData()
        })
    }
}




















