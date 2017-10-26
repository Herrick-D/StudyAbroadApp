//
//  AllListsViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/26/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    var lists: [DatabasePackingList] = []
    let databaseListRef = Database.database().reference(withPath: "Packing List")
    let usersRef = Database.database().reference(withPath: "Users")
    var user: User!
    var backBarButtonItem: UIBarButtonItem!
    
    //var dataModel: DataModel!
    
    //var packingList: DatabasePackingList!
    
    weak var delegate: ListDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImage(named: "for-packing.jpeg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        //tableView.tableFooterView = UIView(frame: CGRect)
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundColor = .lightGray
        
        backBarButtonItem = UIBarButtonItem(title: "Back",
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonDidTouch))
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        databaseListRef.queryOrdered(byChild: "Packing List").observe(.value, with: { snapshot in
            var newItems: [DatabasePackingList] = []
            
            for item in snapshot.children {
                let packingList = DatabasePackingList(snapshot: item as! DataSnapshot)
                newItems.append(packingList)
            }
            
            self.lists = newItems
            self.tableView.reloadData()
        })
    }

    @objc func backButtonDidTouch() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let features = storyboard.instantiateViewController(withIdentifier: "FeaturesViewController") as! FeaturesViewController //UINavigationController
        self.present(features, animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backBarButtonItem = UIBarButtonItem(title: "Back",
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonDidTouch))
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        databaseListRef.queryOrdered(byChild: "Packing List").observe(.value, with: { snapshot in
            var newItems: [DatabasePackingList] = []
            
            for item in snapshot.children {
                let packingList = DatabasePackingList(snapshot: item as! DataSnapshot)
                newItems.append(packingList)
            }
            
            self.lists = newItems
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let packingList = lists[indexPath.row]
            performSegue(withIdentifier: "ShowPackingList", sender: packingList)
        
//        dataModel.indexOfSelectedPackingList = indexPath.row
//        let packingList = dataModel.lists[indexPath.row]
//        performSegue(withIdentifier: "ShowPackingList", sender: packingList)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
        //return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        let packingList = lists[indexPath.row]
        //let packingList = dataModel.lists[indexPath.row]
        cell.textLabel?.text = packingList.listName
        cell.accessoryType = .detailDisclosureButton
        cell.detailTextLabel?.text = "\(packingList.countUncheckedItems()) Remaining"
        let count = packingList.countUncheckedItems()
        if lists.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All Done!"
        } else {
            cell.detailTextLabel!.text = "\(count) Remaining"
        }
        return cell
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPackingList" {
            let controller = segue.destination as! PackingListViewController
            controller.items = [sender as! DatabasePackingListItem]
        } else if segue.identifier == "AddPackingList" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.packingListToEdit = nil
        }
    }
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding packingList: DatabasePackingList) {
        
//        dataModel.lists.append(packingList)
//        dataModel.sortPackingLists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
//
//    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing packingList: DatabasePackingList){
//        dataModel.sortPackingLists()
//        tableView.reloadData()
//        dismiss(animated: true, completion: nil)
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let packingList = lists[indexPath.row]
        controller.packingListToEdit = packingList
        present(navigationController, animated: true, completion: nil)
    }
    
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        //was the back button tapped?
//        if viewController === self {
//            dataModel.indexOfSelectedPackingList = -1
//        }
//    }
    
}
