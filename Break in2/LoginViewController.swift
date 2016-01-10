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
import CoreData
import SwiftSpinner
import SCLAlertView

class LoginViewController: UIViewController, UIScrollViewDelegate {
  
  //---------------------------------------------------------------
  // GLOBAL VARIABLES
  //---------------------------------------------------------------
  
  // Declare and initialize types of tests and difficulties available for selected career
  
  let tutorialImageNames:[String] = ["Numerical Reasoning", "Verbal Reasoning", "Logical Reasoning"]
  let homeViewModel:JSONModel = JSONModel()
    
  // Declare and initialize views
  
  let logoImageView:UIImageView = UIImageView()
  let profilePictureImageView:UIImageView = UIImageView()
  let sloganImageView:UIImageView = UIImageView()
  let loginScrollView:UIScrollView = UIScrollView()
  
  let loginView:UIView = UIView()
  let swipeUpLabel:UILabel = UILabel()
  var loginPageControllerView:PageControllerView = PageControllerView()
  var loginTutorialViews:[LoginTutorialView] = [LoginTutorialView]()
  let facebookLoginButton:FacebookButton = FacebookButton()
  
  var tutorialViewSwipeUpGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
  var tutorialViewSwipeDownGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
  
  var loginViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var loginScrollViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var loginViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var profilePictureImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint()
  
  var loginTutorialViewVisible:Bool = false
  var firstTimeUser:Bool = false
  
  let moc = DataController().managedObjectContext
    var ParseFBID:String = ""
    var Ptoken:String = ""
    var Ppermissions:AnyObject?
    var PdeclinedPerm:AnyObject?
    var PappId:String = ""
    var PuserId:String = ""
    var Pexpiration:NSDate?
    var Prefresh:NSDate?
    
    let defaults = NSUserDefaults.standardUserDefaults()
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let borderWidth:CGFloat = 3
  
  let loginPageControllerViewHeight:CGFloat = 50
  var tutorialImageHeight:CGFloat = 150
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
    self.loginView.addSubview(self.loginScrollView)
    self.loginView.addSubview(self.loginPageControllerView)
    self.loginView.addSubview(self.facebookLoginButton)
    self.loginView.addSubview(self.swipeUpLabel)
    
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
    
