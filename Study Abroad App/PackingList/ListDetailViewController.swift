//
//  ListDetailViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/26/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class ListDetailViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Properties
    
    var databaseRef: DatabaseReference!
    var user: User!
    var packingListToEdit: DatabasePackingList?
    
    //Initialize UIPickerView
    
    @IBOutlet weak var regionPickerText: UITextField!
    var regionPickerData = ["Make Selection", "Northern Europe", "Eastern Europe", "Western Europe, UK, & Ireland", "Southern Europe", "Greenland & Iceland", "Russia", "Northern Asia", "Eastern Asia", "Western Asia", "Southern Asia", "Southeast Asia & Pacific Islands", "Australia", "New Zealand", "Northern Africa", "Eastern Africa", "Western Africa", "Central Africa", "Southern Africa", "North America", "Central America", "South America"]
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

    
    @IBOutlet weak var listTextField: UITextField!
    var backBarButtonItem: UIBarButtonItem!
    var doneBarButtonItem: UIBarButtonItem!
    
    //View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage()
        makeBackBarButton()
        makeDoneBarButton()
        initPickers()
        
        if let packingList = packingListToEdit {
            title = "Edit Packing List"
            listTextField.text = packingList.listName
            regionPickerText.text = packingList.region
            lengthPickerText.text = packingList.length
            seasonsPickerText.text = packingList.seasons
            sexPickerText.text = packingList.sex
            self.databaseRef = packingList.ref
            doneBarButtonItem.isEnabled = true
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listTextField.becomeFirstResponder()
        backgroundImage()
        makeBackBarButton()
        makeDoneBarButton()
        initPickers()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section <= 8 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = listTextField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButtonItem.isEnabled = (newText.length > 0)
        return true
    }
    
    //UIPickerView Methods
    
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
    
    //Functions
    
    func makeBackBarButton() {
        backBarButtonItem = UIBarButtonItem(title: "Back",
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonDidTouch))
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func makeDoneBarButton() {
        doneBarButtonItem = UIBarButtonItem(title: "Done",
                                            style: .plain,
                                            target: self,
                                            action: #selector(doneButtonDidTouch))
        navigationItem.rightBarButtonItem = doneBarButtonItem

    }
    
    func backgroundImage() {
        let backgroundImage = UIImage(named: "for-packing.jpeg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundColor = .lightGray
    }
    
    @objc func backButtonDidTouch() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonDidTouch() {
        if Auth.auth().currentUser != nil {
            let currUser = Auth.auth().currentUser
            if let currUser = currUser {
                let uid = currUser.uid
                if packingListToEdit != nil {
                    let updateKey = packingListToEdit?.key
                    if listTextField.text != "" && regionPickerText.text != "" && lengthPickerText.text != "" && seasonsPickerText.text != "" && sexPickerText.text != "" {
                        let userReference = packingListToEdit?.ref
                        let values = ["listName": listTextField.text!,
                                      "region": regionPickerText.text!,
                                      "length": lengthPickerText.text!,
                                      "seasons": seasonsPickerText.text!,
                                      "sex": sexPickerText.text!,
                                      "shared": false] as [String : Any]
                        userReference?.updateChildValues(values)
                    }
                }
                else {
                    let listRef = databaseRef.root.child("Users").child(uid).child("PackingList").childByAutoId()
                    let key = listRef.key
                    if listTextField.text != "" && regionPickerText.text != "" && lengthPickerText.text != "" && seasonsPickerText.text != "" && sexPickerText.text != "" {
                        let packingListReference = listRef.ref
                        let values = ["listName": listTextField.text!,
                                      "region": regionPickerText.text!,
                                      "length": lengthPickerText.text!,
                                      "seasons": seasonsPickerText.text!,
                                      "sex": sexPickerText.text!,
                                      "shared": false,
                                      "key": "\(key)",
                            "ref": "\(packingListReference)"] as [String : Any]
                        listRef.setValue(values)
                    }
                }
                presentAllListsScreen()
            }
        }
    }
    
    func initPickers() {
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
    }
    
    func presentAllListsScreen() {
        self.dismiss(animated: true, completion: nil)
    }
}
