//
//  DatabasePackingList.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 10/7/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

class DatabasePackingList {
    
    var length: String!
    var listName: String!
    var region: String!
    var seasons: String!
    var sex: String!
    var shared: Bool!
    var ref: DatabaseReference!
    var key: String!
    
    init(listName: String, region: String, length: String, seasons: String, sex: String, shared: Bool, key: String = "") {
        self.key = key
        self.listName = listName
        self.region = region
        self.length = length
        self.seasons = seasons
        self.sex = sex
        self.shared = shared
        self.ref = Database.database().reference()
    }

    init(snapshot: DataSnapshot) {
        self.listName = (snapshot.value as! NSDictionary)["listName"] as! String
        self.region = (snapshot.value as! NSDictionary)["region"] as! String
        self.length = (snapshot.value as! NSDictionary)["length"] as! String
        self.seasons = (snapshot.value as! NSDictionary)["seasons"] as! String
        self.sex = (snapshot.value as! NSDictionary)["sex"] as! String
        self.shared = (snapshot.value as! [String: AnyObject])["shared"] as! Bool
        self.key = snapshot.key
        self.ref = snapshot.ref
    }

    func toAnyObject() -> Any {
        return [
            "listName": listName,
            "region": region,
            "length": length,
            "seasons": seasons,
            "sex": sex,
            "shared": shared
        ]
    }
}
    


