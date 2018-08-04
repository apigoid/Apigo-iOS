//
//  ListTableViewController.swift
//  ApigoStarterProject
//
//  Created by Eyro Labs on 14/10/17.
//  Copyright © 2017 Apigo. All rights reserved.
//

import Foundation
import UIKit
import Apigo

protocol ListTableViewControllerDelegate {
    func done(isAddMode: Bool, object: MFObject)
}

class ListTableViewController: UITableViewController {
    var menu: MainMenu!
    var editable: Bool!
    var objects: [MFObject]?
    
    var edittedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = self.menu.name
        
        if self.editable {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addObject))
        }
        
        self.reloadData()
    }
    
    @IBAction func eventValueChanged(_ sender: Any) {
        self.refreshControl!.beginRefreshing()
        self.reloadData()
    }
    
    @objc func addObject() {
        self.edittedIndexPath = nil
        if self.menu.className == APMessageSender.mesosferClassName() {
            self.performSegue(withIdentifier: "segueSender", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        var object : MFObject? = nil
        if let indexPath = self.edittedIndexPath {
            guard let objects = self.objects else {
                return
            }
            object = objects[indexPath.row]
        }
        
        switch identifier {
        case "segueSender":
            let senderView = segue.destination as! MessageSenderTableViewController
            senderView.delegate = self
            if let object = object {
                senderView.sender = object as? APMessageSender
            }
        default:
            break
        }
    }
}

extension ListTableViewController {
    fileprivate func reloadData() {
        MFQuery(className: self.menu.className).findObjectsInBackground { (objects, error) in
            if self.refreshControl!.isRefreshing {
                self.refreshControl!.endRefreshing()
            }
            if let e = error as NSError? {
                print("Error code: \(e.code) message: \(e.localizedDescription)")
                return
            }
            
            self.objects = objects
            self.tableView.reloadData()
        }
    }
}

extension ListTableViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let objects = self.objects {
            return "Found : \(objects.count) objects"
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let objects = self.objects {
            return objects.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 12)
        cell!.textLabel!.numberOfLines = 0
        cell!.textLabel!.lineBreakMode = .byWordWrapping
        if let objects = self.objects {
            let object = objects[indexPath.row] as! MFSubclassing
            cell!.textLabel!.text = (object.dictionary!() as! [String: AnyObject]).description
            //print(object.dictionary!())
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let objects = self.objects else {
            return nil
        }
        
        let object = objects[indexPath.row]
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let alert = UIAlertController(title: "Delete Confirmation", message: "Do you want to delete object with ID \(object.objectId!)", preferredStyle: .actionSheet)
            let remove = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                object.deleteInBackground(block: { (succeeded, error) in
                    if let e = error {
                        print("Error deleting object: \(e)")
                        return
                    }
                    
                    self.tableView.beginUpdates()
                    self.objects!.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                })
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
            })
            
            alert.addAction(remove)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: {
                
            })
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            if object.mesosferClassName == APMessageSender.mesosferClassName() {
                self.edittedIndexPath = indexPath
                self.performSegue(withIdentifier: "segueSender", sender: self)
            }
        }
        
        return [delete, edit]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.editable
    }
}

extension ListTableViewController: ListTableViewControllerDelegate {
    func done(isAddMode: Bool, object: MFObject) {
        self.tableView.beginUpdates()
        if isAddMode {
            self.objects!.append(object)
            self.tableView.insertRows(at: [IndexPath(row: self.objects!.count - 1, section: 0)], with: .automatic)
        } else {
            self.objects![self.edittedIndexPath!.row] = object
            self.tableView.reloadRows(at: [self.edittedIndexPath!], with: .automatic)
        }
        self.tableView.endUpdates()
    }
}
