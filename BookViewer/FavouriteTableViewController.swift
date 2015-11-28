//
//  FavouriteTableViewController.swift
//  BookViewer
//
//  Created by Colm Du Ve on 23/11/2015.
//  Copyright © 2015 Dooversoft. All rights reserved.
//

import UIKit

class FavouriteTableViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let session = NSURLSession.sharedSession()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        guard let user = defaults.objectForKey("userId") as? String else {
            print("There was an error retrieving your user number")
            return
        }
        
        /* Set the parameters */
        let methodParameters = [
            "id": user
        ]
        
        /* Build the URL */
        let urlString = appDelegate.baseURLString + "get_favorites.php" + appDelegate.escapedParameters(methodParameters)
        let url = NSURL(string: urlString)!
        
        /* Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        /* Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did request return an error? */
            guard (parsedResult["error"] as! Bool == false) else {
                print("The request returned an error. See the error message in \(parsedResult)")
                return
            }
            
            /* GUARD: Is the "results" key in parsedResult? */
            guard let results = parsedResult["data"] as? [[String : AnyObject]] else {
                print("Cannot find key 'data' in \(parsedResult)")
                return
            }
            
            print(results)
            
            /* Use the data! */
            self.objects = results
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        
        /* Start the request */
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! [String: String]
                let controller = segue.destinationViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let object = objects[indexPath.row] as! [String: String]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["author_first_name"]! + " " + object["author_last_name"]!
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

}
