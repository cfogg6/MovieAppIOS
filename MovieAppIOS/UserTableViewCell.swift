//
//  UserTableViewCell.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 4/20/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import Parse
import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lockedSwitch: UISwitch!
    @IBOutlet weak var bannedSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initRow(username: String, locked: Bool, banned: Bool) {
        usernameLabel.text = username
        lockedSwitch.on = locked
        bannedSwitch.on = banned
        if (locked) {
            lockedSwitch.on = true
            lockedSwitch.enabled = true
        } else {
            lockedSwitch.on = false
            lockedSwitch.enabled = false
        }
    }
    
    @IBAction func lockClicked(sender: AnyObject) {
        if (lockedSwitch.on) {
            lockedSwitch.enabled = false
            let query = PFQuery(className: "Locked")
            query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
            query.findObjectsInBackgroundWithBlock({
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil && objects?.count > 0 {
                    PFObject.init(outDataWithClassName: "Locked", objectId: objects![0].objectId).deleteInBackground()
                }
            })
        }
    }
    
    @IBAction func bannedClicked(sender: AnyObject) {
        let query = PFQuery(className: "Banned")
        query.whereKey("username", equalTo: (usernameLabel.text)!)
        query.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects?.count > 0 {
                if (!self.bannedSwitch.on) {
                    PFObject.init(outDataWithClassName: "Banned", objectId: objects![0].objectId).deleteInBackground()
                }
            } else if (self.bannedSwitch.on) {
                let obj = PFObject.init(className: "Banned")
                obj["username"] = self.usernameLabel.text
                obj.saveInBackground()
            }
        })
    }
}
