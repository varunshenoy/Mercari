//
//  EquityVC.swift
//  Mercari
//
//  Created by Varun Shenoy on 1/31/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import Parse

class EquityVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    var buisness:business!
    
    var pickerDataSource = ["5%", "10%", "15%", "20%", "25%", "30%", "35%", "40%", "45%", "50%"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func askForEquity(sender: AnyObject) {
        let selected = pickerDataSource[pickerView.selectedRowInComponent(0)]
        print(selected)
        let user = PFUser.currentUser()
        
        let query = PFQuery(className: "Businesses")
        //query.whereKey("Name", equalTo: buisness.)
        //print(buisness.name)
        query.getFirstObjectInBackgroundWithBlock { (obj: PFObject?, error: NSError?) -> Void in
            if error == nil {
                obj?.addObject(user!.username!, forKey: "Buyers")
                obj?.addObject(selected, forKey: "BuyerEquity")
                obj?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let MainVC : UITabBarController = Storyboard.instantiateViewControllerWithIdentifier("Tabs") as! UITabBarController
                        self.presentViewController(MainVC, animated: true, completion: nil)
                    }
                    
                })
            }
        }

        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
