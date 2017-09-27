//
//  ListDetailViewController.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/26/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding packingList: PackingList)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing packingList: PackingList)
}

class ListDetailViewController: UITableViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    var packingListToEdit: PackingList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let packingList = packingListToEdit {
            title = "Edit Packing List"
            textField.text = packingList.name
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //textField.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
//    @IBAction func cancel() {
  //      delegate?.listDetailViewControllerDidCancel(self)
   // }
    
    @IBAction func done() {
        if let packingList = packingListToEdit {
            packingList.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditing: packingList)
        } else {
            let packingList = PackingList(name: textField.text!)
            delegate?.listDetailViewController(self, didFinishAdding: packingList)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
}
