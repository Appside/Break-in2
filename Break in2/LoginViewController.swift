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
    
    //---------------------------------------------------------------
    // GLOBAL VARIABLES
    //---------------------------------------------------------------
    
    @IBOutlet weak var Test: UILabel!

    //---------------------------------------------------------------
    // VIEW DID LOAD
    //---------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addHomeBG()
        self.Test.text = "empty"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //---------------------------------------------------------------
    // TAP FACEBOOK BUTTON
    //---------------------------------------------------------------
    
    @IBAction func buttonFBTapped(sender: AnyObject) {
        
        //self.pleaseWait()
        self.noticeInfo("Please wait...", autoClear: true, autoClearTime: 2)
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"], block: { (user: PFUser?, error: NSError?) -> Void in
            
            self.clearAllNotice()
            
            if user != nil {
                if user![PF_USER_FACEBOOKID] == nil {
                    self.startFB(user!)
                } else {
                    self.clearAllNotice()
                    self.userLoggedIn(user!)
                }
            } else {
                if error != nil {
                    print(error)
                    if let info = error?.userInfo {
                        print(info)
                    }
                }
                self.noticeError("Facebook sign in error!")
            }
        })
        
        //check
            }
    
    func startFB(user: PFUser){
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self.parentViewController, handler: { (result, error) -> Void in
            
            if (error == nil){
                let fbloginresult:FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email")){
                    self.getFBUserData(user)
                    fbLoginManager.logOut()
                }else{
                    print(error)
                }
            }
        })

        
    }
    
    func getFBUserData(user: PFUser){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let userData = result as! [String: AnyObject]!
                    user[PF_USER_EMAILCOPY] = userData["email"]
                    user[PF_USER_FULLNAME] = userData["name"]
                    user[PF_USER_FULLNAME_LOWER] = (userData["name"] as! String).lowercaseString
                    user[PF_USER_FACEBOOKID] = userData["id"]

                    user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                        if error == nil {
                            self.userLoggedIn(user)
                        } else {
                            PFUser.logOut()
                            if let info = error?.userInfo {
                                self.noticeError("Login error")
                                //ProgressHUD.showError("Login error")
                                print(info["error"] as! String)
                            }
                        }
                    })

                    //print(result)
                    //self.processFacebook(user, userData: result as! [String : AnyObject])
                }
            })
        }
        
        
        
            //PFFacebookUtils.logInWithPermissions(["public_profile", "email", "user_friends"], block: { (user: PFUser!, error: NSError!) -> Void in
            
        
//        func requestFacebook(user: PFUser) {
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

    }
    
    func processFacebook(user: PFUser, userData: [String: AnyObject]) {
        
        let facebookUserId = userData["id"] as! String
        let link = "http://graph.facebook.com/\(facebookUserId)/picture"
        let url = NSURL(string: link)
        var request = NSURLRequest(URL: url!)
        let params = ["height": "200", "width": "200", "type": "square"]
        Alamofire.request(.GET, link, parameters: params).response() {
            (request, response, data, error) in
            
            if error == nil {
                var image = UIImage(data: data! )
                
                if image!.size.width > 280 {
                    image = Images.resizeImage(image!, width: 280, height: 280)!
                }
                
                let filePicture = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(image!, 0.6)!)
                
                filePicture!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if error != nil {
                        self.noticeError("Error Saving Photo!")
                    }
                })
                
                if image!.size.width > 60 {
                    image = Images.resizeImage(image!, width: 60, height: 60)!
                }
                let fileThumbnail = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(image!, 0.6)!)
                fileThumbnail!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if error != nil {
                        self.noticeError("Error Saving Photo!")
                    }
                })
                
                user[PF_USER_EMAILCOPY] = userData["email"]
                user[PF_USER_FULLNAME] = userData["name"]
                user[PF_USER_FULLNAME_LOWER] = (userData["name"] as! String).lowercaseString
                user[PF_USER_FACEBOOKID] = userData["id"]
                user[PF_USER_PICTURE] = filePicture
                user[PF_USER_THUMBNAIL] = fileThumbnail
                user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                    if error == nil {
                        self.userLoggedIn(user)
                    } else {
                        PFUser.logOut()
                        if let info = error?.userInfo {
                            self.noticeError("Login error")
                            print(info["error"] as! String)
                        }
                    }
                })
            } else {
                PFUser.logOut()
                
//                if let info = error?.userInfo {
//                    self.noticeError("Failed to fetch Facebook photo")
//                    print(info["error"] as! String)
//                }
            }
        }
    }

    
    func userLoggedIn(user: PFUser) {
        //PushNotication.parsePushUserAssign()
        self.noticeTop("Welcome back, \(user[PF_USER_FULLNAME])!", autoClear: true, autoClearTime: 3)
        self.dismissViewControllerAnimated(true, completion: nil)
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

