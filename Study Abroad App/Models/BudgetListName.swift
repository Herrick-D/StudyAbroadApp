//
//  BudgetListName.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 11/27/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

class BudgetListName {
    var listName: String!
    var total: Int?
    var ref: DatabaseReference!
    var key: String!
    
    init(listName: String, total: Int, key: String = "") {
        self.listName = listName
        self.total = total
        self.key = key
        self.ref = Database.database().reference()
    }
    
    init(snapshot: DataSnapshot) {
        self.listName = (snapshot.value as! NSDictionary)["listName"] as! String
        self.total = (snapshot.value as! NSDictionary)["total"] as? Int
        self.key = snapshot.key
        self.ref = snapshot.ref
    }

}
