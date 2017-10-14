//
//  User.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 10/7/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let uid: String
    let email: String
    let fName: String
    let packingLists: [DatabasePackingList] = []
    //let password: String
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email
        fName = authData.fName
    }
    
    init(uid: String, email: String, fName: String) {
        self.uid = uid
        self.email = email
        self.fName = fName
    }
}
