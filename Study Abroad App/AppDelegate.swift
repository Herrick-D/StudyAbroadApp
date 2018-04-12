//
//  AppDelegate.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/25/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?
    
    override init() {
        FirebaseApp.configure()
    }

    private func application(_ application: UIApplication,
                             didFinishLaunchingWithOptions launchOptions:
                             [NSObject : AnyObject]? = [:]) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        Database.database().isPersistenceEnabled = true
        return true
    }

}


