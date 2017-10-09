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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let loginToFeatures = "FeaturesViewController"
    
    override func viewDidLoad() {
        let listener = Auth.auth().addStateDidChangeListener {
            auth, user in
            if user != nil {
                self.presentFeaturesScreen()
            }
        }
        Auth.auth().removeStateDidChangeListener(listener)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.presentFeaturesScreen()
        }
    }
    @IBAction func loginTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
        self.presentFeaturesScreen()
//                , completion: {user, error in
//                if let firebaseError = error {
//                    print(firebaseError.localizedDescription)
//                    return
//                }
//                self.presentFeaturesScreen()
//                print("success")
//            })
        
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Create Account",
                                      message: "All Fields Required",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Sign Up",
                                       style: .default) { action in
            let fName = alert.textFields![0]
            let email = alert.textFields![1]
            let password = alert.textFields![2]
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { user, error in
                if let firebaseError = error {
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        switch errorCode {
                        case .weakPassword:
                            print("Please provide a strong password")
                        default:
                            print("There is an error")
                        }
                    }
                    print(firebaseError.localizedDescription)
                    return
                }
                self.presentFeaturesScreen()
                print("success")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField { textFName in
            textFName.placeholder = "Enter your first name"
        }
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password, at least 6 characters"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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


