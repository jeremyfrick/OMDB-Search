//
//  Movie.swift
//  OMDB Search
//
//  Created by Jeremy Frick on 3/16/15.
//  Copyright (c) 2015 Jeremy Frick. All rights reserved.
//

import Foundation

struct Movie {
    let title: String
    let year: String
    let type: String
    let imdbID: String
    
    init(name: String, year: String,type: String, imdbID: String) {
        self.title = name
        self.year = year
        self.type = type
        self.imdbID = imdbID
        }
    
    static func moviesWithJSON(results: NSDictionary) ->[Movie] {
        let dataArray = results["Search"] as! NSArray
        var movies = [Movie]()
        if results.count > 0 {
            for result in dataArray {
                var title = result["Title"] as? String
                var year = result["Year"] as? String
                var type = result["Type"] as? String
                var imdbID = result["imdbID"] as? String
                var newMovie = Movie(name: title!, year: year!, type: type!, imdbID: imdbID!)
                movies.append(newMovie)
            }
           
        }
        return movies
    }
}