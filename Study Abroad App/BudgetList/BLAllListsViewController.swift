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

    var lists: [BudgetList] = []
    var databaseRef: DatabaseReference!
    let ref = Database.database().reference()
    //var user: User!
    var backBarButtonItem: UIBarButtonItem!
    
    //UIViewController Lifecycle
    
    override func viewDidLoad() {
        databaseRef = Database.database().reference().child("Users")
        super.viewDidLoad()
        backgroundImage()
        makeBackButton()
        displayLists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        databaseRef = Database.database().reference().child("Users")
        super.viewWillAppear(animated)
        backgroundImage()
        makeBackButton()
    }
    
    //UITableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BLCell", for: indexPath)
        let packingList: BudgetList
        packingList = lists[indexPath.row]
        cell.textLabel?.text = packingList.category
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let packingList = lists[indexPath.row]
            packingList.ref.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //alert to edit
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetList = lists[indexPath.row]
        performSegue(withIdentifier: "ShowBudgetList", sender: budgetList)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.75)
        cell.textLabel?.textColor = UIColor.black
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.borderWidth = 0.5
    }
    
    //Functions
    
    func backgroundImage() {
        let backgroundImage = UIImage(named: "for-login.jpeg")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBudgetList" {
            if let indexpath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! BLCategoriesViewController
                controller.databaseRef = lists[indexpath.row].ref
                controller.budgetList = lists[indexpath.row]
                
            }
        }
    }
    
    func displayLists() {
        if Auth.auth().currentUser != nil {
            let currUser = Auth.auth().currentUser
            if let currUser = currUser {
                let uid = currUser.uid
                databaseRef.child(uid).child("BudgetList").observe(.value, with: { (snapshot) in
                    var newLists = [BudgetList]()
                    for packingList in snapshot.children {
                        let packList = BudgetList(snapshot: packingList as! DataSnapshot)
                        newLists.append(packList)
                    }
                    self.lists = newLists
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
}






























