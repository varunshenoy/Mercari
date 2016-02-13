//
//  RegisterVC.swift
//  Mercari
//
//  Created by Varun Shenoy on 1/30/16.
//  Copyright © 2016 Varun Shenoy. All rights reserved.
//

import UIKit
import Parse

class RegisterVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypepassword: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Register(sender: AnyObject) {
        view.endEditing(true)
        signUp()
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
    
    func signUp() {
        if username.text != "" && password.text != "" && retypepassword.text != "" && email.text != "" && fullName.text != "" && phone.text != "" {
            if password.text == retypepassword.text {
                print("in")
                let user = PFUser()
                user.username = username.text
                user.password = password.text
                user.email = email.text
                
                user.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if error == nil {
                        user["Phone"] = self.phone.text;
                        user["FullName"] = self.fullName.text;
                        user["Skills"] = [];
                        let image = UIImage(named: "user_male.png")!
                        let scaledImage = self.resizeImage(image, newWidth: 125)
                        let imageData = UIImagePNGRepresentation(scaledImage)
                        let imageFile:PFFile = PFFile(data: imageData!)!
                        let currentUser = PFUser.currentUser()
                        currentUser!["ProfilePicture"] = imageFile
                        currentUser?.saveInBackground()
                    }
                })
                user.saveInBackground()
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
