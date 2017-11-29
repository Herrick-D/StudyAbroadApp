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
    var item: String!
    var cost: String!
    var ref: DatabaseReference!
    var key: String!
    
    init(item: String, cost: String, key: String = "") {
        self.item = item
        self.cost = cost
        self.key = key
        self.ref = Database.database().reference()
    }
    
    init(snapshot: DataSnapshot) {
        self.item = (snapshot.value as! NSDictionary)["item"] as! String
        self.cost = (snapshot.value as! NSDictionary)["cost"] as! String
        self.key = snapshot.key
        self.ref = snapshot.ref
    }
}
