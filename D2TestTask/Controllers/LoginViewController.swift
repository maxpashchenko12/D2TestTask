//
//  LoginViewController.swift
//  D2TestTask
//
//  Created by mac on 26.04.2018.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func loginButtonAction(_ sender: Any) {
        TwitterClient.sharedInstance?.login(success: {
            print("Logged In")
            self.dismiss(animated: true, completion: {
                
            })
        }) { (error) in
            print(error)
    }
}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
