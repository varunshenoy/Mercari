//
//  ViewController.swift
//  Mercari
//
//  Created by Varun Shenoy on 1/30/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//


import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) { (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let MainVC : UITabBarController = Storyboard.instantiateViewControllerWithIdentifier("Tabs") as! UITabBarController
                    self.presentViewController(MainVC, animated: true, completion: nil)
                    
                    
                }
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}

