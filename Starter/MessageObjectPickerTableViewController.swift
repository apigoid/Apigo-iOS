//
//  MessageObjectPickerTableViewController.swift
//  ApigoStarterProject
//
//  Created by Eyro Labs on 22/10/17.
//  Copyright © 2017 Apigo. All rights reserved.
//

import Foundation
import UIKit
import Apigo

struct DisplayData {
    var label: String
    var detail: String
}

protocol MessageObjectPickerTableViewControllerDelegate {
    func didMessageSenderPicked(sender: APMessageSender)
    func didMessageRecipientPicked(recipient: APMessageRecipient)
    func didMessageTemplatePicked(template: APMessageTemplate)
}

class MessageObjectPickerTableViewController: UITableViewController {
    var objectClassName: String!
    private var data = [DisplayData]()
    private var objects: [MFObject]!
    
    var delegate: MessageObjectPickerTableViewControllerDelegate!
    var selectedObjectId: String?
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.objectClassName {
        case APMessageRecipient.mesosferClassName():
            self.title = "Mesosfer Recipient"
        case APMessageSender.mesosferClassName():
            self.title = "Mesosfer Sender"
        case APMessageTemplate.mesosferClassName():
            self.title = "Mesosfer Template"
        default:
            break
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(pick))
        
        self.reloadData()
    }
    
    @objc func pick() {
        switch self.objectClassName {
        case APMessageRecipient.mesosferClassName():
            self.delegate.didMessageRecipientPicked(recipient: self.objects[self.selectedIndexPath!.row] as! APMessageRecipient)
        case APMessageSender.mesosferClassName():
            self.delegate.didMessageSenderPicked(sender: self.objects[self.selectedIndexPath!.row] as! APMessageSender)
        case APMessageTemplate.mesosferClassName():
            self.delegate.didMessageTemplatePicked(template: self.objects[self.selectedIndexPath!.row] as! APMessageTemplate)
        default:
            break
        }
        self.navigationController!.popViewController(animated: true)
    }
}

extension MessageObjectPickerTableViewController {
    fileprivate func reloadData() {
        MFQuery(className: self.objectClassName).findObjectsInBackground { (objects, error) in
            if let e = error as NSError? {
                print("Error code: \(e.code) message: \(e.localizedDescription)")
                return
            }
            
            switch self.objectClassName {
            case APMessageRecipient.mesosferClassName():
                let recipients = objects! as! [APMessageRecipient]
                for recipient in recipients {
                    self.data.append(DisplayData(label: recipient.number, detail: recipient.objectId!))
                }
            case APMessageSender.mesosferClassName():
                let senders = objects! as! [APMessageSender]
                for sender in senders {
                    self.data.append(DisplayData(label: sender.number, detail: sender.objectId!))
                }
            case APMessageTemplate.mesosferClassName():
                let templates = objects! as! [APMessageTemplate]
                for template in templates {
                    self.data.append(DisplayData(label: template.title, detail: template.objectId!))
                }
            default:
                break
            }
            
            self.objects = objects
            self.tableView.reloadData()
        }
    }
}

extension MessageObjectPickerTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        let data = self.data[indexPath.row]
        
        cell!.textLabel!.text = data.label
        cell!.detailTextLabel!.text = data.detail
        
        if let objectId = self.selectedObjectId, objectId == self.objects[indexPath.row].objectId! {
            cell!.accessoryType = .checkmark
            self.selectedIndexPath = indexPath
        } else {
            cell!.accessoryType = .none
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = self.selectedIndexPath {
            tableView.cellForRow(at: selectedIndexPath)!.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
        self.selectedIndexPath = indexPath
    }
}
