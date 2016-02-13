//
//  businessesView.swift
//  Mercari
//
//  Created by Varun Shenoy on 1/31/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//135

import UIKit
import Parse

class businessesView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var businesses = [business]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.table?.addSubview(refreshControl)
        self.loading.startAnimating()
        self.loading.hidesWhenStopped = true
        getPersonalProjects()
        // Do any additional setup after loading the view.
    }
    
    func refresh(sender:AnyObject) {
        if self.refreshControl.refreshing
        {
            businesses = []
            getPersonalProjects()
            self.table.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func getPersonalProjects() {
        let user = PFUser.currentUser()
        let query = PFQuery(className: "Businesses")
        query.whereKey("username", equalTo: user!.username!)
        query.findObjectsInBackgroundWithBlock { (objs: [PFObject]?, error: NSError?) -> Void in
            for obj in objs! {
                let bus = business()
                bus.name = obj["Name"] as! String
                bus.skill = obj["SkillRequired"] as! String
                self.businesses.append(bus)
                print("\(bus)-bus")
                self.table.reloadData()
                //print(self.businesses)
            }
        }
        
        
        self.loading.stopAnimating()
        self.table.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return businesses.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = table.dequeueReusableCellWithIdentifier("corp")!
        
        let corpName = businesses[indexPath.row].name
        
        let nameLabel = cell.viewWithTag(2) as! UILabel
        nameLabel.text = corpName
        
        let corpSkill = businesses[indexPath.row].skill
        let devLabel = cell.viewWithTag(3) as! UILabel
        devLabel.text = "Looking for: \(corpSkill.capitalizedString) Expert"
        let image = cell.viewWithTag(1) as! UIImageView
        image.image = UIImage(named: "\(corpSkill.lowercaseString).png")
        print("\(corpSkill).png")
        
        print(devLabel.text)
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 135
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetail" {
            let nextScene =  segue.destinationViewController as! businessInfo
            
            // Pass the selected object to the new view controller.
            if let indexPath = self.table.indexPathForSelectedRow {
                let selectedBusi = businesses[indexPath.row]
                nextScene.buisness = selectedBusi
                print(selectedBusi)
            }
        }
    }

}
