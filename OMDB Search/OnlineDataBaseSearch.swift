


//
//  OnlineDataBaseSearch.swift
//  OMDB Search
//
//  Created by Jeremy Frick on 5/30/15.
//  Copyright (c) 2015 Jeremy Frick. All rights reserved.
//

import UIKit

class OnlineDataBaseSearch: NSObject {
    var delegate: searchResultsProtocol?
    //var searchResults = [Movie]()
    func searchDataBase(searchkeyword: String){
        
        let baseUrl = NSURL(string: "http://www.omdbapi.com")!
        let editedSearchKeyWord = searchkeyword.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        let url = NSURL(string: "?s=" + "\(editedSearchKeyWord)" + "&r=json", relativeToURL:baseUrl)!
        let request = NSMutableURLRequest(URL: url)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            if error != nil { println(error.localizedDescription)
            }
            var error: NSError?
            
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary
            if error != nil {
                println(error?.localizedDescription)
            }
            
            // Parse the result
            if let results: NSArray = jsonResult?["Search"] as? NSArray {
                self.delegate?.didReceiveSearchResults(results)
            }
//            var movies = [Movie]()
//            let jsonMovies = jsonResult?["Search"] as! [AnyObject]
//            for jsonMovie in jsonMovies {
//                let movie = Movie()
//                movie.title = jsonMovie["Title"] as! String
//                movie.year = jsonMovie["Year"] as! String
//                
//                movies.append(movie)
            

            })
        task.resume()
    }

}

protocol searchResultsProtocol {
    func didReceiveSearchResults(results: NSArray)
    
}
