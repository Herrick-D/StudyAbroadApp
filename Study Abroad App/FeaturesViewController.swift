//
//  FeaturesViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 10/7/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class FeaturesViewController: UIViewController {

    //View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser?.uid == nil {
            logout()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func packingListTapped(_ sender: Any) {
        performSegue(withIdentifier: "PackingListOptions", sender: self)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
            logout()
    }
    
    func logout() {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login")
        present(loginViewController, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PackingListOptions") {
            
        }
    }

}
