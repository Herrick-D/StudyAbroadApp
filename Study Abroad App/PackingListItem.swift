//
//  PackingListItem.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/26/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation

class PackingListItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    var quantity = ""
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(quantity, forKey: "Quantity")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        quantity = aDecoder.decodeObject(forKey: "Quantity") as! String
        super.init()
    }
    
    override init() {
        super.init()
    }
}
