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
        //displayLists()
    }
    
    //UITableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            //cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //let packingList = lists[indexPath.row]
        let packingList: DatabasePackingList
        packingList = lists[indexPath.row]
        cell.textLabel?.text = packingList.listName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let packingList = lists[indexPath.row]
            //packingList.self?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let packingList = lists[indexPath.row]
        
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
        let features = storyboard.instantiateViewController(withIdentifier: "FeaturesViewController") as! FeaturesViewController //UINavigationController
        self.present(features, animated: true, completion: nil)
    }
    
    func presentPackingListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let packingList = storyboard.instantiateViewController(withIdentifier: "PackingListViewController") as! PackingListViewController
        self.present(packingList, animated: true, completion: nil)
        //self.navigationController?.pushViewController(allLists, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPackingList" {
            let navigationController = segue.destination as! UINavigationController
            let listDetailVC = navigationController.topViewController as! ListDetailViewController
            listDetailVC.packingListToEdit = nil
            listDetailVC.databaseRef = Database.database().reference(fromURL: "https://studyabroad-42803.firebaseio.com/")
            listDetailVC.user = user
        }
    }
    
    func displayLists() {
        if Auth.auth().currentUser != nil {
            let currUser = Auth.auth().currentUser
            if let currUser = currUser {
                let uid = currUser.uid
                //let listRef = databaseRef.child("Users").child(uid).child("PackingList")
                
                databaseRef.child(uid).child("PackingList").observe(.value, with: { (snapshot) in
                    var newLists: [DatabasePackingList] = []
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        if let dictionary = snap.value as? [String: AnyObject] {
                            let list = DatabasePackingList()
                            //list.setValuesForKeys(dictionary)
                            
                            list.listName = dictionary["listName"] as! String
                            print(list.listName)
                            newLists.append(list)
                            //self.lists.append(list)
//
                        }
                        self.lists = newLists
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            //self.tableView.reloadData()
                        //}
                    }
                    
                    
                    
                    
                    //                    if snapshot.childrenCount > 0 {
//                        self.lists.removeAll()
//                        for list in snapshot.children.allObjects as! [DataSnapshot] {
//                            //let snap = list as! DataSnapshot
//                            let listObject = list.value as? [String: AnyObject]
//                            let listName = listObject?["listName"]
//                            let region = listObject?["region"]
//                            let length = listObject?["length"]
//                            let seasons = listObject?["seasons"]
//                            let sex = listObject?["sex"]
//                            let shared = listObject?["shared"]
//
//                            //let listData = DatabasePackingList(listName: (listName as! String?)!, region: (region as! String?)!, length: (length as! String?)!, seasons: (seasons as! String?)!, sex: (sex as! String?)!, shared: ((shared as! Bool?) != nil))
//                            self.lists.append(listData)
//                        }
//
                    
//                    }
                    
                })
            }
        }
    }
}


