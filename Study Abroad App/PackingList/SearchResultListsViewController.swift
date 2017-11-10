//
//  SearchResultListsViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 11/6/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class SearchResultListsViewController: UITableViewController, UINavigationControllerDelegate {
    
    // Properties
    
    var regionText: String?
    var lengthText: String?
    var seasonsText: String?
    var sexText: String?
    let databaseRef = Database.database().reference(withPath: "SharedPackingLists")
    var lists: [SearchPackingLists] = []
    
    //var backBarButtonItem: UIBarButtonItem!
    var doneBarButtonItem: UIBarButtonItem!
    
    //View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Search Results"
        backgroundImage()
        loadResultLists()
        //makeBackBarButton()
        makeDoneBarButton()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Table view methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultListsCell", for: indexPath)
        cell.selectionStyle = .none
        let packingList: SearchPackingLists
        packingList = lists[indexPath.row]
        cell.textLabel?.text = packingList.region
        cell.detailTextLabel?.text = "\(packingList.seasons!), \(packingList.length!), \(packingList.sex!)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let packingList = lists[indexPath.row]
        
        performSegue(withIdentifier: "SearchListItemSegue", sender: packingList)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor(white: 1, alpha: 0.75)
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.borderWidth = 0.5
        cell.textLabel?.textColor = UIColor.black
    }
    
    func backgroundImage() {
        let backgroundImage = UIImage(named: "for-packing.jpeg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundColor = .lightGray
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchListItemSegue" {
            if let indexpath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! SearchResultItemsViewController
                controller.databaseRef = lists[indexpath.row].ref
                controller.packingList = lists[indexpath.row]
                
            }
        }
    }
    
    func loadResultLists() {
        databaseRef.child(regionText!).observe(.value, with: { (snapshot) in
            var packingListArray: [SearchPackingLists] = [SearchPackingLists]()
            var newLists = [SearchPackingLists]()
            for packingList in snapshot.children {
                let packList = SearchPackingLists(snapshot: packingList as! DataSnapshot)
                newLists.append(packList)
            }

            for lists in newLists {
                let region = lists.region
                let length = lists.length
                let seasons = lists.seasons
                let sex = lists.sex

                if (sex == self.sexText && (sex == "Male" || sex == "Female")) {
                    if (region == self.regionText && length == self.lengthText && seasons == self.seasonsText) {
                        packingListArray.append(lists)
                    }
                    else if (region == self.regionText && seasons == self.seasonsText) {
                        packingListArray.append(lists)
                    }
                    else if (region == self.regionText && length == self.lengthText) {
                        packingListArray.append(lists)
                    }
                    else if (region == self.regionText) {
                        packingListArray.append(lists)
                    }
                }
                if self.sexText == "Other" {
                    if (region == self.regionText && length == self.lengthText && seasons == self.seasonsText) {
                        packingListArray.append(lists)
                    }
                    else if (region == self.regionText && seasons == self.seasonsText) {
                        packingListArray.append(lists)
                    }
                    else if (region == self.regionText && length == self.lengthText) {
                        packingListArray.append(lists)
                    }
                    else if (region == self.regionText) {
                        packingListArray.append(lists)
                    }
                }
            }
            self.lists = packingListArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
        
    }
    
//    func makeBackBarButton() {
//        backBarButtonItem = UIBarButtonItem(title: "Back",
//                                            style: .plain,
//                                            target: self,
//                                            action: #selector(backButtonDidTouch))
//        navigationItem.leftBarButtonItem = backBarButtonItem
//    }
    
//    @objc func backButtonDidTouch() {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    func makeDoneBarButton() {
        doneBarButtonItem = UIBarButtonItem(title: "Done",
                                            style: .plain,
                                            target: self,
                                            action: #selector(doneButtonDidTouch))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
    }
    
    @objc func doneButtonDidTouch() {
        self.dismiss(animated: true, completion: nil)
    }

}
