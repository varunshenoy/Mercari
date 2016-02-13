//
//  MapVC.swift
//  Mercari
//
//  Created by Varun Shenoy on 1/30/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import MapKit
import Parse
import CoreLocation

class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var annotations = [CustomAnnotation]()
    var locationManager : CLLocationManager?
    
    var tagged:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true);
        
        let user = PFUser.currentUser()
        let query = PFQuery(className: "Businesses")
        query.whereKey("username", notEqualTo: (user?.username)!)
        query.findObjectsInBackgroundWithBlock { (objs: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                var count = 0
                for obj in objs! {
                    let annot = CustomAnnotation()
                    annot.image = obj["SkillRequired"].lowercaseString
                    let coords = obj["Location"] as! PFGeoPoint
                    annot.coordinate.latitude = CLLocationDegrees(coords.latitude)
                    annot.coordinate.longitude = CLLocationDegrees(coords.longitude)
                    let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(annot.coordinate.latitude, annot.coordinate.longitude)
                    annot.coordinate = location
                    annot.title = "\(obj["Name"])"
                    annot.subtitle = "\(obj["SkillRequired"])"
                    annot.image = "\(obj["SkillRequired"].lowercaseString)_pin.png"
                    print(annot.image)
                    annot.index = count
                    self.annotations.append(annot)
                    self.mapView.addAnnotation(annot)
                    count++
                }
            }
            else {
                print(error.debugDescription)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var annotatedView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if annotatedView == nil {
            annotatedView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotatedView!.canShowCallout = true
        }
        else {
            annotatedView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let pin = annotation as! CustomAnnotation
        annotatedView!.image = UIImage(named:pin.image)
        
        let btn = UIButton(type: .DetailDisclosure)
        btn.addTarget(self, action: "btnDisclosureAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.tag = (annotation as! CustomAnnotation).index
        annotatedView!.rightCalloutAccessoryView = btn
        
        return annotatedView
    }
    
    func btnDisclosureAction(sender: UIButton) {
        tagged = sender.tag
        performSegueWithIdentifier("Detail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Detail" {
            let nextScene =  segue.destinationViewController as! businessInfo
            let bus = business()
            bus.name = annotations[tagged].title!
            bus.skill = annotations[tagged].subtitle!
            nextScene.buisness = bus
        }
    }


    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
