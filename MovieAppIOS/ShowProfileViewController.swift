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
        nameTitle.text = user?.name
        emailLabel.text = user?.email
        
        
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
