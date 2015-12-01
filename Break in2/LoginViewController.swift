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
  
  // Declare and initialize types of tests and difficulties available for selected career
  
  let tutorialImageNames:[String] = ["Numerical Reasoning", "Verbal Reasoning", "Logical Reasoning"]

  // Declare and initialize views
  
  let logoImageView:UIImageView = UIImageView()
  let profilePictureImageView:UIImageView = UIImageView()
  let sloganImageView:UIImageView = UIImageView()
  
  let loginView:UIView = UIView()
  var loginPageControllerView:PageControllerView = PageControllerView()
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let borderWidth:CGFloat = 3
  
  let buttonHeight:CGFloat = 50

    //---------------------------------------------------------------
    // VIEW DID LOAD
    //---------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addHomeBG()
      
      // Add logoImageView and profilePictureImageView to HomeViewController view
      
      self.view.addSubview(self.logoImageView)
      self.view.addSubview(self.profilePictureImageView)
      self.view.addSubview(self.sloganImageView)
      
      self.view.addSubview(self.loginView)

      // Customize and add content to imageViews
      
      self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
      self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
      
      self.profilePictureImageView.contentMode = UIViewContentMode.ScaleAspectFit
      self.profilePictureImageView.image = UIImage.init(named: "planeLogo")

      self.sloganImageView.contentMode = UIViewContentMode.ScaleAspectFit
      self.sloganImageView.image = UIImage.init(named: "asSlogan")
      
      // Customize loginView and it's subviews
      
      self.loginView.layer.cornerRadius = self.minorMargin
      self.loginView.backgroundColor = UIColor.whiteColor()
      
      // Set constraints
      
      self.setConstraints()
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
    
//    func processFacebook(user: PFUser, userData: [String: AnyObject]) {
//        
//        let facebookUserId = userData["id"] as! String
//        let link = "http://graph.facebook.com/\(facebookUserId)/picture"
//        let url = NSURL(string: link)
//        var request = NSURLRequest(URL: url!)
//        let params = ["height": "200", "width": "200", "type": "square"]
//        Alamofire.request(.GET, link, parameters: params).response() {
//            (request, response, data, error) in
//            
//            if error == nil {
//                var image = UIImage(data: data! )
//                
//                if image!.size.width > 280 {
//                    image = Images.resizeImage(image!, width: 280, height: 280)!
//                }
//                
//                let filePicture = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(image!, 0.6)!)
//                
//                filePicture!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
//                    if error != nil {
//                        self.noticeError("Error Saving Photo!")
//                    }
//                })
//                
//                if image!.size.width > 60 {
//                    image = Images.resizeImage(image!, width: 60, height: 60)!
//                }
//                let fileThumbnail = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(image!, 0.6)!)
//                fileThumbnail!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
//                    if error != nil {
//                        self.noticeError("Error Saving Photo!")
//                    }
//                })
//                
//                user[PF_USER_EMAILCOPY] = userData["email"]
//                user[PF_USER_FULLNAME] = userData["name"]
//                user[PF_USER_FULLNAME_LOWER] = (userData["name"] as! String).lowercaseString
//                user[PF_USER_FACEBOOKID] = userData["id"]
//                user[PF_USER_PICTURE] = filePicture
//                user[PF_USER_THUMBNAIL] = fileThumbnail
//                user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
//                    if error == nil {
//                        self.userLoggedIn(user)
//                    } else {
//                        PFUser.logOut()
//                        if let info = error?.userInfo {
//                            self.noticeError("Login error")
//                            print(info["error"] as! String)
//                        }
//                    }
//                })
//            } else {
//                PFUser.logOut()
//                
////                if let info = error?.userInfo {
////                    self.noticeError("Failed to fetch Facebook photo")
////                    print(info["error"] as! String)
////                }
//            }
//        }
//    }

    
    func userLoggedIn(user: PFUser) {
        //PushNotication.parsePushUserAssign()
        //self.performSegueWithIdentifier("settingsClicked", sender: nil)
        self.noticeTop("Welcome back, \(user[PF_USER_FULLNAME])!", autoClear: true, autoClearTime: 3)
        //self.dismissViewControllerAnimated(true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewControllerWithIdentifier("homeVC")
        presentViewController(homeVC, animated: true, completion: nil)
    }
  
  func setConstraints() {
    
    // Create and add constraints for logoImageView
    
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let logoImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
    let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
    self.view.addConstraints([logoImageViewCenterXConstraint, logoImageViewTopConstraint])
    
    // Create and add constraints for profilePictureImageView
    
    self.profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let profilePictureImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let profilePictureImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.logoImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin * 2)
    
    let profilePictureImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    let profilePictureImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    self.profilePictureImageView.addConstraints([profilePictureImageViewHeightConstraint, profilePictureImageViewWidthConstraint])
    self.view.addConstraints([profilePictureImageViewCenterXConstraint, profilePictureImageViewTopConstraint])
    
    // Create and add constraints for sloganImageView
    
    self.sloganImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let sloganImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let sloganImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.profilePictureImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin)
    
    let sloganImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    let sloganImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    self.sloganImageView.addConstraints([sloganImageViewHeightConstraint, sloganImageViewWidthConstraint])
    self.view.addConstraints([sloganImageViewCenterXConstraint, sloganImageViewTopConstraint])
    
    // Create and add constraints for loginView
    
    self.loginView.translatesAutoresizingMaskIntoConstraints = false
    
    let loginViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.sloganImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin)
    
    let loginViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let loginViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let loginViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    self.view.addConstraints([loginViewTopConstraint, loginViewLeftConstraint, loginViewRightConstraint, loginViewBottomConstraint])
    
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

