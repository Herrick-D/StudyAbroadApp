//
//  DatabasePackingListItem.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 10/9/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

class DatabasePackingListItem {
    var key: String!
    var itemName: String!
    var quantity: String!
    var checked: Bool!
    var ref: DatabaseReference!
    
    init(itemName: String, quantity: String, checked: Bool, key: String = "") {
        self.key = key
        self.itemName = itemName
        self.quantity = quantity
        self.checked = checked
        self.ref = Database.database().reference()
    }
    
    init(snapshot: DataSnapshot) {
        self.itemName = (snapshot.value as! NSDictionary)["itemName"] as! String
        self.quantity = (snapshot.value as! NSDictionary)["quantity"] as! String
        self.checked = (snapshot.value as! [String: AnyObject])["checked"] as! Bool
        self.key = snapshot.key
        self.ref = snapshot.ref
        
    }
    
    func toAnyObject() -> Any {
        return ["itemName": itemName,
                "quantity": quantity,
                "checked": checked]
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
}
