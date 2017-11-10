//
//  SearchPackingListItem.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 11/9/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

class SearchPackingListItem {
    var key: String!
    var itemName: String!
    var quantity: String!
    var ref: DatabaseReference!
    
    init(itemName: String, quantity: String, key: String = "") {
        self.key = key
        self.itemName = itemName
        self.quantity = quantity
        self.ref = Database.database().reference()
    }
    
    init(snapshot: DataSnapshot) {
        self.itemName = (snapshot.value as! NSDictionary)["itemName"] as! String
        self.quantity = (snapshot.value as! NSDictionary)["quantity"] as! String
        self.key = snapshot.key
        self.ref = snapshot.ref
        
    }
    
    func toAnyObject() -> Any {
        return ["itemName": itemName,
                "quantity": quantity]
    }
}

