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
    var ref: DatabaseReference!
    var key: String!
    
    init(snapshot: DataSnapshot) {
        self.listName = (snapshot.value as! NSDictionary)["listName"] as! String
        self.key = snapshot.key
        self.ref = snapshot.ref
    }

}
