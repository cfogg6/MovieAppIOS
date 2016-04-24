//
//  ShowProfileViewController.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 3/22/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import Parse
import UIKit

class ShowProfileViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        
        dismissViewControllerAnimated(true, completion:nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let user = PFUser.currentUser()
        if let displayIntake = PFUser.currentUser()!["name"] as? String {
            nameTitle.text = displayIntake
            nameLabel.text = "Name: " + displayIntake
        }
        if let displayIntake = PFUser.currentUser()!["major"] as? String {
            majorLabel.text = "Major: " + displayIntake
        }
        if let displayIntake = PFUser.currentUser()!["interests"] as? String {
            interestLabel.text = "Interests: " + displayIntake
        }
        emailLabel.text = "Email: " + (user?.email)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "bucketTab"), tag: 0)
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
