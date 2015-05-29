//
//  ViewController.swift
//  OMDB Search
//
//  Created by Jeremy Frick on 3/16/15.
//  Copyright (c) 2015 Jeremy Frick. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plotLabel: UITextView!
    @IBOutlet weak var yearReleasedLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var tomatoesLabel: UILabel!
    @IBOutlet weak var tomatoesRatingLabel: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var tomatoesRatingButton: UIButton!
    
    let movie = Movie()
    var imageCache = [String : UIImage]()
    var tomatoesStatus = false
    var keyboardIsShowing: Bool!
    var keyboardFrame: CGRect!
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 20.0
    var activeTextView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.searchBox.delegate = self
        self.titleLabel.numberOfLines = 1
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.yearLabel.hidden = true
        self.tomatoesRatingLabel.hidden = true
        self.tomatoesLabel.hidden = true
        self.tomatoesRatingButton.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    
    @IBAction func seachButtonPressed(sender: AnyObject) {
        self.moviePoster.hidden = true
        var searchString: String = searchBox.text
        var NewSearchString = searchString.stringByReplacingOccurrencesOfString(" ", withString: "+") as NSString
        searchDataBase(NewSearchString as String)
        self.tomatoesRatingButton.hidden = false
    
    }
    func searchDataBase(searchkeyword: String){
        let baseUrl = NSURL(string: "http://www.omdbapi.com")!
        let url = NSURL(string: "?s=" + "\(searchkeyword)" + "&r=json", relativeToURL:baseUrl)!
        let request = NSMutableURLRequest(URL: url)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            if error != nil { println(error.localizedDescription)
           }
            self.parseJsonData(data)

    })
    task.resume()

    }
    
    func pullSelectedMovieData(searchkeyword: String){
        let baseUrl = NSURL(string: "http://www.omdbapi.com")!
        let url = NSURL(string: "?t=" + "\(searchkeyword)" + "&y=&plot=short&tomatoes=true&r=json", relativeToURL:baseUrl)!
        let request = NSMutableURLRequest(URL: url)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            if error != nil { println(error.localizedDescription)
            }
            self.parseJsonData(data)
            
        })
        task.resume()
        
    }

    
    func parseJsonData(data: NSData)->[Movie]{
        var movies = [Movie]()
        var error: NSError?
        
        let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary
        
        if error != nil {
            println(error?.localizedDescription)
        }
        
        // Parse the result
        let jsonMovies = jsonResult?["Search"] as! [AnyObject]
        for jsonMovie in jsonMovies {
            let movie = Movie()
            movie.title = jsonResult?["Title"] as! String
            movie.year = jsonResult?["Year"] as! String
            
            movies.append(movie)
        }
        return movies
        
//            movie.Metascore = jsonResult?["Metascore"] as! String
//            movie.title = jsonResult?["Title"] as! String
//            movie.director = jsonResult?["Director"] as! String
//            movie.genere = jsonResult?["Genre"] as! String
//            movie.plot = jsonResult?["Plot"] as! String
//            movie.rated = jsonResult?["Rated"] as! String
//            movie.runtime = jsonResult?["Runtime"] as! String
//            movie.year = jsonResult?["Year"] as! String
//            movie.poster = jsonResult?["Poster"] as! String
//            movie.tomatoes = jsonResult?["tomatoUserRating"] as! String
        
//        dispatch_async(dispatch_get_main_queue(), {
//            self.titleLabel.text = self.movie.title as String
//            self.plotLabel.text = self.movie.plot as String
//            self.yearReleasedLabel.text = self.movie.year as String
//            self.yearLabel.hidden = false
//            self.tomatoesLabel.text = self.movie.tomatoes as String
//            self.updatePoster()
//           
//        })
        
    }
    
    @IBAction func TomatoesButtonPressed(sender: AnyObject) {
        if tomatoesStatus == false {
            self.tomatoesRatingLabel.hidden = false
            self.tomatoesLabel.hidden = false
            tomatoesStatus = true
        } else {
            self.tomatoesRatingLabel.hidden = true
            self.tomatoesLabel.hidden = true
            tomatoesStatus = false
        }
    }
    func updatePoster(){
        let Url = NSURL(string: self.movie.poster as String)
        var image = self.imageCache[self.movie.poster as String]
        if( image == nil ) {
            
            let request: NSURLRequest = NSURLRequest(URL: Url!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    self.imageCache[self.movie.poster as String] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        self.moviePoster.image = image
                        self.moviePoster.hidden = false
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.moviePoster.image = image
            self.moviePoster.hidden = false
        })

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        self.keyboardIsShowing = true
        
        if let info = notification.userInfo {
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            self.arrangeViewOffsetFromKeyboard()
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.keyboardIsShowing = false
        self.returnViewToInitialFrame()
        
    }
    
    func arrangeViewOffsetFromKeyboard()
    {
        var theApp: UIApplication = UIApplication.sharedApplication()
        var windowView: UIView? = theApp.delegate!.window!
        
        var textFieldLowerPoint: CGPoint = CGPointMake(self.searchBox!.frame.origin.x, self.searchBox!.frame.origin.y + self.searchBox!.frame.size.height)
        
        var convertedTextFieldLowerPoint: CGPoint = self.view.convertPoint(textFieldLowerPoint, toView: windowView)
        
        var targetTextFieldLowerPoint: CGPoint = CGPointMake(self.searchBox!.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset)
        
        var targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - convertedTextFieldLowerPoint.y
        var adjustedViewFrameCenter: CGPoint = CGPointMake(self.view.center.x, self.view.center.y + targetPointOffset)
        if self.keyboardFrame.origin.y < self.searchBox!.frame.origin.y {
            
            UIView.animateWithDuration(0.2, animations: {
                self.view.center = adjustedViewFrameCenter
            })
            
        }
    }
    
    func returnViewToInitialFrame()
    {
        var initialViewRect: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        
        if (!CGRectEqualToRect(initialViewRect, self.view.frame))
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame = initialViewRect
            });
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

