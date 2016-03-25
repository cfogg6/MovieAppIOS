//
//  FindMoviesViewController.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 3/23/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import Foundation
import UIKit

class FindMoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var movieTable: UITableView!
    private var moviesArray = NSArray()
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        self.movieTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let postEndpoint: String = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=yedukp76ffytfuy24zsqk7f5"
        guard let url = NSURL(string: postEndpoint) else {
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? NSDictionary {
                    print(jsonResult)
                    self.moviesArray = (jsonResult["movies"] as? NSArray)!
                    dispatch_async(dispatch_get_main_queue(), {
                        self.movieTable.reloadData()
                    })
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
        movieTable.registerNib(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "movieCell")
        task.resume()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MovieTableViewCell = movieTable.dequeueReusableCellWithIdentifier("movieCell") as! MovieTableViewCell
        // this is how you extract values from a tuple
        let variableTitle = moviesArray[indexPath.row]["title"] as! String
        cell.movieTitleSet(variableTitle)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("You selected cell #\(indexPath.row)!")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    struct Movie {
        let title: String
        let description: String
        let rating: Int
    }
}
