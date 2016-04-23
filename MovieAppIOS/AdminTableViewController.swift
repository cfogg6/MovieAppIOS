//
//  AdminTableViewController.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 4/20/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import UIKit
import Parse

class AdminTableViewController: UITableViewController {

    //MARK: Properties
    @IBOutlet weak var userTable: UITableView!
    private var userArray = [AdminUser]()
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        self.userTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.title = "Users"
        
        let adminQuery = PFQuery(className: "_User")
        adminQuery.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if (error == nil && objects?.count > 0) {
                for object in objects! {
                    print("found users")
                    dispatch_async(dispatch_get_main_queue(), {
                        let user = AdminUser()
                        user.username = object["username"] as! String
                        let query = PFQuery(className: "Locked")
                        query.whereKey("username", equalTo: (user.username))
                        query.findObjectsInBackgroundWithBlock({
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            if error == nil && objects?.count > 0 {
                                if ((objects![0]["strikes"] as! Int) >= 3) {
                                    user.locked = true;
                                    print(user.username + " is locked")
                                }
                            }
                            let query = PFQuery(className: "Banned")
                            query.whereKey("username", equalTo: (user.username))
                            query.findObjectsInBackgroundWithBlock({
                                (objects: [PFObject]?, error: NSError?) -> Void in
                                if (error == nil && objects?.count > 0) {
                                    user.banned = true
                                }
                            })
                        })
                        self.userArray.append(user)
                        self.userTable.reloadData()
                    })
                }
            } else {
                self.userArray = [AdminUser]()
               //no users
            }
        })
    }
    
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.userArray.count
        return userArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UserTableViewCell = userTable.dequeueReusableCellWithIdentifier("UserTableViewCell") as! UserTableViewCell
        // this is how you extract values from a tuple
//        let username = userArray[indexPath.row]["username"] as! String
//        let username = userArray[indexPath.row]["locked"] as! String
//        let username = userArray[indexPath.row]["username"] as! String
        cell.initRow(userArray[indexPath.row].username, locked: userArray[indexPath.row].locked, banned: (userArray[indexPath.row].banned))
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

    @IBAction func logoutClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion:nil)
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
