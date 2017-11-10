//
//  SearchPackingLists.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 11/9/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

class SearchPackingLists {
    
    var length: String!
    var region: String!
    var seasons: String!
    var sex: String!
    var ref: DatabaseReference!
    var key: String!
    
    init(region: String, length: String, seasons: String, sex: String, key: String = "") {
        self.key = key
        self.region = region
        self.length = length
        self.seasons = seasons
        self.sex = sex
        self.ref = Database.database().reference()
    }
    
    init(snapshot: DataSnapshot) {
        self.region = (snapshot.value as! NSDictionary)["region"] as! String
        self.length = (snapshot.value as! NSDictionary)["length"] as! String
        self.seasons = (snapshot.value as! NSDictionary)["seasons"] as! String
        self.sex = (snapshot.value as! NSDictionary)["sex"] as! String
        self.key = snapshot.key
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "region": region,
            "length": length,
            "seasons": seasons,
            "sex": sex
        ]
    }
}



