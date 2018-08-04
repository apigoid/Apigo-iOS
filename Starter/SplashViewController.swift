//
//  SplashViewController.swift
//  ApigoStarterProject
//
//  Created by Eyro Labs on 30/05/18.
//  Copyright © 2018 Apigo. All rights reserved.
//

import Foundation
import UIKit
import Apigo

class SplashViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        if let _ = MFUser.current() {
            self.performSegue(withIdentifier: "segueMain", sender: self)
        } else {
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.performSegue(withIdentifier: "segueLogin", sender: self)
            })
        }
    }
}
