//
//  RecommendationsViewController.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 3/25/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import UIKit
import Parse

class RecommendationsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var majorPicker: UIPickerView!
    private var moviesArray = [PFObject]()
    @IBOutlet weak var movieTable: UITableView!
    private var majorsArray = ["Select a Major", "Computer Science", "Computer Media", "Computer Science",
                               "Computational Media", "Aerospace Engineering", "Biology", "Biomedical Engineering",
                               "Business", "Chemical Engineering", "Chemistry", "Civil Engineering",
                               "Computer Engineering", "Electrical Engineering", "Environmental Engineering",
                               "Industrial Engineering", "International Affairs", "Math",
                               "Mechanical Engineering", "Physics", "Public Policy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        majorPicker.selectRow(0, inComponent: 0, animated: true)
        movieTable.registerNib(nib, forCellReuseIdentifier: "movieCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "Recommendations"
        majorPicker.delegate = self
        majorPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieTable.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieTableViewCell
//        let cell:MovieTableViewCell = movieTable.dequeueReusableCellWithIdentifier("movieCell") as! MovieTableViewCell
        // this is how you extract values from a tuple
        let variableTitle = moviesArray[indexPath.row]["title"] as! String
        cell.movieTitleSet(variableTitle)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("RecommendationsMovieDetails", sender: moviesArray[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RecommendationsMovieDetails" {
            if let movieDetailViewController = segue.destinationViewController as? MovieDetailViewController {
                let pfSender = sender as! PFObject
                let posters:Dictionary<String, String> = ["profile": pfSender["photoId"]! as! String]
                let nsSender = NSDictionary(objects: [(PFUser.currentUser()!.username)!, pfSender["title"], pfSender["rating"], pfSender["comment"], (PFUser.currentUser()!["major"])!, posters], forKeys: ["username", "title", "rating", "comment", "major", "posters"])
                movieDetailViewController.movie = nsSender
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Recommendations", image: tabBarItem.selectedImage, tag: 0)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return majorsArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return majorsArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int) {
        search(majorsArray[row])
    }
    
    func search(major: String) {
        let query = PFQuery(className: "Ratings")
        query.whereKey("major", equalTo: major)
        query.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                if (objects?.count > 0) {
                    // Do something with the found objects
                    if let objects = objects {
                        self.moviesArray = objects
                        self.mergeRatings()
                        dispatch_async(dispatch_get_main_queue(), {
                            self.movieTable.reloadData()
                        })
                    }
                } else {
                    self.moviesArray = [PFObject]()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.movieTable.reloadData()
                    })
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        })
    }
    
    func mergeRatings() {
        var index1: Int = 0;
        var movie: PFObject;
        var movieArray = [PFObject]()
        while index1 < moviesArray.count {
            movie = moviesArray[index1]
            var index2: Int = index1 + 1
            while index2 < moviesArray.count {
                if (movie["title"] as! String == moviesArray[index2]["title"] as! String) {
                    movieArray.append(movie)
                    moviesArray.removeAtIndex(index2)
                    index2 -= 1
                }
                index2 += 1;
            }
            var rating: Int = 0
            for object in movieArray {
                rating += object["rating"] as! Int
            }
            print(index1)
            
            moviesArray[index1].setObject(rating, forKey: "rating")
            index1 += 1;
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
