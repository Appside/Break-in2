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

class LoginViewController: UIViewController, UIScrollViewDelegate {
    
    //---------------------------------------------------------------
    // GLOBAL VARIABLES
    //---------------------------------------------------------------
  
  // Declare and initialize types of tests and difficulties available for selected career
  
  let tutorialImageNames:[String] = ["Numerical Reasoning", "Verbal Reasoning", "Logical Reasoning"]

  // Declare and initialize views
  
  let logoImageView:UIImageView = UIImageView()
  let profilePictureImageView:UIImageView = UIImageView()
  let sloganImageView:UIImageView = UIImageView()
  let loginScrollView:UIScrollView = UIScrollView()
  
  let loginView:UIView = UIView()
  var loginPageControllerView:PageControllerView = PageControllerView()
  var loginTutorialViews:[LoginTutorialView] = [LoginTutorialView]()
  let facebookLoginButton:UIButton = UIButton()
  let facebookLogoImageView:UIImageView = UIImageView()
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let borderWidth:CGFloat = 3
  
  let loginPageControllerViewHeight:CGFloat = 50
  let tutorialImageHeight:CGFloat = 150
  let buttonHeight:CGFloat = 50

    //---------------------------------------------------------------
    // VIEW DID LOAD
    //---------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBG("homeBG")
      
      // Add logoImageView and profilePictureImageView to HomeViewController view
      
      self.view.addSubview(self.logoImageView)
      self.view.addSubview(self.profilePictureImageView)
      self.view.addSubview(self.sloganImageView)
      
      self.view.addSubview(self.loginView)
      self.loginView.addSubview(self.loginScrollView)
      self.loginView.addSubview(self.loginPageControllerView)
      self.loginView.addSubview(self.facebookLoginButton)
      self.facebookLoginButton.addSubview(self.facebookLogoImageView)

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
      
      self.loginPageControllerView.numberOfPages = self.tutorialImageNames.count
      self.loginPageControllerView.minorMargin = self.minorMargin
      self.loginPageControllerView.pageControllerCircleHeight = 10
      self.loginPageControllerView.pageControllerSelectedCircleHeight = 18
      self.loginPageControllerView.pageControllerSelectedCircleThickness = 2
      
      self.facebookLoginButton.backgroundColor = UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
      self.facebookLoginButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
      self.facebookLoginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
      self.facebookLoginButton.setTitle("Login With Facebook", forState: UIControlState.Normal)
      
      self.facebookLogoImageView.contentMode = UIViewContentMode.ScaleAspectFit
      self.facebookLogoImageView.image = UIImage.init(named: "facebookButtonLight")
      
      // Create loginTutorialViews for each tutorialImage
    
      for var index = 0 ; index < self.tutorialImageNames.count ; index++ {
        
        let loginTutorialViewAtIndex:LoginTutorialView = LoginTutorialView()
        
        self.loginScrollView.addSubview(loginTutorialViewAtIndex)
        
        self.loginTutorialViews.append(loginTutorialViewAtIndex)
        
      }
      
      // Adjust testScrollView characteristics
      
      self.loginScrollView.pagingEnabled = true
      self.loginScrollView.showsHorizontalScrollIndicator = true
      
      self.loginScrollView.delegate = self
      
      // Add target for facebookLoginButton
      
      self.facebookLoginButton.addTarget(self, action: "buttonFBTapped:", forControlEvents: UIControlEvents.TouchUpInside)
      
      // Set constraints
      
      self.setConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //---------------------------------------------------------------
    // TAP FACEBOOK BUTTON
    //---------------------------------------------------------------
    
    func buttonFBTapped(sender: AnyObject) {
        
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
                self.noticeInfo("Facebook Sign In Error", autoClear: true, autoClearTime: 2)
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
                                self.noticeInfo("Facebook Sign In Error", autoClear: true, autoClearTime: 2)
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
//                            self.noticeInfo("Facebook Sign In Error", autoClear: true, autoClearTime: 2)
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
        self.noticeTop("Welcome, \(user[PF_USER_FULLNAME])!", autoClear: true, autoClearTime: 3)
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
    
    // Create and add constraints for loginView
    
    self.loginView.translatesAutoresizingMaskIntoConstraints = false
    
    let loginViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.loginPageControllerViewHeight + self.tutorialImageHeight + self.buttonHeight + (self.minorMargin * 3))
    
