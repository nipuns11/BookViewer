////
////  PremergencyAPI.swift
////  BookViewer
////

//
//import Foundation
//
//class PremergencyAPI {
//    
//    let baseURLString = "http://premergency.com/librarydemo/"
//    
//    func getBooks() {
//        
//        let session = NSURLSession.sharedSession()
//        
//        /* Set the parameters */
//        let methodParameters = [
//            "all": true
//        ]
//        
//        /* Build the URL */
//        let urlString = baseURLString + "request.php?" + escapedParameters(methodParameters)
//        let url = NSURL(string: urlString)!
//        
//        /* Configure the request */
//        let request = NSMutableURLRequest(URL: url)
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        
//        /* Make the request */
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//            
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                print("There was an error with your request: \(error)")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
//                } else if let response = response {
//                    print("Your request returned an invalid response! Response: \(response)!")
//                } else {
//                    print("Your request returned an invalid response!")
//                }
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                print("No data was returned by the request!")
//                return
//            }
//            
//            /* Parse the data */
//            let parsedResult: AnyObject!
//            do {
//                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
//            } catch {
//                parsedResult = nil
//                print("Could not parse the data as JSON: '\(data)'")
//                return
//            }
//            
//            //            /* GUARD: Did call return an error? */
//            //            guard (parsedResult.objectForKey("error") == true) else {
//            //                print("TheMovieDB returned an error. See the status_code and status_message in \(parsedResult)")
//            //                return
//            //            }
//            //
//            //            /* GUARD: Is the "results" key in parsedResult? */
//            //            guard let results = parsedResult["results"] as? [[String : AnyObject]] else {
//            //                print("Cannot find key 'results' in \(parsedResult)")
//            //                return
//            //            }
//            //
//            //            /* Use the data! */
//            //            self.movies = Movie.moviesFromResults(results)
//            //            dispatch_async(dispatch_get_main_queue()) {
//            //                self.tableView.reloadData()
//        }
//    }
//    
//    
//    
//    func getBookWithID(id: Int) {
//        
//    }
//    
//    func addFavoriteForUser(user: Int, id: Int) {
//        
//    }
//    
//    func removeFavouriteForUser(user: Int, id: Int) {
//        
//    }
//    
//    func escapedParameters(parameters: [String : AnyObject]) -> String {
//        
//        var urlVars = [String]()
//        
//        for (key, value) in parameters {
//            
//            /* Make sure that it is a string value */
//            let stringValue = "\(value)"
//            
//            /* Escape it */
//            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
//            
//            /* Append it */
//            urlVars += [key + "=" + "\(escapedValue!)"]
//            
//        }
//        
//        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
//    }
//}
//
////class PremergencyBook {
////    var Title: String
////    var AuthorFirstName: String
////    var AuthorLastName: String
////}
