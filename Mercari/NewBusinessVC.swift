//
//  NewBusinessVC.swift
//  Mercari
//
//  Created by Varun Shenoy on 1/30/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import Parse

class NewBusinessVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var businessname: UITextField!
    @IBOutlet weak var goals: UITextField!
    @IBOutlet weak var pitch: DesignableTextView!
    @IBOutlet weak var pickerView: UIPickerView!
    
     var pickerDataSource = ["Android", "iOS", "Web Development", "Internet of Things", "Arduino", "Raspberry Pi", "Chrome Developer", "Node.js", "Graphic Design", "Java", "Database Design", "Ecommerce"]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    } 
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addBusiness(sender: AnyObject) {
        let curUser = PFUser.currentUser()
        let business = PFObject(className: "Businesses")
        business.setObject((curUser?.username)!, forKey: "username")
        business.setObject(self.pickerDataSource[self.pickerView.selectedRowInComponent(0)], forKey: "SkillRequired")
        business.setObject(self.businessname.text!, forKey: "Name")
        business.setObject(self.pitch.text, forKey: "Pitch")
        business.setObject(self.goals.text!, forKey: "Goals")
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                business.setObject(geopoint!, forKey: "Location")
                business.saveInBackground()
            } else {
                print(error.debugDescription)
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
