//
//  SettingsTableViewController.swift
//  BookViewer
//
//  Created by Colm Du Ve on 23/11/2015.
//  Copyright © 2015 Dooversoft. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var userNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = NSUserDefaults.standardUserDefaults()
        if let user = defaults.objectForKey("userId") as? String {
            userNumber.text = user
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidDisappear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(userNumber.text, forKey: "userId")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}
