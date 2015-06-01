//
//  MovieDetailViewController.swift
//  OMDB Search
//
//  Created by Jeremy Frick on 6/1/15.
//  Copyright (c) 2015 Jeremy Frick. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var movieName = String()
    var moveYear = String()
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.text = movieName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
