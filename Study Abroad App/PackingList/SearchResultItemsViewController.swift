//
//  SearchResultItemsViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 11/9/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class SearchResultItemsViewController: UITableViewController {

    var rootRef = Database.database().reference(fromURL: "https://studyabroad-42803.firebaseio.com/")
    var databaseRef: DatabaseReference?
    var items: [SearchPackingListItem] = []
    var user: User!
    var packingList: SearchPackingLists!
    
    var backBarButtonItem: UIBarButtonItem!
    var saveBarButtonItem: UIBarButtonItem!
    
    //View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeSaveBarButton()
        backgroundImage()
        if let packingList = packingList {
            title = "Packing List"
        }
        loadListItems()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //UITableView Methods
    
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.75)
        cell.textLabel?.textColor = UIColor.black
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.borderWidth = 0.5
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPackingListItemCell",
                                                 for: indexPath)
        let packingListItem = items[indexPath.row]
        configureText(for: cell, with: packingListItem)
        configureQuantity(for: cell, with: packingListItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
    //Functions
    
    func backgroundImage() {
        let backgroundImage = UIImage(named: "for-packing.jpeg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundColor = .lightGray
    }
    
    func makeBackBarButton() {
        backBarButtonItem = UIBarButtonItem(title: "Back",
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonDidTouch))
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func makeSaveBarButton() {
        saveBarButtonItem = UIBarButtonItem(title: "Save",
                                            style: .plain,
                                            target: self,
                                            action: #selector(saveButtonDidTouch))
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    @objc func backButtonDidTouch() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureText(for cell: UITableViewCell, with item: SearchPackingListItem){
        let label = cell.viewWithTag(1700) as! UILabel
        label.text = item.itemName
    }
    
    func configureQuantity(for cell: UITableViewCell, with item: SearchPackingListItem){
        let label = cell.viewWithTag(1800) as! UILabel
        label.text = item.quantity
    }
    
    @IBAction func saveButtonDidTouch(_ sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            let currUser = Auth.auth().currentUser
            if let currUser = currUser {
                let uid = currUser.uid
                
                let userListRef = rootRef.child("Users").child(uid).child("PackingList")
                let userListKey = userListRef.childByAutoId().key
                
                let alert = UIAlertController(title: "Save Packing List",
                                              message: "Do you want to save this packing list?",
                                              preferredStyle: .alert)
                
                let saveAction = UIAlertAction(title: "Save",
                                               style: .default) { action in
                    let listName = alert.textFields![0]
                    self.databaseRef?.observe(.value, with: {(snapshot) in
                        let params = snapshot.value as! [String: Any]
                        let region = params["region"] as! String
                        let length = params["length"] as! String
                        let seasons = params["seasons"] as! String
                        let sex = params["sex"] as! String
                        
                        let listValues = ["listName": listName.text!,
                                "region": region,
                                "length": length,
                                "seasons": seasons,
                                "sex": sex,
                                "shared": false,
                                "ref": "\(String(describing:(userListRef)))",
                                "key": "\(String(describing:(userListKey)))"] as [String: Any]
                        userListRef.child(userListKey).setValue(listValues)
                        
                        let itemRef = userListRef.child(userListKey).child("items")
                        
                        self.databaseRef?.child("items").queryOrdered(byChild:
                                    "itemName").observe(.value, with: { (snapshot) in
                            for items in snapshot.children {
                                let key = userListRef.childByAutoId().key
                                let item = SearchPackingListItem(snapshot: items as! DataSnapshot)
                                let itemValues = ["itemName": item.itemName,
                                                  "quantity": item.quantity,
                                                  "checked": false,
                                                  "key": "\(String(describing:(key)))", //wrong key
                                    "ref": "\(String(describing:(itemRef)))"] as [String: Any]
                                itemRef.child("\(key)").setValue(itemValues)
                            }
                        })
                    })
                }
                let cancelAction = UIAlertAction(title: "Cancel",
                                                 style: .default)
                alert.addTextField { textListName in
                    textListName.placeholder = "List Name"
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
                var newItems: [SearchPackingListItem] = []
                for item in snapshot.children {
                    let packingListItem = SearchPackingListItem(snapshot: item as! DataSnapshot)
                    newItems.append(packingListItem)
                }
                self.items = newItems
                self.tableView.reloadData()
            })
        }
    }
}


