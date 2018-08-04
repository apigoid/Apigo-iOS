//
//  LoginViewController.swift
//  ApigoStarterProject
//
//  Created by Eyro Labs on 30/05/18.
//  Copyright © 2018 Apigo. All rights reserved.
//

import Foundation
import UIKit
import Apigo

class LoginViewController: UIViewController {
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var formView: UIStackView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func showLoadingState(state: Bool) {
        self.formView.isHidden = state
        if state {
            self.loading.startAnimating()
        } else {
            self.loading.stopAnimating()
        }
    }
    
    @IBAction func onLoginClicked(_ sender: Any) {
        self.labelHeader.text = ""
        
        guard let username = self.textUsername.text else {
            self.labelHeader.text = "Username is empty"
            return
        }
        
        guard let password = self.textPassword.text else {
            self.labelHeader.text = "Password is empty"
            return
        }
        
        print("username:\(username), password:\(password)")
        self.showLoadingState(state: true)
        MFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            self.showLoadingState(state: false)
            if let e = error {
                print("Error logging in, cause \(e)")
                self.labelHeader.text = e.localizedDescription
                return
            }
            
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    @IBAction func onCloseClicked(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
}
