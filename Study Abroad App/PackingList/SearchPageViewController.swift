//
//  SearchPageViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 10/9/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit
import Firebase

class SearchPageViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
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
    
    var backBarButtonItem: UIBarButtonItem!
    var searchButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBackBarButton()
        makeSearchBarButton()
        initPickers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeBackBarButton()
        makeSearchBarButton()
        initPickers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchResultListsSegue" {
            let controller = segue.destination as! SearchResultListsViewController
            controller.regionText = regionPickerText.text
            controller.lengthText = lengthPickerText.text
            controller.seasonsText = seasonsPickerText.text
            controller.sexText = sexPickerText.text
        }
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
    
    func makeBackBarButton() {
        backBarButtonItem = UIBarButtonItem(title: "Back",
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonDidTouch))
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func backButtonDidTouch() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let features = storyboard.instantiateViewController(withIdentifier: "FeaturesViewController") as! FeaturesViewController //UINavigationController
        self.present(features, animated: true, completion: nil)
    }
    
    func makeSearchBarButton() {
        searchButtonItem = UIBarButtonItem(title: "Search",
                                            style: .plain,
                                            target: self,
                                            action: #selector(searchButtonDidTouch))
        navigationItem.rightBarButtonItem = searchButtonItem
    }
    
    @IBAction func searchButtonDidTouch() {
        if(regionPickerText.text == ""){
            let alert = UIAlertController(title: "Search Parameters Needed",
                                          message: "Region and Sex are required to continue",
                                          preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "OK",
                                           style: .default)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
            
        }
        if(sexPickerText.text == ""){
            let alert = UIAlertController(title: "Search Parameters Needed",
                                          message: "Region and Sex are required to continue",
                                          preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "OK",
                                           style: .default)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
        else if (regionPickerText.text != "" && sexPickerText.text != ""){
            performSegue(withIdentifier: "SearchResultListsSegue", sender: self)           
        }
        
    }
}
