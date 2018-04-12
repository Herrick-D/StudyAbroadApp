//
//  AllListsViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/26/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class AllListsViewController: UITableViewController, UINavigationControllerDelegate {
    
    //Properties
    
    var lists: [DatabasePackingList] = []
    var databaseRef: DatabaseReference!
    let ref = Database.database().reference(withPath: "Packing Lists")
    let usersRef = Database.database().reference(withPath: "Users")
    var user: User!
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
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let packingList: DatabasePackingList
        packingList = lists[indexPath.row]
        cell.textLabel?.text = packingList.listName
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let packingList = lists[indexPath.row]
            packingList.ref.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier:
                    "ListDetailNavigationController") as! UINavigationController
        
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.packingListToEdit = lists[indexPath.row]
        controller.databaseRef = lists[indexPath.row].ref
        present(navigationController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let packingList = lists[indexPath.row]
        performSegue(withIdentifier: "ShowPackingList", sender: packingList)
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.75)
        cell.textLabel?.textColor = UIColor.black
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.borderWidth = 0.5
    }
    
    //Functions
    
    func backgroundImage() {
        let backgroundImage = UIImage(named: "for-packing.jpeg")
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
        let features = storyboard.instantiateViewController(withIdentifier:
                    "FeaturesViewController") as! FeaturesViewController
        self.present(features, animated: true, completion: nil)
    }
    
    func presentPackingListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let packingList = storyboard.instantiateViewController(withIdentifier:
                    "PackingListViewController") as! PackingListViewController
        self.present(packingList, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPackingList" {
            let navigationController = segue.destination as! UINavigationController
            let listDetailVC = navigationController.topViewController as! ListDetailViewController
            listDetailVC.packingListToEdit = nil
            listDetailVC.databaseRef = Database.database().reference(fromURL:
                        "https://studyabroad-42803.firebaseio.com/")
            listDetailVC.user = user
        }
        else if segue.identifier == "ShowPackingList" {
            if let indexpath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! PackingListViewController
                controller.databaseRef = lists[indexpath.row].ref
                controller.packingList = lists[indexpath.row]

            }
        }
    }
    
    func displayLists() {
        if Auth.auth().currentUser != nil {
            let currUser = Auth.auth().currentUser
            if let currUser = currUser {
                let uid = currUser.uid
                databaseRef.child(uid).child("PackingList").observe(.value, with: { (snapshot) in
                    var newLists = [DatabasePackingList]()
                    for packingList in snapshot.children {
                        let packList = DatabasePackingList(snapshot: packingList as! DataSnapshot)
                        newLists.insert(packList, at: 0)
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

