//
//  ParameterItem.swift
//  ApigoStarterProject
//
//  Created by Eyro Labs on 03/08/18.
//  Copyright © 2018 Apigo. All rights reserved.
//

import Foundation
import UIKit

class ParameterItem: UITableViewCell {
    @IBOutlet weak var textKey: UITextField!
    @IBOutlet weak var textValue: UITextField!
}

class Parameter: NSObject {
    var key: String!
    var value: String!
    
    override init() {
        self.key = ""
        self.value = ""
    }
    
    static func toDictionary(parameters: [Parameter]) -> [String:String] {
        var params = [String:String]()
        for i in 0..<parameters.count {
            let parameter = parameters[i]
            params[parameter.key] = parameter.value
        }
        
        return params
    }
    
    override var description: String {
        return "{\"\(self.key!)\":\"\(self.value!)\"}"
    }
}
