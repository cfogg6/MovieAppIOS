//
//  MovieDetailViewController.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 3/26/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import UIKit
import Parse

class MovieDetailViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var starBar: CosmosView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        starBar.settings.fillMode = .Half
        print(movie["title"])
        self.titleLabel.text = movie["title"] as? String
        let query = PFQuery(className: "Ratings")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        print(movie["title"])
        query.whereKey("title", equalTo: movie["title"]!)
        query.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        dispatch_async(dispatch_get_main_queue(), {
                            //get rating from object
                            self.starBar.rating = object["rating"] as! Double
                            self.commentTextField.text = object["comment"] as? String
                        })
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
