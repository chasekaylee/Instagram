//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Chase Lee on 2/3/16.
//  Copyright © 2016 Chase Lee. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate/*, UIScrollViewDelegate*/ {

    @IBOutlet weak var userStreamTableView: UITableView!
    
    var photos: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    
    
    /*var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userStreamTableView.dataSource = self
        userStreamTableView.delegate = self
        userStreamTableView.rowHeight = 320

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "getNewsFeed", forControlEvents: UIControlEvents.ValueChanged)
        self.userStreamTableView.insertSubview(refreshControl, atIndex: 0)
        
        getNewsFeed()
        
        
        /*
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, userStreamTableView.contentSize.height, userStreamTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        userStreamTableView.addSubview(loadingMoreView!)
        
        var insets = userStreamTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        userStreamTableView.contentInset = insets
        */

        // Do any additional setup after loading the view.
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let photos = photos {
            return photos.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        
        let photo = photos![indexPath.section]
        let images = (photo["images"] as! NSDictionary) ["standard_resolution"] as! NSDictionary
        let photoUrl = NSURL(string: images["url"] as! String)
        cell.photoView.setImageWithURL(photoUrl!)
        
        return cell
    }
    
    
    func getNewsFeed() {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        // Create the NSURLRequest
        let request = NSURLRequest(URL: url!)
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        // Do a network request
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.photos = responseDictionary["data"] as? [NSDictionary]
                            
                            /*
                            // Update flag
                            self.isMoreDataLoading = false
                            // Stop the loading indicator
                            self.loadingMoreView!.stopAnimating()
                            */

                            self.userStreamTableView.reloadData()
                            self.refreshControl?.endRefreshing()

                    }
                } else {
                    NSLog("Bad Request")
                    print("Bad Request")
                    self.refreshControl?.endRefreshing()
                }
        });
        task.resume()

    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        let photo = photos![section]
        let user = photo["user"] as! NSDictionary
        let photoUrl = NSURL(string: user["profile_picture"] as! String)
        
        profileView.setImageWithURL(photoUrl!)
        
        let usernameView = UILabel(frame: CGRect(x: 50, y: 10, width: 200, height: 30))
        usernameView.clipsToBounds = true
        usernameView.textColor = UIColor(red:0.022, green:0.21, blue:0.396, alpha:1)
        
        let username = user["username"] as! String
        usernameView.text = username
        
        headerView.addSubview(profileView)
        headerView.addSubview(usernameView)
        
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let photoDetailViewController = segue.destinationViewController as! PhotosDetailViewController
        let indexPath = userStreamTableView.indexPathForCell(sender as! UserCell)
        
        let photo = photos![(indexPath?.section)!]
        let images = (photo["images"] as! NSDictionary) ["standard_resolution"] as! NSDictionary
        let photoUrl = NSURL(string: images["url"] as! String)
        
        photoDetailViewController.imageUrl = photoUrl!
    
    }
    
    /*func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = userStreamTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - userStreamTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && userStreamTableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, userStreamTableView.contentSize.height, userStreamTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
            
                
                // Code to load more results
                getNewsFeed()
            }
        }
    }*/
}
