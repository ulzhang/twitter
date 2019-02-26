//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Kevin Zhang on 2/25/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        // #selector
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl

    }
    
    @objc func loadTweets(){
        
        numberOfTweets = 20
        
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // cleam up tweet array
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // reload data after api call
            self.tableView.reloadData()
            
            // stop the refreshing
            self.myRefreshControl.endRefreshing()
            
            
        }, failure: { (Error) in
            print("could not retrieve tweets")
        })
        
    }
    
    
    
    // infinite scroll
    func loadMoreTweets() {
        
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        // incrememnt by 20
        numberOfTweets = numberOfTweets + 20
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // cleam up tweet array
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // reload data after api call
            self.tableView.reloadData()
            
            
        }, failure: { (Error) in
            print("could not retrieve tweets")
        })
        
    }
    
    // triggers when user gets to end of table
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    
    
    

    @IBAction func logoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        // how to load pictures
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }



}
