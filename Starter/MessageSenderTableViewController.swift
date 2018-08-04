//
//  MessageSenderTableViewController.swift
//  ApigoStarterProject
//
//  Created by Eyro Labs on 21/10/17.
//  Copyright © 2017 Apigo. All rights reserved.
//

import Foundation
import UIKit
import Apigo

class MessageSenderTableViewController: UITableViewController {
    @IBOutlet weak var textNumber: UITextField!
    @IBOutlet weak var textPrice: UITextField!
    @IBOutlet weak var switchActive: UISwitch!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var isAddMode: Bool!
    var sender: APMessageSender?
    var delegate: ListTableViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sender = self.sender {
            self.isAddMode = false
            self.textNumber.text = sender.number
            self.textPrice.text = sender.price.stringValue
            self.switchActive.isOn = sender.isActive
        } else {
            self.isAddMode = true
            self.sender = APMessageSender()
            self.textNumber.text = ""
            self.textPrice.text = "0"
            self.switchActive.isOn = false
        }
        
        self.textPrice.isEnabled = false
        self.switchActive.isEnabled = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.textNumber.becomeFirstResponder()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func selectorButtonItem(_ sender: Any) {
        let number = self.textNumber.text!
        
        if number.isEmpty {
            self.showDialog(title: "Input Error", message: "Sender number is empty", handler: { (action) in
                self.textNumber.becomeFirstResponder()
            })
            return
        }
        
        self.indicator.startAnimating()
        self.sender!.number = number
        self.sender!.saveInBackground { (succeeded, error) in
            if let e = error {
                self.indicator.stopAnimating()
                self.showDialog(title: "Error Saving", message: "Cause : \(e.localizedDescription)", handler: { (action) in
                    
                })
                return
            }
            
            var stated = "updated"
            if self.isAddMode {
                stated = "created"
            }
            self.showDialog(title: "Done Saving", message: "Object \(stated)", handler: { (action) in
                self.delegate.done(isAddMode: self.isAddMode, object: self.sender!)
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}
