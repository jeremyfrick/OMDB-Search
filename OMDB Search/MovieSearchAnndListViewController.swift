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
    var movies = [Movie]()
    var oMDBSearch: OnlineDataBaseSearch!
    var searchActive : Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        oMDBSearch = OnlineDataBaseSearch(delegate: self)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }
    
    
    func didReceiveSearchResults(results: NSDictionary) {
        dispatch_async(dispatch_get_main_queue(), {
            self.movies = Movie.moviesWithJSON(results)
            self.collectionView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
}
    
    
    //MARK: - TableView
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MovieCell
        let movie = self.movies[indexPath.row]
                cell.movieTitle?.text =  movie.title
                cell.MovieYear?.text = movie.year
                cell.layer.cornerRadius = 5
                cell.layer.masksToBounds = true
                return cell
    }
    
    //MARK: - Segue Control
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMovieDetail" {
            var indexPaths = collectionView?.indexPathsForSelectedItems() as! [NSIndexPath]
            var destinationViewController = segue.destinationViewController as! UINavigationController
            var movieDetailViewController = destinationViewController.viewControllers[0] as! MovieDetailViewController
            let selectedMovie = self.movies[indexPaths[0].row]
            movieDetailViewController.movie = selectedMovie
            collectionView?.deselectItemAtIndexPath(indexPaths[0], animated: false)
        }
    }
}
    
extension MovieSearchAnndListViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        oMDBSearch.searchDataBase(textField.text)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        activityIndicator.removeFromSuperview()
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}



