//
//  ItemDetailViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/26/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: PackingListItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: PackingListItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var myStepper: UIStepper!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: PackingListItem?
    
    @IBAction func myStepperValueChanged(_ sender: UIStepper) {
        quantityLabel.text = String(Int(sender.value))
    }
    
    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        if let item = itemToEdit {
            item.text = textField.text!
            item.quantity = quantityLabel.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = PackingListItem()
            item.text = textField.text!
            item.quantity = quantityLabel.text!
            item.checked = false
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            quantityLabel.text = item.quantity
            doneBarButton.isEnabled = true
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
}
