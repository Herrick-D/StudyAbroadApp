//
//  DatabasePackingListItem.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 10/9/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

struct DatabasePackingListItem {
    let key: String
    let itemName: String
    let addedByUser: String
    let quantity: String
    let checked: Bool
    let ref: DatabaseReference?
    
    init(itemName: String, addedByUser: String, quantity: String, checked: Bool, key: String = "") {
        self.key = key
        self.itemName = itemName
        self.addedByUser = addedByUser
        self.quantity = quantity
        self.checked = checked
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        itemName = snapshotValue["itemName"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        quantity = snapshotValue["quantity"] as! String
        checked = snapshotValue["checked"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "itemName": itemName,
            "addedByUser": addedByUser,
            "quantity": quantity,
            "checked": checked,
        ]
    }
    
}
