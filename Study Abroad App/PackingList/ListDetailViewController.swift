//
//  ListDetailViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/26/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
//    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding packingList: DatabasePackingList)
//    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing packingList: DatabasePackingList)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var databaseRef: DatabaseReference!
    let ref = Database.database().reference(withPath: "Packing List")
    let usersRef = Database.database().reference(withPath: "Users")
    var user: User!
    
    @IBOutlet weak var regionPickerText: UITextField!
    var regionPickerData = ["Make Selection", "Northern Europe", "Greenland & Iceland", "Southern Europe", "Eastern Europe", "Western Europe, UK, & Ireland", "Russia", "West Asia", "East Asia", "South Asia", "Southeast Asia & Pacific Islands", "Australia", "New Zealand", "North Africa", "West Africa", "East Africa", "Central Africa", "South Africa", "North America", "Central America", "South America"]
    var regionPicker = UIPickerView()
    
    @IBOutlet weak var lengthPickerText: UITextField!
    var lengthPickerData = ["Make Selection", "1-3 weeks", "1-3 months", "4-6 months", "7-12 months", "over 1 year"]
    var lengthPicker = UIPickerView()
    
    @IBOutlet weak var seasonsPickerText: UITextField!
    var seasonsPickerData = ["Make Selection", "Autumn", "Winter", "Spring", "Summer", "Autumn + Winter", "Winter + Spring", "Spring + Summer", "Summer + Autumn", "Autumn + Winter + Spring", "Winter + Spring + Summer", "Spring + Summer + Autumn", "Summer + Autumn + Winter", "Autumn + Winter + Spring + Summer" ]
    var seasonsPicker = UIPickerView()
    
    @IBOutlet weak var sexPickerText: UITextField!
    var sexPickerData = ["Make Selection", "Female", "Male", "Other"]
    var sexPicker = UIPickerView()

    
    @IBOutlet weak var textField: UITextField!
    var backBarButtonItem: UIBarButtonItem!
    var doneBarButtonItem: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    //var packingListToEdit: PackingList?
    var packingListToEdit: DatabasePackingList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonItem = UIBarButtonItem(title: "Back",
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonDidTouch))
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        doneBarButtonItem = UIBarButtonItem(title: "Done",
                                            style: .plain,
                                            target: self,
                                            action: #selector(doneButtonDidTouch))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        let backgroundImage = UIImage(named: "for-packing.jpeg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundColor = .lightGray
        
        regionPicker.delegate = self
        regionPicker.dataSource = self
        regionPickerText.inputView = regionPicker
        
        lengthPicker.delegate = self
        lengthPicker.dataSource = self
        lengthPickerText.inputView = lengthPicker
        
        seasonsPicker.delegate = self
        seasonsPicker.dataSource = self
        seasonsPickerText.inputView = seasonsPicker
        
        sexPicker.delegate = self
        sexPicker.dataSource = self
        sexPickerText.inputView = sexPicker
        
        if let packingList = packingListToEdit {
            title = "Edit Packing List"
            textField.text = packingList.listName
            regionPickerText.text = packingList.region
            lengthPickerText.text = packingList.length
            seasonsPickerText.text = packingList.seasons
            sexPickerText.text = packingList.sex
            doneBarButtonItem.isEnabled = true
        }
    }
    
    @objc func backButtonDidTouch() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        
        backBarButtonItem = UIBarButtonItem(title: "Back",
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonDidTouch))
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func doneButtonDidTouch() {
        if Auth.auth().currentUser != nil {
            let currUser = Auth.auth().currentUser
            if let currUser = currUser {
                let uid = currUser.uid
                let timeStamp = Date()
                
                let listRef = databaseRef.root.child("Users").child(uid).child("PackingList")
                let key = listRef.childByAutoId().key
                
                if packingListToEdit != nil {
                
                    if textField.text != "" && regionPickerText.text != "" && lengthPickerText.text != "" && seasonsPickerText.text != "" && sexPickerText.text != "" {
                        let values = ["listName": textField.text!,
                                       "region": regionPickerText.text!,
                                       "length": lengthPickerText.text!,
                                       "seasons": seasonsPickerText.text!,
                                       "sex": sexPickerText.text!]//,
                                       //"addedByUser": userName]
                        let userReference = self.databaseRef?.root.child("Users").child(uid).child("PackingList")
                        userReference?.updateChildValues(values)
                        listRef.child(key)
                        let packingListReference = self.databaseRef?.root.child("PackingList")
                        packingListReference?.updateChildValues(values)

                    }
                }
                else {
                    if textField.text != "" && regionPickerText.text != "" && lengthPickerText.text != "" && seasonsPickerText.text != "" && sexPickerText.text != "" {
                        
//                        let params = DatabasePackingList(listName: textField.text!,
//                                                         region: regionPickerText.text!,
//                                                         length: lengthPickerText.text!,
//                                                         seasons: seasonsPickerText.text!,
//                                                         sex: sexPickerText.text!,
//                                                         shared: false)
                        
                        let values = ["listName": textField.text!,
                                      "region": regionPickerText.text!,
                                      "length": lengthPickerText.text!,
                                      "seasons": seasonsPickerText.text!,
                                      "sex": sexPickerText.text!,
                                      "shared": false] as [String : Any]//,
                                      //"addedByUser": userName]
                        let userReference = self.databaseRef?.root.child("Users").child(uid).child("PackingList").childByAutoId()
                        //userReference?.setValue(values)
                        
                        listRef.child(key).setValue(values)//params.toAnyObject())
                        
                        let packingListReference = self.databaseRef?.root.child("PackingList").child("\(textField.text!)").childByAutoId()
                        //packingListReference?.setValue(values)
                    }
                }
            }
            
        }
        presentAllListsScreen()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section <= 8 {
            return indexPath
        } else {
            return nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButtonItem.isEnabled = (newText.length > 0)
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows : Int = regionPickerData.count
        if pickerView == lengthPicker {
            countrows = self.lengthPickerData.count
        }
        else if pickerView == seasonsPicker {
            countrows = self.seasonsPickerData.count
        }
        else if pickerView == sexPicker {
            countrows = self.sexPickerData.count
        }
        return countrows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == regionPicker {
            let titleRow = regionPickerData[row]
            return titleRow
        }
        else if pickerView == lengthPicker {
            let titleRow = lengthPickerData[row]
            return titleRow
        }
        else if pickerView == seasonsPicker {
            let titleRow = seasonsPickerData[row]
            return titleRow
        }
        else if pickerView == sexPicker {
            let titleRow = sexPickerData[row]
            return titleRow
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == regionPicker {
            self.regionPickerText.text = self.regionPickerData[row]
            self.regionPicker.isHidden = false
        }
        else if pickerView == lengthPicker {
            self.lengthPickerText.text = self.lengthPickerData[row]
            self.lengthPicker.isHidden = false
        }
        else if pickerView == seasonsPicker {
            self.seasonsPickerText.text = self.seasonsPickerData[row]
            self.seasonsPicker.isHidden = false
        }
        else if pickerView == sexPicker {
            self.sexPickerText.text = self.sexPickerData[row]
            self.sexPicker.isHidden = false
        }
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.regionPickerText) {
            self.regionPicker.isHidden = false
        }
        else if (textField == self.lengthPickerText) {
            self.lengthPicker.isHidden = false
        }
        else if (textField == self.seasonsPickerText) {
            self.seasonsPicker.isHidden = false
        }
        else if (textField == self.sexPickerText) {
            self.sexPicker.isHidden = false
        }
    }
    
    func presentAllListsScreen() {
        self.dismiss(animated: true, completion: nil)
    }
}
