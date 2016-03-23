//
//  RegistrationViewController.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 3/21/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import UIKit
import Parse

class RegistrationViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark:Actions
    @IBAction func registerClicked(sender: AnyObject) {
        if (passwordTextField.text == confirmPasswordField.text) {
            let user = PFUser()
        
            user.username = userTextField.text
            user.password = passwordTextField.text
            user["name"] = nameField.text
            user.email = emailField.text
        
            //3
            user.signUpInBackgroundWithBlock { succeeded, error in
                if (succeeded) {
                    //The registration was successful, go to the    show profile
                    self.performSegueWithIdentifier("registeredS    egue", sender: nil)
                } else if let error = error {
                    //Something bad has occurred
                    let alertController = UIAlertController(title: "iOScreator", message:
                        error.description, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)

                }
            }
        } else {
            let alertController = UIAlertController(title: "iOScreator", message:
                "Passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        performSegueWithIdentifier("cancelClickedSegue", sender: "hello from registration")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
