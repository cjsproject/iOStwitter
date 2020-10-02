//
//  LogoutTableViewController.swift
//  Twitter
//
//  Created by Cyrus Simons on 10/1/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArr = [NSDictionary]()
    var numTweets: Int!
    
    let tweetRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        tweetRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = tweetRefreshControl
      
    }
    
    @objc func loadTweets(){
        let resourceURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let resourceParameters = ["count": 10]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: resourceURL, parameters: resourceParameters, success: { (tweets: [NSDictionary]) in
            
            self.tweetArr.removeAll()
            for tweet in tweets{
                self.tweetArr.append(tweet)
            }
            
            self.tableView.reloadData()
            self.tweetRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("could not retreive tweet.")
        })
    }
    
    
    @IBAction func OnLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let user = tweetArr[indexPath.row]["user"] as? NSDictionary
        let uName = user?["name"] as? String
        cell.userLabel.text = uName

        
        let imageURL = URL(string: (user?["profile_image_url_https"] as? String)!)
        
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        let tweetContent = tweetArr[indexPath.row]["text"] as? String
        
        cell.tweetContentLabel.text = tweetContent
        
        return cell
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArr.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