    let loginViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let loginViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let loginViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    self.loginView.addConstraint(loginViewHeightConstraint)
    self.view.addConstraints([loginViewLeftConstraint, loginViewRightConstraint, loginViewBottomConstraint])
    
    // Create and add constraints for loginPageControllerView
    
    self.loginPageControllerView.translatesAutoresizingMaskIntoConstraints = false
    
    let loginPageControllerViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginPageControllerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let loginPageControllerViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginPageControllerView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let loginPageControllerViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginPageControllerView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let loginPageControllerViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginPageControllerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.loginPageControllerViewHeight)
    
    self.loginPageControllerView.addConstraint(loginPageControllerViewHeightConstraint)
    self.view.addConstraints([loginPageControllerViewTopConstraint, loginPageControllerViewLeftConstraint, loginPageControllerViewRightConstraint])
    
    // Create and add constraints for facebookLoginButton
    
    self.facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
    
    let facebookLoginButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.buttonHeight)
    
    let facebookLoginButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let facebookLoginButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let facebookLoginButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    self.facebookLoginButton.addConstraint(facebookLoginButtonHeightConstraint)
    self.view.addConstraints([facebookLoginButtonLeftConstraint, facebookLoginButtonRightConstraint, facebookLoginButtonBottomConstraint])
    
    // Create and add constraints for facebookLogoImageView
    
    self.facebookLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let facebookLogoImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.facebookLoginButton, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
    
    let facebookLogoImageViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoImageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.facebookLoginButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
    
    let facebookLogoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.buttonHeight/2)
    
    let facebookLogoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.buttonHeight/2)
    
    self.facebookLogoImageView.addConstraints([facebookLogoImageViewHeightConstraint, facebookLogoImageViewWidthConstraint])
    self.view.addConstraints([facebookLogoImageViewCenterYConstraint, facebookLogoImageViewLeftConstraint])
    
    // Create and add constraints for loginScrollView
    
    self.loginScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let loginScrollViewTopConstraint = NSLayoutConstraint.init(item: self.loginScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.loginPageControllerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let loginScrollViewLeftConstraint = NSLayoutConstraint.init(item: self.loginScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let loginScrollViewRightConstraint = NSLayoutConstraint.init(item: self.loginScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let loginScrollViewBottomConstraint = NSLayoutConstraint.init(item: self.loginScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.facebookLoginButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    
    self.view.addConstraints([loginScrollViewTopConstraint, loginScrollViewLeftConstraint, loginScrollViewRightConstraint, loginScrollViewBottomConstraint])
    
    // Create and add constraints for each testTypeView and set content size for testScrollView
    
    for var index:Int = 0 ; index < self.tutorialImageNames.count ; index++ {
      
      self.loginTutorialViews[index].translatesAutoresizingMaskIntoConstraints = false
      
      let loginTutorialViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginTutorialViews[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.loginScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
      
      let loginTutorialViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginTutorialViews[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.tutorialImageHeight)
      
      let loginTutorialViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginTutorialViews[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (2 * self.majorMargin))
      
      if index == 0 {
        
        let loginTutorialViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginTutorialViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.loginScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.view.addConstraint(loginTutorialViewLeftConstraint)
        
      }
      else {
        
        let loginTutorialViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginTutorialViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.loginTutorialViews[index - 1], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.view.addConstraint(loginTutorialViewLeftConstraint)
        
      }
      
      self.loginTutorialViews[index].addConstraints([loginTutorialViewWidthConstraint, loginTutorialViewHeightConstraint])
      self.view.addConstraint(loginTutorialViewTopConstraint)
      
      if index == self.tutorialImageNames.count - 1 {
        
        let loginTutorialViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginTutorialViews[index], attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.loginScrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.view.addConstraint(loginTutorialViewRightConstraint)
      }
    }
    
    // Create and add constraints for sloganImageView
    
    self.sloganImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let sloganImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let sloganImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: self.minorMargin * -1)
    
    let sloganImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    let sloganImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    self.sloganImageView.addConstraints([sloganImageViewHeightConstraint, sloganImageViewWidthConstraint])
    self.view.addConstraints([sloganImageViewCenterXConstraint, sloganImageViewCenterYConstraint])

  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
    let pageIndex:Int = Int(self.loginScrollView.contentOffset.x / self.loginScrollView.frame.size.width)
    self.loginPageControllerView.updatePageController(pageIndex)
    
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