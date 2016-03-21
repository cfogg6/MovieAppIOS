//
//  ViewController.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 3/20/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    //MARK: Actions
    @IBAction func login(sender: UIButton) {
        if(usernameTextField.text == "user" && passwordTextField.text == "pass") {
        performSegueWithIdentifier("loginSegue", sender: "hello from login")
        }
    }
    
    @IBAction func goToRegistration(sender: UIButton) {
        performSegueWithIdentifier("registrationSegue", sender: "hello from login")
    }
}

