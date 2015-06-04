


//
//  OnlineDataBaseSearch.swift
//  OMDB Search
//
//  Created by Jeremy Frick on 5/30/15.
//  Copyright (c) 2015 Jeremy Frick. All rights reserved.
//

import UIKit

class OnlineDataBaseSearch: NSObject {
    var delegate: searchResultsProtocol
    
    init(delegate: searchResultsProtocol){
        self.delegate = delegate
    }
    
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
            if let results: NSDictionary = jsonResult{
                self.delegate.didReceiveSearchResults(results)
            }
            })
        task.resume()
    }
    
    func pullSelectedMovieData(searchImdbId: String) {
        let baseUrl = NSURL(string: "http://www.omdbapi.com")!
        let url = NSURL(string: "?i=" + "\(searchImdbId)" + "&y=&plot=short&tomatoes=true&r=json", relativeToURL:baseUrl)!
        //let request = NSMutableURLRequest(URL: url)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithURL(url, completionHandler: {(data, response, error) -> Void in
            if error != nil { println(error.localizedDescription)
            }
            var error: NSError?
            
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary
            if error != nil {
                println(error?.localizedDescription)
            }
            
            // Parse the result
            if let results: NSDictionary = jsonResult {
                self.delegate.didReceiveSearchResults(results)            }
        })
        task.resume()
    }
}
//MARK: - Protocols

protocol searchResultsProtocol {
    func didReceiveSearchResults(results: NSDictionary)
    
}
