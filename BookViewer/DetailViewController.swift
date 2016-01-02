//
//  DetailViewController.swift
//  BookViewer
//


import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailAuthorLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!

    var appDelegate: AppDelegate!
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem as? [String: String] {
            if let title = self.detailTitleLabel {
                title.text = detail["title"]
            }
            if let author = self.detailAuthorLabel {
                author.text = detail["author_first_name"]! + " " + detail["author_last_name"]!
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let icon = FAKFontAwesome.heartIconWithSize(20)
        icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let button = UIBarButtonItem(image: icon.imageWithSize(CGSize(width: 20, height: 20)), style: .Plain, target: self, action: "addToFavourites")
        self.navigationItem.rightBarButtonItem = button

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func addToFavourites() {
        let session = NSURLSession.sharedSession()
        
        let defaults = NSUserDefaults.standardUserDefaults()

        guard let userId = defaults.objectForKey("userId") else {
            print("There was an error retrieving your user number")
            return
        }
        
        var bookId = 0
        if let detail = self.detailItem as? [String: String] {
            if let id = detail["id"] {
                bookId = Int(id)!
            }
        }
        
        /* Set the parameters */
        let methodParameters = [
            "book_id": bookId,
            "user_id": userId
        ]
        
        /* Build the URL */
        let urlString = appDelegate.baseURLString + "save_favorites.php" + appDelegate.escapedParameters(methodParameters)
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
            
        }
        
        /* Start the request */
        task.resume()
    }
}

