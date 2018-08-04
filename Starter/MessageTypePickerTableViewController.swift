//
//  MessageTypePickerTableViewController.swift
//  ApigoStarterProject
//
//  Created by Eyro Labs on 22/10/17.
//  Copyright © 2017 Apigo. All rights reserved.
//

import Foundation
import UIKit
import Apigo

struct MessageType {
    var label: String
    var type: APMessageType
}

protocol MessageTypePickerTableViewControllerDelegate {
    func didMessageTypePicked(type: APMessageType)
}

class MessageTypePickerTableViewController: UITableViewController {
    let data: [MessageType] = [
        MessageType(label: "SMS", type: .sms),
        MessageType(label: "MMS", type: .mms),
        MessageType(label: "USSD", type: .ussd)
    ]
    
    var selectedType: APMessageType!
    var delegate: MessageTypePickerTableViewControllerDelegate!
    private var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Message Type"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(pick))
    }
    
    @objc func pick() {
        self.delegate.didMessageTypePicked(type: self.selectedType)
        self.navigationController!.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Select a message type"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let messageType = self.data[indexPath.row]
        
        cell!.textLabel!.text = messageType.label
        if self.selectedType == messageType.type {
            self.selectedIndexPath = indexPath
            cell!.accessoryType = .checkmark
        } else {
            cell!.accessoryType = .none
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: self.selectedIndexPath)!.accessoryType = .none
        self.selectedType = self.data[indexPath.row].type
        tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
        self.selectedIndexPath = indexPath
    }
}
