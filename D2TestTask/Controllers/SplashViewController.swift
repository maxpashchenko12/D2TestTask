//
//  SplashViewController.swift
//  D2TestTask
//
//  Created by mac on 26.04.2018.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, TwitterLoginDelegate {
    
    
let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        
        TwitterClient.sharedInstance?.delegate = self
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            if(!appDelegate.splashDelay) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.continueLogin()
                }
            }
        }
    
    
    func goToLogin() {
        performSegue(withIdentifier: "loginSegue", sender: self)
    }

    
    func goToApp() {
        self.performSegue(withIdentifier: "tabSegue", sender: self)
    }
    

    func continueLogin() {
        appDelegate.splashDelay = false
        if User.currentUser == nil {
            self.goToLogin()
        } else {
            self.goToApp()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
