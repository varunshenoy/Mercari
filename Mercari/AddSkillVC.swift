//
//  AddSkillVC.swift
//  Mercari
//
//  Created by Varun Shenoy on 1/30/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import Parse

class AddSkillVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var skillPicker: UIPickerView!
    var pickerDataSource = ["Android", "iOS", "Web Development", "Internet of Things", "Arduino", "Raspberry Pi", "Chrome Developer", "Node.js", "Graphic Design", "Java", "Database Design", "Ecommerce"]
    override func viewDidLoad() {
        super.viewDidLoad()

        skillPicker.dataSource = self
        skillPicker.delegate = self
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
    
    @IBAction func addSkill(sender: AnyObject) {
        let user = PFUser.currentUser()
        let selected = pickerDataSource[skillPicker.selectedRowInComponent(0)]
        var skills = user!["Skills"] as! [String]
        skills.append(selected)
        user!["Skills"] = Array(Set(skills))
        user?.saveInBackground()
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
