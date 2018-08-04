//
//  SendMessagePickerTableViewController.swift
//  ApigoStarterProject
//
//  Created by Eyro Labs on 21/10/17.
//  Copyright © 2017 Apigo. All rights reserved.
//

import Foundation
import UIKit

class SendMessagePickerTableViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell!.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell!.textLabel?.text = "Message Template"
        case 1:
            cell!.textLabel?.text = "Message Broadcast Template"
        default:
            break
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "segueSendTemplate", sender: self)
        case 1:
            break
        default:
            break
        }
    }
}
