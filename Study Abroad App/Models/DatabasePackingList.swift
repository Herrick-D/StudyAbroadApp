//
//  DatabasePackingListItem.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 10/7/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

struct DatabasePackingList {
    let key: String
    let listName: String
    let addedByUser: String
    let region: String
    let length: String
    let seasons: String
    let sex: String
    let ref: DatabaseReference?
    var items: [DatabasePackingListItem] = []
    
    //addedByUser: String,
    init(listName: String, addedByUser: String, region: String, length: String, seasons: String, sex: String, key: String = "") {
        self.key = key
        self.listName = listName
        self.addedByUser = addedByUser
        self.region = region
        self.length = length
        self.seasons = seasons
        self.sex = sex
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        listName = snapshotValue["listName"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        region = snapshotValue["region"] as! String
        length = snapshotValue["length"] as! String
        seasons = snapshotValue["seasons"] as! String
        sex = snapshotValue["sex"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "listName": listName,
            //"addedByUser": addedByUser,
            "region": region,
            "length": length,
            "seasons": seasons,
            "sex": sex
        ]
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count+=1
        }
        return count
    }
    
}
    


