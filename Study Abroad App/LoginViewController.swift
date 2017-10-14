//
//  LoginViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 10/7/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    // Variables:
    let databasRef = Database.database().reference(fromURL: "https://studyabroad-42803.firebaseio.com/")
    let loginToFeatures = "FeaturesViewController"
    
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let passwordSecure = passwordTextField
        passwordSecure?.isSecureTextEntry = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.presentFeaturesScreen()
        }
    }
    
    // Actions:
    @IBAction func loginTapped(_ sender: Any) {
        login()
        self.presentFeaturesScreen()
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        signUp()
        self.presentFeaturesScreen()
    }
    
    // Functions:
    func login() {
        guard let email = emailTextField.text else {
            print("Email must not be empty")
            return
        }
        guard let password = passwordTextField.text else {
            print("Password must not be empty")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print("Authorization error")
                return
            }
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func signUp() {
        guard let username = usernameTextField.text else {
            print("Username required")
            return
        }
        guard let email = emailTextField.text else {
            print("Email required")
            return
        }
        guard let password = passwordTextField.text else {
            print("Password required")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error != nil {
                print("Authentication Errror")
                return
            }
            guard let uid = user?.uid else {
                return
            }
            let userReference = self.databasRef.child("users").child(uid)
            let values = ["username": username, "email": email]
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("User info error")
                    return
                }
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
    
    func presentFeaturesScreen() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let features: FeaturesViewController = storyboard.instantiateViewController(withIdentifier: "FeaturesViewController") as! FeaturesViewController
        self.present(features, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}


