//
//  BudgetList.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 11/13/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

class BudgetListCategory{
    var category: String!
    var total: Int!
    var ref: DatabaseReference!
    var key: String!
    
    init(category: String, total: Int, key: String = "") {
        self.category = category
        self.total = total
        self.key = key
        self.ref = Database.database().reference()
    }
    
    init(snapshot: DataSnapshot) {
        self.category = (snapshot.value as! NSDictionary)["category"] as! String
        self.total = (snapshot.value as! NSDictionary)["total"] as! Int
        self.key = snapshot.key
        self.ref = snapshot.ref
    }
}
