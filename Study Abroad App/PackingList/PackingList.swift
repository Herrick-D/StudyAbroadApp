//
//  PackingList.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/26/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit

class PackingList: NSObject, NSCoding {
    var name = ""
    var region = ""
    var length = ""
    var seasons = ""
    var sex = ""
    var items: [PackingListItem] = []
    
    init(name: String, region: String, length: String, seasons: String, sex: String) {
        self.name = name
        self.region = region
        self.length = length
        self.seasons = seasons
        self.sex = sex
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [PackingListItem]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count+=1
        }
        return count
    }}
