//
//  MovieSearchAnndListViewController.swift
//  OMDB Search
//
//  Created by Jeremy Frick on 5/28/15.
//  Copyright (c) 2015 Jeremy Frick. All rights reserved.
//

import Foundation
import UIKit

class MovieSearchAnndListViewController: UITableViewController, UISearchBarDelegate {

    let movie = Movie()
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Movies.count
            
    }
 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = movies[indexPath.row].Title
        cell.detailTextLabel?.text = movies[indexPath.row].Year
        return cell
    }
    
}
    

