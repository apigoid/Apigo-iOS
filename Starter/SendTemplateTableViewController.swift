//
//  SendMessageTableViewController.swift
//  ApigoStarterProject
//
//  Created by Eyro Labs on 22/10/17.
//  Copyright © 2017 Apigo. All rights reserved.
//

import Foundation
import UIKit
import Apigo

class SendTemplateTableViewController: UITableViewController {
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelSender: UILabel!
    @IBOutlet weak var textRecipient: UITextField!
    @IBOutlet weak var labelTemplate: UILabel!
    @IBOutlet weak var labelParameters: UILabel!
    @IBOutlet weak var switchSandbox: UISwitch!
    
    var message: APMessage!
    
    var type = APMessageType.sms
    var sender: APMessageSender?
    var template: APMessageTemplate?
    var parameters = [Parameter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectorSend(_ sender: Any) {
        guard let sender = self.sender else {
            self.showDialog(message: "Sender is empty")
            return
        }
        
        guard let recipient = self.textRecipient.text, !recipient.isEmpty else {
            self.showDialog(message: "Recipient is empty")
            return
        }
        
        guard let template = self.template else {
            self.showDialog(message: "Template is empty")
            return
        }
        
        if self.parameters.isEmpty {
            self.showDialog(message: "Parameters is empty")
            return
        }
        
        let send = APMessage(directTemplateWith: sender, recipient: recipient, template: template, parameters: Parameter.toDictionary(parameters: parameters), messageType: APMessageType.sms, sandbox: self.switchSandbox.isOn)
        send?.sendInBackground({ (log, error) in
            if let e = error as NSError? {
                self.showDialog(title: "Send Error", message: "[Code:\(e.code)] \(e.localizedDescription)", handler: { (action) in

                })
                return
            }

            self.showDialog(title: "Message sent", message: "Log: \((log as! APMessageLog).dictionary())", handler: { (action) in

            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "segueParameters":
                let controller = segue.destination as! ParametersTableViewController
                controller.delegate = self
                controller.parameters = self.parameters
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let typePicker = MessageTypePickerTableViewController(style: .grouped)
            typePicker.delegate = self
            typePicker.selectedType = self.type
            self.navigationController?.pushViewController(typePicker, animated: true)
        case 1, 3:
            let picker = MessageObjectPickerTableViewController(style: .grouped)
            switch indexPath.row {
            case 1:
                picker.objectClassName = APMessageSender.mesosferClassName()
            case 3:
                picker.objectClassName = APMessageTemplate.mesosferClassName()
            default:
                break
            }
            picker.delegate = self
            self.navigationController?.pushViewController(picker, animated: true)
        case 4:
            self.performSegue(withIdentifier: "segueParameters", sender: self)
        case 5:
            self.switchSandbox.isOn = !self.switchSandbox.isOn
        default:
            break
        }
        
    }
}

extension SendTemplateTableViewController: MessageTypePickerTableViewControllerDelegate, MessageObjectPickerTableViewControllerDelegate,ParametersTableViewControllerDelegate {
    func didManageParameters(parameters: [Parameter]) {
        self.labelParameters.text = "\(parameters)"
        self.parameters = parameters
    }
    
    func didMessageTypePicked(type: APMessageType) {
        self.type = type
        switch type {
        case .sms:
            self.labelType.text = "SMS"
        case .mms:
            self.labelType.text = "MMS"
        default:
            self.labelType.text = "USSD"
        }
    }
    
    func didMessageRecipientPicked(recipient: APMessageRecipient) {
        
    }
    
    func didMessageSenderPicked(sender: APMessageSender) {
        self.labelSender.text = sender.number
        self.sender = sender
    }
    
    func didMessageTemplatePicked(template: APMessageTemplate) {
        self.labelTemplate.text = template.title
        self.template = template
    }
}
