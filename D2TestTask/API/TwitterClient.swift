//
//  TwitterClient.swift
//  D2TestTask
//
//  Created by mac on 26.04.2018.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import BDBOAuth1Manager
import AFNetworking

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://publish.twitter.com")! as URL, consumerKey: "nHFDJ4qxmzQCpek6Xhjeu0Wi2", consumerSecret: "UMK8AHXkrE48zyXv6z1BnCAweZvjxiQz4ML2OgZZyX6GNHvgI8")
    
    var loginSuccess: (()->())?
    var loginFailure: ((NSError)->())?
    weak var delegate: TwitterLoginDelegate?

    
    //Getting Request Token to open up oauth link in Safari
    func login (success: @escaping ()->(), failure: @escaping (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(withPath: "/oauth/request_token", method: "GET", callbackURL: NSURL(string: "twittertest://oauth")! as URL, scope: nil, success: { (requestToken) in
            print("Got Token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=" + (requestToken?.token)!)
            
            UIApplication.shared.openURL(url! as URL)
        
        }) { (error) in
            print("error: \(String(describing: error?.localizedDescription))")
            self.loginFailure?(error! as NSError)
        
        }
    }
    
    //Get access token and save user
    func handleOpenURL(url: NSURL) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.splashDelay = true
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)!
        
        //Getting access token
        fetchAccessToken(withPath:"/oauth/access_token", method: "POST", requestToken: requestToken, success:
        { (accessToken) in
            self.currentAccount(success: { (user: User) in
                //Calling setter and saving user
                
                User.currentUser = user
                self.loginSuccess?()
                self.delegate?.continueLogin()
                
            }, failure: { (error) in
                self.loginFailure?(error)
            })
            self.loginSuccess?()
        }) { (error) in
            print("error: \(String(describing: error?.localizedDescription))")
            self.loginFailure?(error! as NSError)
        }
    }
    
    //Get the current account
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()) {
        get("/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
    }) { (task, error) in
            print("error\(error.localizedDescription)")
            failure(error as NSError)
    }
}
    
    //Get the home timeline of the current user
    func homeTimeline(success: ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        let params = ["count":10]
        
        get("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task, response) in
            print(response as Any)
        }) { (task, error) in
                failure(error as NSError)
        }
    }
    
    
    //Logout
    func logout() {
        User.currentUser = nil
        deauthorize()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name.init(User.userDidLogoutNotification), object: nil)
        
    }
    


}
