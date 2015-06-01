//
//  MovieSearchAnndListViewController.swift
//  OMDB Search
//
//  Created by Jeremy Frick on 5/28/15.
//  Copyright (c) 2015 Jeremy Frick. All rights reserved.
//

import Foundation
import UIKit

class MovieSearchAnndListViewController: UICollectionViewController ,UICollectionViewDataSource, searchResultsProtocol {

    let movie = Movie()
    var movies = [Movie]()
    var oMDBSearch = OnlineDataBaseSearch()
    var searchActive : Bool = false
    var tableData = []
    var imageCache = [String : UIImage]()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.searchBar.delegate = self
        oMDBSearch.delegate = self
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }
    
    //MARK: - SearchBar
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        searchActive = true;
//    }
//    
//    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//       // reloadData()
//        searchActive = false;
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        tableData = []
//        tableView.reloadData()
//        searchActive = false;
//    }
//    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        //reloadData()
//        searchActive = false;
//    }
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//       var lengthOfSearchText = count(searchText)
//        if lengthOfSearchText >= 3 {
//        oMDBSearch.searchDataBase(searchText)
//        }
//    }
    
    func didReceiveSearchResults(results: NSArray) {
        self.tableData = results
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView!.reloadData()
            })
}
    
    
    //MARK: - TableView
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MovieCell
        
                if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
                    filmTitle = rowData["Title"] as? String,
                    filmYear = rowData["Year"] as? String {
                        cell.movieTitle?.text =  filmTitle //movies[indexPath.row].title
                        cell.MovieYear?.text = filmYear //movies[indexPath.row].year
                        var cellColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
                        cell.backgroundColor = cellColor
                        
                        
                        
        }
        return cell
        
    }
    

    
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableData.count
//
//    }
//
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
//       
//        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
//            filmTitle = rowData["Title"] as? String,
//            filmYear = rowData["Year"] as? String {
//                cell.textLabel?.text =  filmTitle //movies[indexPath.row].title
//                cell.detailTextLabel?.text = filmYear //movies[indexPath.row].year
//        }
//        return cell
//    }
 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMovieDetail" {
            var indexPaths = collectionView?.indexPathsForSelectedItems() as! [NSIndexPath]
            var destinationViewController = segue.destinationViewController as! UINavigationController
            var movieDetailViewController = destinationViewController.viewControllers[0] as! MovieDetailViewController
            if let rowData: NSDictionary = self.tableData[indexPaths[0].row] as? NSDictionary,
                filmTitle = rowData["Title"] as? String,
                filmYear = rowData["Year"] as? String {
            movieDetailViewController.movieName = filmTitle
            }
            collectionView?.deselectItemAtIndexPath(indexPaths[0], animated: false)
        }
    }
}
    
extension MovieSearchAnndListViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // 1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        oMDBSearch.searchDataBase(textField.text)
        //{
//            results, error in
//            
//            //2
//            activityIndicator.removeFromSuperview()
//            if error != nil {
//                println("Error searching : \(error)")
//            }
//            
//            if results != nil {
//                //3
//                println("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
//                self.searches.insert(results!, atIndex: 0)
//                
//                //4
//                self.collectionView?.reloadData()
//            }
//        }
        
        activityIndicator.removeFromSuperview()
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
