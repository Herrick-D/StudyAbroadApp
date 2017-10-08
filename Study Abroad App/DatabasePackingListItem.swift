//
//  DatabasePackingListItem.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 10/7/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

struct DatabasePackingListItem {
    let key: String
    let name: String
    let quantity: Int
    let addedByUser: String
    let ref: DatabaseReference?
    var completed: Bool
}
