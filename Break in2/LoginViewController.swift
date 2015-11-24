//
//  LoginViewController.swift
//  Break in2
//
//  Created by Jonathan Crawford on 08/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import Alamofire
import Parse
import ParseUI
import ParseFacebookUtilsV4
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addHomeBG()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // from here

//    @IBAction func buttonFBTapped(sender: AnyObject) {
//        self.pleaseWait()
//        
//        //check
//        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        fbLoginManager.logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
//            if (error == nil){
//                var fbloginresult : FBSDKLoginManagerLoginResult = result
//                if(fbloginresult.grantedPermissions.containsObject("email"))
//                {
//                    self.getFBUserData()
//                    fbLoginManager.logOut()
//                }
//            }
//        })
//    }
//    
//    func getFBUserData(){
//        if((FBSDKAccessToken.currentAccessToken()) != nil){
//            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
//                if (error == nil){
//                    println(result)
//                }
//            })
//        }
//        
//        PFFacebookUtils.logInInBackgroundWithPublishPermissions(["public_profile", "email", "user_friends"], block: { (user: PFUser?, error: NSError?) -> Void in
//        
//            //PFFacebookUtils.logInWithPermissions(["public_profile", "email", "user_friends"], block: { (user: PFUser!, error: NSError!) -> Void in
//            if user != nil {
//                if user![PF_USER_FACEBOOKID] == nil {
//                    self.requestFacebook(user)
//                } else {
//                    self.userLoggedIn(user)
//                }
//            } else {
//                if error != nil {
//                    print(error)
//                    if let info = error?.userInfo {
//                        print(info)
//                    }
//                }
//                self.noticeError("Facebook sign in error!")
//            }
//        })
//        
//        func requestFacebook(user: PFUser) {
//            fbreques
//            let request = FBRequest.requestForMe()
//            request.startWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
//                if error == nil {
//                    let userData = result as! [String: AnyObject]!
//                    self.processFacebook(user, userData: userData)
//                } else {
//                    PFUser.logOut()
//                    ProgressHUD.showError("Failed to fetch Facebook user data")
//                }
//            }
//        }
//        
//        func processFacebook(user: PFUser, userData: [String: AnyObject]) {
//            let facebookUserId = userData["id"] as! String
//            var link = "http://graph.facebook.com/\(facebookUserId)/picture"
//            let url = NSURL(string: link)
//            var request = NSURLRequest(URL: url!)
//            let params = ["height": "200", "width": "200", "type": "square"]
//            Alamofire.request(.GET, link, parameters: params).response() {
//                (request, response, data, error) in
//                
//                if error == nil {
//                    var image = UIImage(data: data! as! NSData)!
//                    
//                    if image.size.width > 280 {
//                        image = Images.resizeImage(image, width: 280, height: 280)!
//                    }
//                    var filePicture = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(image, 0.6))
//                    filePicture.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
//                        if error != nil {
//                            ProgressHUD.showError("Error saving photo")
//                        }
//                    })
//                    
//                    if image.size.width > 60 {
//                        image = Images.resizeImage(image, width: 60, height: 60)!
//                    }
//                    var fileThumbnail = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(image, 0.6))
//                    fileThumbnail.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
//                        if error != nil {
//                            ProgressHUD.showError("Error saving thumbnail")
//                        }
//                    })
//                    
//                    user[PF_USER_EMAILCOPY] = userData["email"]
//                    user[PF_USER_FULLNAME] = userData["name"]
//                    user[PF_USER_FULLNAME_LOWER] = (userData["name"] as! String).lowercaseString
//                    user[PF_USER_FACEBOOKID] = userData["id"]
//                    user[PF_USER_PICTURE] = filePicture
//                    user[PF_USER_THUMBNAIL] = fileThumbnail
//                    user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
//                        if error == nil {
//                            self.userLoggedIn(user)
//                        } else {
//                            PFUser.logOut()
//                            if let info = error?.userInfo {
//                                ProgressHUD.showError("Login error")
//                                print(info["error"] as! String)
//                            }
//                        }
//                    })
//                } else {
//                    PFUser.logOut()
//                    if let info = error?.userInfo {
//                        ProgressHUD.showError("Failed to fetch Facebook photo")
//                        print(info["error"] as! String)
//                    }
//                }
//            }
//        }
//        
//        func userLoggedIn(user: PFUser) {
//            PushNotication.parsePushUserAssign()
//            ProgressHUD.showSuccess("Welcome back, \(user[PF_USER_FULLNAME])!")
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
//
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
