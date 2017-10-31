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
    let username: String
    
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email
        username = authData.username
    }
    
    init(uid: String, email: String, username: String) {
        self.uid = uid
        self.email = email
        self.username = username
    }
}
