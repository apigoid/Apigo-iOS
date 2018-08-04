//
//  MainTableViewController.swift
//  ApigoStarterProject
//
//  Created by Eyro Labs on 14/10/17.
//  Copyright © 2017 Apigo. All rights reserved.
//

import Foundation
import UIKit
import Apigo

struct MainMenu {
    var name: String
    var className: String
    var segue: String
    
    init(name: String, className: String = "", segue: String) {
        self.name = name
        self.className = className
        self.segue = segue
    }
}

class MainTableViewController: UITableViewController {
    let listMenu: [[MainMenu]] = [
        [
            MainMenu(name: "Message Log", className: APMessageLog.mesosferClassName(), segue: "segueList"),
            MainMenu(name: "Message Recipient", className: APMessageRecipient.mesosferClassName(), segue: "segueList"),
            MainMenu(name: "Message Sender", className: APMessageSender.mesosferClassName(), segue: "segueList"),
            MainMenu(name: "Message Template", className: APMessageTemplate.mesosferClassName(), segue: "segueList"),
        ],
        [
            MainMenu(name: "Send Message", segue: "segueSendMessage")
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(MainTableViewController.logout))
    }
    
    @objc func logout() {
        MFUser.logOut()
        self.dismiss(animated: true) {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "segueList":
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let list = segue.destination as! ListTableViewController
                    list.menu = self.listMenu[indexPath.section][indexPath.row]
                    list.editable = list.menu.className != APMessageLog.mesosferClassName()
                }
            default:
                break
            }
        }
    }
}

extension MainTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.listMenu.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listMenu[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let menu = self.listMenu[indexPath.section][indexPath.row]
        
        cell!.textLabel!.text = menu.name
        cell!.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "segueList", sender: self)
        } else {
            self.performSegue(withIdentifier: "segueMessagePicker", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Manage messaging object"
        }
        
        return "Send message directly, broadcast or compose it using a template"
    }
}

extension UITableViewController {
    func showDialog(title: String? = nil, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        self.present(dialog, animated: true) {
            
        }
    }
}
