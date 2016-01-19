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
    
    static func moviesWithJSON(results: JSON) ->[Movie] {
        let dataArray = results["Search"].array
        var movies = [Movie]()
        if dataArray!.count > 0 {
            for result in dataArray! {
                let title = result["Title"].string
                let year = result["Year"].string
                let type = result["Type"].string
                let imdbID = result["imdbID"].string
                let newMovie = Movie(name: title!, year: year!, type: type!, imdbID: imdbID!)
                movies.append(newMovie)
            }
           
        }
        return movies
    }
}