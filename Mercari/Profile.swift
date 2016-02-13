//
//  Profile.swift
//  Mercari
//
//  Created by Varun Shenoy on 1/30/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import Parse

class Profile: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var skillCollection: UICollectionView!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skillCollection.delegate = self
        skillCollection.dataSource = self
        imagePicker.delegate = self
        let user = PFUser.currentUser()
        let profPic = user!["ProfilePicture"] as! PFFile
        profPic.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            if error == nil {
                let image = UIImage(data: data!)
                self.profImage.image = image
            }
        }

        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let user = PFUser.currentUser()
        let skills = user!["Skills"] as! [String]
        if let  cell = collectionView.dequeueReusableCellWithReuseIdentifier("skill", forIndexPath: indexPath) as? SkillCell {
            let skill = skills[indexPath.row]
            cell.configureCell(skill)
            print(skill)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(120, 120)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let user = PFUser.currentUser()
        let skills = user!["Skills"] as! [String]
        return skills.count
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let scaledImage = resizeImage(pickedImage, newWidth: 125)
            let imageData = UIImagePNGRepresentation(scaledImage)
            let imageFile:PFFile = PFFile(data: imageData!)!
            let currentUser = PFUser.currentUser()
            currentUser!["ProfilePicture"] = imageFile
            currentUser?.saveInBackground()
            profImage.image = scaledImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeProfilePicture(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
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
