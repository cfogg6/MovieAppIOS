//
//  EditProfileViewController.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 3/22/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var majortextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let user = PFUser.currentUser()
        if let displayIntake = PFUser.currentUser()!["name"] as? String {
            nameLabel.text = displayIntake
            nameTextField.text = displayIntake
        }
        if let displayIntake = PFUser.currentUser()!["major"] as? String {
            majortextField.text = displayIntake
        }
        if let displayIntake = PFUser.currentUser()!["interests"] as? String {
            interestTextField.text = displayIntake
        }
        emailTextField?.text = user?.email
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Edit Profile", image: UIImage(named: "bucketTab"), tag: 0)
    }
    
    //MARK: Actions
    @IBAction func editButtonClicked(sender: AnyObject) {
        if let user = PFUser.currentUser() {
            user["name"] = nameTextField.text
            user["major"] = majortextField.text
            user["interests"] = interestTextField.text
            user.email = emailTextField.text
        
            //3
            user.saveInBackground()
        }
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
