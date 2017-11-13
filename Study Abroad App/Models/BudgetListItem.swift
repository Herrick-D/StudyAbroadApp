//
//  BudgetListItem.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 11/13/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

class BudgetListItem {
    var itemName: String!
    var cost: Int!
    var ref: DatabaseReference!
    var key: String!
    
    init(itemName: String, cost: Int, key: String = "") {
        self.itemName = itemName
        self.cost = cost
        self.key = key
        self.ref = Database.database().reference()
    }
    
    init(snapshot: DataSnapshot) {
        self.itemName = (snapshot.value as! NSDictionary)["itemName"] as! String
        self.cost = (snapshot.value as! NSDictionary)["cost"] as! Int
        self.key = snapshot.key
        self.ref = snapshot.ref
    }
}
