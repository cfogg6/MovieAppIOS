//
//  ViewController.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 3/20/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import Parse
import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("loginSegue", sender: "hello from login")
        }
    }
    
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
        loginButton.enabled = false
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) -> Void in
            self.loginButton.enabled = true
            //if username and password are correct
            if ((user) != nil) {
                let query = PFQuery(className: "Locked")
                query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
                query.findObjectsInBackgroundWithBlock({
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil && objects?.count > 0 {
                        print(objects?.count);
                        //the user is in the locked table aka has 1+ strikes
                        if ((objects![0]["strikes"] as! Int) < 3) {
                            //less than 3 strikes, so login and clear strikes
                            PFObject.init(outDataWithClassName: "Locked", objectId: objects![0].objectId).deleteInBackground()
                            //check if banned
                            print("should log in")
                            self.performSegueWithIdentifier("loginSegue", sender: "hello from login")
                        } else {
                            let alert = UIAlertController(title: "Incorrect User/Pass", message: "You have no attempts remaining, contact an admin to unlock your account", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    } else {
                        //0 strikes
                        let query = PFQuery(className: "Banned")
                        query.whereKey("username", equalTo: (self.usernameTextField.text!))
                        query.findObjectsInBackgroundWithBlock({
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            if (error == nil && objects?.count > 0) {
                                let alert = UIAlertController(title: "Banned", message: "This user is banned", preferredStyle:UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            } else {
                                //0 strikes, not banned, so login
                                self.performSegueWithIdentifier("loginSegue", sender: "hello from login")
                            }
                        })
                    }
                })
            //username and password are wrong
            } else {
                let adminQuery = PFQuery(className: "Admin")
                adminQuery.whereKey("username", equalTo: (self.usernameTextField.text!))
                adminQuery.whereKey("password", equalTo: (password: self.passwordTextField.text!))
                adminQuery.findObjectsInBackgroundWithBlock({
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if (error == nil && objects?.count > 0) {
                        self.performSegueWithIdentifier("adminSegue", sender: "hello from login")
                    } else {
                        let query = PFQuery(className: "Locked")
                        query.whereKey("username", equalTo: (self.usernameTextField.text!))
                        query.findObjectsInBackgroundWithBlock({
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            //The user has 1+ strikes aka has an entry already
                            if error == nil && objects?.count > 0 {
                                if ((objects![0]["strikes"] as! Int) == 3) {
                                    let alert = UIAlertController(title: "Incorrect User/Pass", message: "You have no attempts remaining, contact an admin to unlock your account", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                } else {
                                    let var1 = (2 - ((objects![0]["strikes"] as! Int)))
                                    let alert = UIAlertController(title: "Incorrect User/Pass", message: "You have " + String(var1) + " attempts remaining", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    objects![0]["username"] = self.usernameTextField.text!
                                    objects![0]["strikes"] = (objects![0]["strikes"] as! Int) + 1;
                                    objects![0].saveInBackground()
                                }
                                //This is the user's first strike
                            } else {
                                let alert = UIAlertController(title: "Incorrect User/Pass", message: "You have 2 attempts remaining", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                                let lockedObject = PFObject.init(className: "Locked")
                                lockedObject["username"] = self.usernameTextField.text!
                                lockedObject["strikes"] = 1;
                                lockedObject.saveInBackground()
                            }
                        })
                    }
                })
            }
        })
    }
    
    @IBAction func goToRegistration(sender: UIButton) {
        performSegueWithIdentifier("registrationSegue", sender: "hello from login")
    }
}

