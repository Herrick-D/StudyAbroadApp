//
//  DatabasePackingListItem.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 10/7/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

class DatabasePackingList{//}: NSObject {
    
    var length: String!
    var listName: String!
    var region: String!
    var seasons: String!
    var sex: String!
    var shared: Bool!
    var ref: DatabaseReference!
    var key: String!
    
    
//    //let key: String
//    let listName: String
//    //let addedByUser: String
//    let region: String
//    let length: String
//    let seasons: String
//    let sex: String
//    let shared: Bool
//    let ref: DatabaseReference?
//    var items: [DatabasePackingListItem] = []
//
//    //addedByUser: String,
    init(listName: String, region: String, length: String, seasons: String, sex: String, shared: Bool, key: String = "") {
        self.key = key
        self.listName = listName
        //self.addedByUser = addedByUser
        self.region = region
        self.length = length
        self.seasons = seasons
        self.sex = sex
        self.shared = shared
        self.ref = Database.database().reference()
    }
    
//    convenience init() {
//        self.init(listName: "list", region: "region", length: "length", seasons: "seasons", sex: "sex", shared: "shared")
//    }

    init(snapshot: DataSnapshot) {
        
        //let snapshotValue = snapshot.value as! NSDictionary
        self.listName = (snapshot.value as! NSDictionary)["listName"] as! String
        self.region = (snapshot.value as! NSDictionary)["region"] as! String
        self.length = (snapshot.value as! NSDictionary)["length"] as! String
        self.seasons = (snapshot.value as! NSDictionary)["seasons"] as! String
        self.sex = (snapshot.value as! NSDictionary)["sex"] as! String
        //addedByUser = snapshotValue["addedByUser"] as! String
        self.shared = (snapshot.value as! [String: AnyObject])["shared"] as! Bool
        self.key = snapshot.key
        self.ref = snapshot.ref
    }
//
    func toAnyObject() -> Any {
        return [
            "listName": listName,
            "region": region,
            "length": length,
            "seasons": seasons,
            "sex": sex,
            //"addedByUser": addedByUser,
            "shared": shared
        ]
    }
    
//    func removeValue() {
//FIRDatabase.database().reference().child(Users).child(FIRAuth.auth()!.currentUser!.uid).child("instagramLink").removeValueWithCompletionBlock({ (error, refer) in
//    if error != nil {
//    print(error)
//    } else {
//    print(refer)
//    print("Child Removed Correctly")
//    }
//        })
//    }
    
//    func countUncheckedItems() -> Int {
//        var count = 0
//        for item in items where !item.checked {
//            count+=1
//        }
//        return count
//    }
    
}
    


