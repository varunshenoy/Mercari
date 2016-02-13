//
//  businessInfo.swift
//  Mercari
//
//  Created by Varun Shenoy on 1/31/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import Parse

class businessInfo: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    var buisness:business!
    @IBOutlet weak var email: DesignableButton!
    @IBOutlet weak var call: DesignableButton!
    @IBOutlet weak var aboutBusiness: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var needLabel: UILabel!
    

    var pickerDataSource = ["5%", "10%", "15%", "20%", "25%", "30%", "35%", "40%", "45%", "50%"]


    override func viewDidLoad() {
        super.viewDidLoad()
        //let user = PFUser.currentUser()
        let query = PFQuery(className: "Businesses")
        query.whereKey("Name", equalTo: buisness.name)
        query.findObjectsInBackgroundWithBlock { (objs: [PFObject]?, error: NSError?) -> Void in
            for obj in objs! {
                self.aboutBusiness.text = obj["Pitch"] as? String
                self.nameLabel.text = obj["Name"] as? String
                //self.username = obj["username"] as! String
                let need = self.buisness.skill
                self.needLabel.text = "\(need.uppercaseString) EXPERT NEEDED"
            }

        }
        //let user = PFUser.currentUser()
        //username = (user?.username)!
    
        image.image = UIImage(named: "\(self.buisness.skill.lowercaseString).png")

        
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

    @IBAction func callBusiness(sender: AnyObject) {
        if let url = NSURL(string: "tel://\("14084785682")") {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    @IBAction func draftEmail(sender: AnyObject) {
            let url = NSURL(string: "mailto:\("varun.nshenoy@gmail.com")?subject=I%20am%20interested%20in%20\(self.nameLabel.text)&body=I%20would%20like%20to%20request%20a%20meeting%20to%20talk%20about%20\(self.nameLabel.text).%20I%20am%20interested%20in%20backing%20your%20project.%0D%0A%0D%0ASent%20with%20Mercari.")
            UIApplication.sharedApplication().openURL(url!)

    }
    
    /*@IBAction func askForEquity(sender: AnyObject) {
        let selected = pickerDataSource[equityPicker.selectedRowInComponent(0)]
        print(selected)
        let user = PFUser.currentUser()?.username
        
        let query = PFQuery(className: "Businesses")
        query.whereKey("Name", equalTo: buisness.name)
        query.getFirstObjectInBackgroundWithBlock { (obj: PFObject?, error: NSError?) -> Void in
            if error == nil {
                obj?.addObject(user!, forKey: "Buyers")
                obj?.addObject(selected, forKey: "BuyerEquity")
                obj?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    self.equityView.animation = "fall"
                    self.equityView.animate()
                    UIView.animateWithDuration(0.5) { () -> Void in
                        self.equityView.alpha = 0;
                    }
                    
                })
            }
        }
    }*/
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ToScrollEquity" {
            let nextScene =  segue.destinationViewController as! EquityVC
            nextScene.buisness = buisness
            
        }
    }

}