    self.swipeUpLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: 15)
    self.swipeUpLabel.textAlignment = NSTextAlignment.Center
    self.swipeUpLabel.textColor = UIColor.lightGrayColor()
    self.swipeUpLabel.text = "Swipe Up For Tutorial"
    //self.swipeUpLabel.backgroundColor = UIColor.lightGrayColor()
    
    self.loginPageControllerView.numberOfPages = self.tutorialImageNames.count
    self.loginPageControllerView.minorMargin = self.minorMargin
    self.loginPageControllerView.alpha = 0
    
    self.facebookLoginButton.facebookButtonTitle = "Login With Facebook"
    self.facebookLoginButton.displayButton()
    
    // Create loginTutorialViews for each tutorialImage
    
    for var index = 0 ; index < self.tutorialImageNames.count ; index++ {
      
      let loginTutorialViewAtIndex:LoginTutorialView = LoginTutorialView()
      
      self.loginScrollView.addSubview(loginTutorialViewAtIndex)
      
      self.loginTutorialViews.append(loginTutorialViewAtIndex)
      
    }
    
    // Adjust testScrollView characteristics
    
    self.loginScrollView.pagingEnabled = true
    self.loginScrollView.showsHorizontalScrollIndicator = true
    self.loginScrollView.backgroundColor = UIColor.lightGrayColor()
    
    self.loginScrollView.delegate = self
    
    // Add target for facebookLoginButton
    
    self.facebookLoginButton.addTarget(self, action: "hideLoginView", forControlEvents: UIControlEvents.TouchUpInside)
    
    // Set constraints
    
    self.setConstraints()
    
    // Set tutorialImageHeight
    
    self.tutorialImageHeight = self.screenFrame.height - (self.buttonHeight + (self.minorMargin * 3) + self.loginPageControllerViewHeight + self.statusBarFrame.height)
    
    // Set up, customise and add gestures
    
    self.tutorialViewSwipeUpGesture = UISwipeGestureRecognizer.init(target: self, action: Selector("showTutorial:"))
    self.tutorialViewSwipeUpGesture.direction = UISwipeGestureRecognizerDirection.Up
    self.loginView.addGestureRecognizer(self.tutorialViewSwipeUpGesture)
    
    self.tutorialViewSwipeDownGesture = UISwipeGestureRecognizer.init(target: self, action: Selector("hideTutorial:"))
    self.tutorialViewSwipeDownGesture.direction = UISwipeGestureRecognizerDirection.Down
    self.loginView.addGestureRecognizer(self.tutorialViewSwipeDownGesture)
    
  }

   //---------------------------------------------------------------
   // VIEW DID APPEAR
   //---------------------------------------------------------------
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    //self.profilePictureImageViewCenterYConstraint.constant = (self.screenFrame.height - (self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 3)) + self.statusBarFrame.height)/2
    self.view.layoutIfNeeded()
    self.showLoginView()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //---------------------------------------------------------------
  // TAP FACEBOOK BUTTON
  //---------------------------------------------------------------
  
    func buttonFBTapped(sender: AnyObject) {
        
        //self.pleaseWait()
        SwiftSpinner.show("Logging in...")
        //self.noticeInfo("Please wait...", autoClear: true, autoClearTime: 2)
        //self.clearAllNotice()
        
        fetchLoginCreds()
        
        if Ptoken != "" {
            
            let set = self.Ppermissions as! NSSet //NSSet
            let set2 = self.PdeclinedPerm as! NSSet
            let arr = set.allObjects //Swift Array
            let arr2 = set2.allObjects
            
            let token = FBSDKAccessToken.init(tokenString: self.Ptoken, permissions: arr, declinedPermissions: arr2, appID: self.PappId, userID: self.PuserId, expirationDate: self.Pexpiration, refreshDate: self.Prefresh)
            PFFacebookUtils.logInInBackgroundWithAccessToken(token, block: {(user: PFUser?, error: NSError?) -> Void in
                
                SwiftSpinner.hide()
                self.userLoggedIn((user)!)
                
            })
        }else{
            
            SwiftSpinner.hide()
            PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"], block: { (user: PFUser?, error: NSError?) -> Void in
                
                //self.clearAllNotice()
                SwiftSpinner.show("Creating profile...")
                
                if user != nil {
                    if user![PF_USER_FACEBOOKID] == nil {
                        //self.startFB(user!)
                        self.getFBUserData(user!)
                    } else {
                        self.clearAllNotice()
                        self.userLoggedIn(user!)
                    }
                } else {
                    if error != nil {
                        self.noticeInfo("Facebook Sign In Error", autoClear: true, autoClearTime: 2)
                    }
                    self.noticeInfo("Facebook Sign In Error", autoClear: true, autoClearTime: 2)
                }
            })
            
        }
        
    }
    
    //---------------------------------------------------------------
    // CURRENTLY UNUSED BUT WORKING
    //---------------------------------------------------------------

    
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

    //---------------------------------------------------------------
    // CORE DATA
    //---------------------------------------------------------------
    
  }
  
    func saveToCoreData(t: String, p: AnyObject, dP: AnyObject, aI:String, uI: String, ex: NSDate, r: NSDate) {
    
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: moc) as! Person
        entity.setValue(t, forKey: "token")
        entity.setValue(p, forKey: "permissions")
        entity.setValue(dP, forKey: "declinedPermissions")
        entity.setValue(aI, forKey: "appID")
        entity.setValue(uI, forKey: "userID")
        entity.setValue(ex, forKey: "expirationDate")
        entity.setValue(r, forKey: "refreshDate")
        do {
            try moc.save()
        } catch {
            fatalError("failed to save")
        }
        
    }
    
    func fetchLoginCreds() {
        
        let PersonFetch = NSFetchRequest(entityName: "Person")
        
        do {
            let fetchedPerson = try moc.executeFetchRequest(PersonFetch)
            
            if fetchedPerson.count > 0 {
                
                for item in fetchedPerson as! [NSManagedObject]{
                    
                    Ptoken = item.valueForKey("token") as! String
                    Ppermissions = item.valueForKey("permissions") as AnyObject!
                    PdeclinedPerm = item.valueForKey("declinedPermissions") as AnyObject!
                    PappId = item.valueForKey("appID") as! String
                    PuserId = item.valueForKey("userID") as! String
                    Pexpiration = (item.valueForKey("expirationDate") as! NSDate)
                    Prefresh = (item.valueForKey("refreshDate") as! NSDate)
                }
                
            }
            
        } catch {
            fatalError()
        }
    }

    //---------------------------------------------------------------
    // FIRST LOGIN TO APP
    //---------------------------------------------------------------

    func getFBUserData(user: PFUser){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let userData = result as! [String: AnyObject]!
                    user[PF_USER_EMAILCOPY] = userData["email"]
                    user[PF_USER_FULLNAME] = userData["name"]
                    user[PF_USER_FULLNAME_LOWER] = (userData["name"] as! String).lowercaseString
                    user[PF_USER_FACEBOOKID] = userData["id"]
                    
                    let token = FBSDKAccessToken.currentAccessToken().tokenString
                    let permissions = FBSDKAccessToken.currentAccessToken().permissions
                    let declinedPerm = FBSDKAccessToken.currentAccessToken().declinedPermissions
                    let appId = FBSDKAccessToken.currentAccessToken().appID
                    let userId = FBSDKAccessToken.currentAccessToken().userID
                    let expiration = FBSDKAccessToken.currentAccessToken().expirationDate
                    let refresh = FBSDKAccessToken.currentAccessToken().refreshDate
                    
                    
                    self.saveToCoreData(token, p: permissions, dP: declinedPerm, aI: appId, uI: userId, ex: expiration, r: refresh)
                    
                    user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                        if error == nil {
                            self.createCareerPrefs(user)
                            //self.userLoggedIn(user)
                        } else {
                            PFUser.logOut()
                            if let info = error?.userInfo {
                                self.noticeInfo("Facebook Sign In Error", autoClear: true, autoClearTime: 2)
                                //ProgressHUD.showError("Login error")
                                print(info["error"] as! String)
                            }
                        }
                    })
                }
            })
        }
    }
    
    //---------------------------------------------------------------
    // CREATE ARRAY IN PARSE
    //---------------------------------------------------------------
  
    func createCareerPrefs(user: PFUser){
        
        //let user = PFUser.currentUser()
        let careerPrefs = PFObject(className: PF_PREFERENCES_CLASS_NAME)
        careerPrefs[PF_PREFERENCES_USER] = user
        careerPrefs[PF_PREFERENCES_CAREERPREFS] = self.homeViewModel.getAppVariables("careerTypes") as! [String]
        careerPrefs[PF_PREFERENCES_USERNAME] = user[PF_USER_USERNAME]
        
        careerPrefs.saveInBackgroundWithBlock({ (succeeded, error: NSError?) -> Void in
            if error == nil {
                
                SwiftSpinner.hide()
                self.firstTimeUser = true
                self.userLoggedIn(user)
                
            } else {
                
                let saveError = SCLAlertView()
                saveError.showError("Error", subTitle: "Try again")
                
            }
        })
        
        
    }
    
    //---------------------------------------------------------------
    // USER LOGGED IN
    //---------------------------------------------------------------
  
  func userLoggedIn(user: PFUser) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if self.firstTimeUser {
      performSegueWithIdentifier("showTutorial", sender: nil)
    }
    else {
      performSegueWithIdentifier("userLoggedOn", sender: self)
    }
    //let homeVC = storyboard.instantiateViewControllerWithIdentifier("homeVC") as! HomeViewController
    //presentViewController(homeVC, animated: false, completion: nil)
    self.noticeTop("Welcome \(user[PF_USER_FULLNAME])!", autoClear: true, autoClearTime: 4)
  }
    
    
    //---------------------------------------------------------------
    // CONSTRAINTS
    //---------------------------------------------------------------
  
  func setConstraints() {
    
    // Create and add constraints for logoImageView
    
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let logoImageViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.profilePictureImageView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
    self.view.addConstraints([logoImageViewCenterXConstraint, logoImageViewBottomConstraint])
    
    // Create and add constraints for profilePictureImageView
    
    self.profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let profilePictureImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let profilePictureImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.profilePictureImageViewCenterYConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: (self.screenFrame.height - (self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 3)) + self.statusBarFrame.height)/2)
    
    let profilePictureImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.profilePictureImageView.addConstraints([profilePictureImageViewWidthConstraint, profilePictureImageViewHeightConstraint])
    self.view.addConstraints([profilePictureImageViewCenterXConstraint, self.profilePictureImageViewCenterYConstraint])
    
    // Create and add constraints for loginView
    
    self.loginView.translatesAutoresizingMaskIntoConstraints = false
    
    self.loginViewHeightConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 2))
    
    let loginViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let loginViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.loginViewBottomConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 3))
    
    self.loginView.addConstraint(self.loginViewHeightConstraint)
    self.view.addConstraints([loginViewLeftConstraint, loginViewRightConstraint, self.loginViewBottomConstraint])
    
    // Create and add constraints for loginPageControllerView
    
    self.loginPageControllerView.translatesAutoresizingMaskIntoConstraints = false
    
    let loginPageControllerViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginPageControllerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let loginPageControllerViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginPageControllerView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let loginPageControllerViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginPageControllerView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let loginPageControllerViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginPageControllerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.loginPageControllerViewHeight)
    
    self.loginPageControllerView.addConstraint(loginPageControllerViewHeightConstraint)
    self.view.addConstraints([loginPageControllerViewTopConstraint, loginPageControllerViewLeftConstraint, loginPageControllerViewRightConstraint])
    
    // Create and add constraints for swipeUpLabel
    
    self.swipeUpLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let swipeUpLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeUpLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.loginPageControllerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let swipeUpLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeUpLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.loginPageControllerView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let swipeUpLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeUpLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.loginPageControllerView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let swipeUpLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeUpLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.loginPageControllerViewHeight)
    
    self.swipeUpLabel.addConstraint(swipeUpLabelHeightConstraint)
    self.view.addConstraints([swipeUpLabelTopConstraint, swipeUpLabelLeftConstraint, swipeUpLabelRightConstraint])
    
    // Create and add constraints for facebookLoginButton
    
    self.facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
    
    let facebookLoginButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.buttonHeight)
    
    let facebookLoginButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let facebookLoginButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let facebookLoginButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    self.facebookLoginButton.addConstraint(facebookLoginButtonHeightConstraint)
    self.view.addConstraints([facebookLoginButtonLeftConstraint, facebookLoginButtonRightConstraint, facebookLoginButtonBottomConstraint])
    
    // Create and add constraints for loginScrollView
    
    self.loginScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let loginScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.loginPageControllerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let loginScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let loginScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    self.loginScrollViewBottomConstraint = NSLayoutConstraint.init(item: self.loginScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.facebookLoginButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
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
    
    let sloganImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.profilePictureImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let sloganImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
    
    let sloganImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.sloganImageView.addConstraints([sloganImageViewHeightConstraint, sloganImageViewWidthConstraint])
    self.view.addConstraints([sloganImageViewCenterXConstraint, sloganImageViewTopConstraint])
    
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
    let pageIndex:Int = Int(self.loginScrollView.contentOffset.x / self.loginScrollView.frame.size.width)
    self.loginPageControllerView.updatePageController(pageIndex)
    
  }
  
  func showTutorial(sender: UISwipeGestureRecognizer) {
    
    UIView.animateWithDuration(1, animations: {
      
      self.loginViewHeightConstraint.constant = self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 3) + self.tutorialImageHeight
      self.loginScrollViewBottomConstraint.constant = self.minorMargin * -1
      self.view.layoutIfNeeded()
      
      self.swipeUpLabel.alpha = 0
      self.loginPageControllerView.alpha = 1
      
      }, completion: nil)
    
    self.loginTutorialViewVisible = true
  }
  
  func hideTutorial(sender: UISwipeGestureRecognizer) {
    
    UIView.animateWithDuration(1, animations: {
      
      self.loginScrollViewBottomConstraint.constant = 0
      self.loginViewHeightConstraint.constant = self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 2)
      self.view.layoutIfNeeded()
      
      self.swipeUpLabel.alpha = 1
      self.loginPageControllerView.alpha = 0
      
      }, completion: nil)
    
    self.loginTutorialViewVisible = false
  }
  
  func showLoginView() {
    
    UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      self.loginViewBottomConstraint.constant = self.minorMargin
      self.view.layoutIfNeeded()
      
      }, completion: nil)
    
  }
  
  func hideLoginView() {
      
      UIView.animateWithDuration(1, animations: {
        
        if self.loginTutorialViewVisible {
          
          self.loginViewHeightConstraint.constant = self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 2)
          self.loginScrollViewBottomConstraint.constant = 0
          self.view.layoutIfNeeded()
          
          self.swipeUpLabel.alpha = 1
          self.loginPageControllerView.alpha = 0
          
          self.loginTutorialViewVisible = false
          
        }
        
        }, completion: {(Bool) in
      
          UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.loginViewBottomConstraint.constant = self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 3)
            self.view.layoutIfNeeded()
            
            }, completion: {(Bool) in
              
              self.buttonFBTapped(self.facebookLoginButton)
              
          })
      
      })
    
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