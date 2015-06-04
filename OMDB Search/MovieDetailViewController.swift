//
//  MovieDetailViewController.swift
//  OMDB Search
//
//  Created by Jeremy Frick on 6/1/15.
//  Copyright (c) 2015 Jeremy Frick. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, searchResultsProtocol  {
    lazy var api : OnlineDataBaseSearch = OnlineDataBaseSearch(delegate: self)
    var singleMovies = [SingleMovie]()
    var movie: Movie?
    var imageCache = [String : UIImage]()
    var posterLayer = CALayer()
    
    
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieRunTimeLabel: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var moviePlotText: UITextView!
    
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.title = movieName
        api.pullSelectedMovieData(self.movie!.imdbID)
        self.moviePoster.layer.cornerRadius = 5
        self.moviePoster.layer.masksToBounds = true
        self.moviePoster.layer.borderWidth = 1.0
        self.moviePoster.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    //MARK: - Pull Movie and poster data and update UI
    
    func didReceiveSearchResults(results: NSDictionary) {
        dispatch_async(dispatch_get_main_queue(), {
            self.singleMovies = SingleMovie.singleMovieWithJSON(results)
            self.title = self.singleMovies[0].title
            self.movieYearLabel.text = self.singleMovies[0].year
            self.movieRatingLabel.text = self.singleMovies[0].rated
            self.movieRunTimeLabel.text = self.singleMovies[0].runtime
            self.moviePlotText.text = self.singleMovies[0].plot
            self.updatePoster(self.singleMovies[0].poster)
        })
        //
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func updatePoster(posterUrl: String){
        let Url = NSURL(string: posterUrl)
        var image = self.imageCache[posterUrl]
        if( image == nil ) {
            
            let request: NSURLRequest = NSURLRequest(URL: Url!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    self.imageCache[posterUrl] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        self.moviePoster.image = image
                        
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.moviePoster.image = image
            
            
            
        })
        
    }
    
    //MARK: - Share feature implementation
    
    @IBAction func share(sender: AnyObject) {
        let shareText = "I am going to watch \(self.singleMovies[0].title)"
        let shareImage = self.moviePoster.image
        shareTextImage(sharingText: shareText, sharingImage: shareImage)
    }
    
    func shareTextImage(#sharingText: String?, sharingImage: UIImage?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }


    
    


}
