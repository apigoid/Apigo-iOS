//
//  ParametersTableViewController.swift
//  ApigoStarterProject
//
//  Created by Eyro Labs on 03/08/18.
//  Copyright © 2018 Apigo. All rights reserved.
//

import Foundation
import UIKit

protocol ParametersTableViewControllerDelegate {
    func didManageParameters(parameters: [Parameter])
}

class ParametersTableViewController: UITableViewController {
    var parameters: [Parameter]!
    var delegate: ParametersTableViewControllerDelegate!
    
    @IBAction func addParameters(_ sender: UIBarButtonItem) {
        self.tableView.beginUpdates()
        self.parameters.append(Parameter())
        self.tableView.insertRows(at: [IndexPath(item: self.parameters.count == 0 ? self.parameters.count : (self.parameters.count - 1), section: 0)], with: .automatic)
        self.tableView.endUpdates()
    }
    
    @IBAction func saveParameters(_ sender: UIBarButtonItem) {
        for i in 0..<parameters.count {
            let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! ParameterItem
            let parameter = Parameter()
            if let key = cell.textKey.text, !key.isEmpty {
              parameter.key = key
            } else {
                self.showDialog(title: "Empty Key", message: "Cannot use empty key parameter") { (action) in
                    cell.textKey.becomeFirstResponder()
                }
                return
            }
            
            if let value = cell.textValue.text, !value.isEmpty {
                parameter.value = value
            } else {
                self.showDialog(title: "Value Key", message: "Cannot use empty value parameter") { (action) in
                    cell.textValue.becomeFirstResponder()
                }
                return
            }
            self.parameters[i] = parameter
        }
        self.delegate.didManageParameters(parameters: self.parameters)
        self.navigationController?.popViewController(animated: true)
    }
}

extension ParametersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parameters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForm") as! ParameterItem
        
        let parameter = self.parameters[indexPath.row]
        
        cell.textKey.text = parameter.key
        cell.textValue.text = parameter.value
        
        return cell
    }
}
