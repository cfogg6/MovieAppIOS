//
//  MovieSearchTableViewController.swift
//  MovieAppIOS
//
//  Created by Corey Fogg on 3/25/16.
//  Copyright © 2016 Corey Fogg. All rights reserved.
//

import UIKit

class MovieSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var navItem: UINavigationItem!
    var searchBar = UISearchBar()
    var searchBarButtonItem: UIBarButtonItem?

    //MARK: Properties
    @IBOutlet weak var movieTable: UITableView!
    private var moviesArray = NSArray()
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        self.movieTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "movieCell")
        navigationItem.title = "Search"
    }
    
    override func viewDidLoad() {
        searchBar = UISearchBar(frame: CGRectMake(0.0, -80.0, 320.0, 44.0))
        navigationController?.navigationBar.addSubview(searchBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MovieTableViewCell = movieTable.dequeueReusableCellWithIdentifier("movieCell") as! MovieTableViewCell
        // this is how you extract values from a tuple
        let variableTitle = moviesArray[indexPath.row]["title"] as! String
        cell.movieTitleSet(variableTitle)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func search(searchTerm: String) {
        if (searchTerm != "") {
            print("search")
            let startURL: String = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=yedukp76ffytfuy24zsqk7f5"
            let postEndpoint = startURL + "&q=" + searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options:    NSStringCompareOptions.LiteralSearch, range: nil) + "&page_limit=20"
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
        } else {
            self.moviesArray = NSArray()
            dispatch_async(dispatch_get_main_queue(), {
                self.movieTable.reloadData()
            })
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
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
