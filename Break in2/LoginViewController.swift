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
  
  let loginViewModel:JSONModel = JSONModel()
  
  //set number of lives
    var setNumberOfLivesFree:Int = 3
    
  // Declare and initialize views
  
  let logoImageView:UIImageView = UIImageView()
  let profilePictureImageView:UIImageView = UIImageView()
  let sloganImageView:UIImageView = UIImageView()
  
  let loginView:UIView = UIView()
  let facebookLoginButton:FacebookButton = FacebookButton()
  
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
  var buttonHeight:CGFloat = 50
  var textSize:CGFloat = 15
  
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
    self.loginView.addSubview(self.facebookLoginButton)
    
    self.textSize = self.view.getTextSize(15)
    
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
    
    self.facebookLoginButton.facebookButtonTitle = "Login With Facebook"
    self.facebookLoginButton.displayButton()
    
    // Add target for facebookLoginButton
    
    self.facebookLoginButton.addTarget(self, action: #selector(LoginViewController.hideLoginView), forControlEvents: UIControlEvents.TouchUpInside)
    
    // Set menuButtonHeight, backButtonHeight and calendarBackgroundViewHeight
    
    if self.screenFrame.height <= 738 {
      let calendarBackgroundViewHeight = self.screenFrame.width - (self.majorMargin * 4)
      
      let careerBackgroundViewHeight:CGFloat = self.screenFrame.height - (self.statusBarFrame.height + (self.screenFrame.height/12) + (self.majorMargin * 2) + calendarBackgroundViewHeight + self.minorMargin)
      self.buttonHeight = (careerBackgroundViewHeight - ((self.minorMargin * 6) + 25))/4
      
    }
    else {
      let calendarBackgroundViewHeight = self.screenFrame.width - (self.majorMargin * 14)
      
      let careerBackgroundViewHeight:CGFloat = self.screenFrame.height - (self.statusBarFrame.height + (self.screenFrame.height/12) + (self.majorMargin * 2) + calendarBackgroundViewHeight + self.minorMargin)
      self.buttonHeight = (careerBackgroundViewHeight - ((self.minorMargin * 7) + 25))/5
    }
    
    // Set constraints
    
    self.setConstraints()
    
    // Set tutorialImageHeight
    
    self.tutorialImageHeight = self.screenFrame.height - (self.buttonHeight + (self.minorMargin * 3) + self.loginPageControllerViewHeight + self.statusBarFrame.height)

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
      
      //self.loginViewModel.updateQuestions()
      
        fetchLoginCreds()
        
        if Ptoken != "" {
            
            let set = self.Ppermissions as! NSSet //NSSet
            let set2 = self.PdeclinedPerm as! NSSet
            let arr = set.allObjects //Swift Array
            let arr2 = set2.allObjects
            
            let token = FBSDKAccessToken.init(tokenString: self.Ptoken, permissions: arr, declinedPermissions: arr2, appID: self.PappId, userID: self.PuserId, expirationDate: self.Pexpiration, refreshDate: self.Prefresh)
            PFFacebookUtils.logInInBackgroundWithAccessToken(token, block: {(user: PFUser?, error: NSError?) -> Void in
                
                if user != nil {
                    
                    let membership = user![PF_USER_MEMBERSHIP] as! String
                    
                    print(membership)
                    self.defaults.setObject(membership, forKey: "Membership")
                    
                    self.defaults.setObject(user![PF_USER_FIRST_NAME] as! String, forKey: "profileFirstName")
                    self.defaults.setObject(user![PF_USER_SURNAME] as! String, forKey: "profileLastName")
                    self.defaults.setObject(user![PF_USER_EMAILCOPY] as! String, forKey: "profileEmail")
                    self.defaults.setObject(user![PF_USER_PHONE] as! String, forKey: "profilePhone")
                    self.defaults.setObject(user![PF_USER_UNIVERSITY] as! String, forKey: "profileUniversity")
                    self.defaults.setObject(user![PF_USER_COURSE] as! String, forKey: "profileCourse")
                    self.defaults.setObject(user![PF_USER_DEGREE] as! String, forKey: "profileDegree")
                    self.defaults.setObject(user![PF_USER_POSITION] as! String, forKey: "profilePosition")
                    self.defaults.setObject(user![PF_USER_SHARE_INFO_ALLOWED], forKey: "shareInfoAllowed")
                    self.defaults.setObject(user![PF_USER_RECOMMENDED_BY], forKey: "recommendedBy")
                    
                SwiftSpinner.hide()
                self.userLoggedIn((user)!)
                    
                }else{
                    
                    self.getFBUserData(user!)
                    
                }
                
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
                        //this will still make the "already authorised app come up"
                        self.getFBUserData(user!)
                    }
                } else {
                    if error != nil {
                        SwiftSpinner.show("Login Error", animated: false).addTapHandler({
                            
                            SwiftSpinner.hide()
                            
                            }, subtitle: "Please try again. Tap to dismiss")
                    }
                    SwiftSpinner.show("Login Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Please try again. Tap to dismiss")
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
            SwiftSpinner.show("Login Error STCD", animated: false).addTapHandler({
                
                SwiftSpinner.hide()
                
                }, subtitle: "Please try again. Tap to dismiss")
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
            SwiftSpinner.show("Login Error STCD2", animated: false).addTapHandler({
                
                SwiftSpinner.hide()
                
                }, subtitle: "Please try again. Tap to dismiss")
        }
    }

    //---------------------------------------------------------------
    // FIRST LOGIN TO APP
    //---------------------------------------------------------------

    func getFBUserData(user: PFUser){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    
                    if user.isNew{
                    
                    let userData = result as! [String: AnyObject]!
                    user[PF_USER_EMAILCOPY] = userData["email"]
                    user[PF_USER_FULLNAME] = userData["name"]
                    user[PF_USER_FULLNAME_LOWER] = (userData["name"] as! String).lowercaseString
                    user[PF_USER_FIRST_NAME] = userData["first_name"]
                    user[PF_USER_SURNAME] = userData["last_name"]
                    user[PF_USER_FACEBOOKID] = userData["id"]
                    user[PF_USER_MEMBERSHIP] = "Free"
                    user[PF_USER_NUMBER_LIVES] = self.setNumberOfLivesFree
                    
                    self.defaults.setObject("Free", forKey: "Membership")
                    self.defaults.setObject(userData["first_name"], forKey: "profileFirstName")
                    self.defaults.setObject(userData["last_name"], forKey: "profileLastName")
                    self.defaults.setObject(userData["email"], forKey: "profileEmail")
                    self.defaults.setInteger(self.setNumberOfLivesFree, forKey: "Lives")
                    
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
                            if let _ = error?.userInfo {
                                SwiftSpinner.show("Login Error FBKSI", animated: false).addTapHandler({
                                    
                                    SwiftSpinner.hide()
                                    
                                    }, subtitle: "Please try again. Tap to dismiss")
                            }
                        }
                      
                    })
                    }else{
                        
                        let token = FBSDKAccessToken.currentAccessToken().tokenString
                        let permissions = FBSDKAccessToken.currentAccessToken().permissions
                        let declinedPerm = FBSDKAccessToken.currentAccessToken().declinedPermissions
                        let appId = FBSDKAccessToken.currentAccessToken().appID
                        let userId = FBSDKAccessToken.currentAccessToken().userID
                        let expiration = FBSDKAccessToken.currentAccessToken().expirationDate
                        let refresh = FBSDKAccessToken.currentAccessToken().refreshDate
                        
                        self.saveToCoreData(token, p: permissions, dP: declinedPerm, aI: appId, uI: userId, ex: expiration, r: refresh)
                        
                        self.fetchLoginCreds()
                        
                        if self.Ptoken != "" {
                            
                            let set = self.Ppermissions as! NSSet //NSSet
                            let set2 = self.PdeclinedPerm as! NSSet
                            let arr = set.allObjects //Swift Array
                            let arr2 = set2.allObjects
                            
                            let token = FBSDKAccessToken.init(tokenString: self.Ptoken, permissions: arr, declinedPermissions: arr2, appID: self.PappId, userID: self.PuserId, expirationDate: self.Pexpiration, refreshDate: self.Prefresh)
                            PFFacebookUtils.logInInBackgroundWithAccessToken(token, block: {(user: PFUser?, error: NSError?) -> Void in
                                
                                if user != nil {
                                    
                                    let membership = user![PF_USER_MEMBERSHIP] as! String
                                    
                                    if membership == "Free" {
                                        
                                        self.defaults.setInteger(self.setNumberOfLivesFree, forKey: "Lives")
                                        
                                    }
                                    
                                    self.defaults.setObject(user![PF_USER_FIRST_NAME] as! String, forKey: "profileFirstName")
                                    self.defaults.setObject(user![PF_USER_SURNAME] as! String, forKey: "profileLastName")
                                    self.defaults.setObject(user![PF_USER_EMAILCOPY] as! String, forKey: "profileEmail")
                                    
                                    print(membership)
                                    self.defaults.setObject(membership, forKey: "Membership")
                                    
                                    SwiftSpinner.hide()
                                    self.userLoggedIn((user)!)
                                    
                                }else{
                                    
                                    self.getFBUserData(user!)
                                    
                                }
                                
                            })
                        }else{
                            //error handle if nothing happens when device change
                        }
                        
                    }
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
        careerPrefs[PF_PREFERENCES_CAREERPREFS] = self.loginViewModel.getAppVariables("careerTypes") as! [String]
        careerPrefs[PF_PREFERENCES_USERNAME] = user[PF_USER_USERNAME]
        
        careerPrefs.saveInBackgroundWithBlock({ (succeeded, error: NSError?) -> Void in
            if error == nil {
                
                SwiftSpinner.hide()
                self.firstTimeUser = true
                self.userLoggedIn(user)
                
            } else {
                
                SwiftSpinner.show("Login Error CCP1", animated: false).addTapHandler({
                    
                    SwiftSpinner.hide()
                    
                    }, subtitle: "Please try again. Tap to dismiss")
                
            }
        })
      
    }
    
    //---------------------------------------------------------------
    // USER LOGGED IN
    //---------------------------------------------------------------
  
  func userLoggedIn(user: PFUser) {
    //let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if self.firstTimeUser {
      
      //self.loginViewModel.updateQuestions()
      
      performSegueWithIdentifier("showTutorial", sender: self)
    }
    else {
      performSegueWithIdentifier("userLoggedOn", sender: self)
    }
    //let homeVC = storyboard.instantiateViewControllerWithIdentifier("homeVC") as! HomeViewController
    //presentViewController(homeVC, animated: false, completion: nil)
    //self.noticeTop("Welcome \(user[PF_USER_FULLNAME])!", autoClear: true, autoClearTime: 4)
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
    
    self.loginViewHeightConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.buttonHeight + (self.minorMargin * 3))
    
    let loginViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let loginViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.loginViewBottomConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.buttonHeight + (self.minorMargin * 3))
    
    self.loginView.addConstraint(self.loginViewHeightConstraint)
    self.view.addConstraints([loginViewLeftConstraint, loginViewRightConstraint, self.loginViewBottomConstraint])
    
    // Create and add constraints for facebookLoginButton
    
    self.facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
    
    let facebookLoginButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.buttonHeight)
    
    let facebookLoginButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let facebookLoginButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let facebookLoginButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.loginView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    self.facebookLoginButton.addConstraint(facebookLoginButtonHeightConstraint)
    self.view.addConstraints([facebookLoginButtonLeftConstraint, facebookLoginButtonRightConstraint, facebookLoginButtonBottomConstraint])
    
    // Create and add constraints for sloganImageView
    
    self.sloganImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let sloganImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let sloganImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.profilePictureImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let sloganImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let sloganImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.sloganImageView.addConstraints([sloganImageViewHeightConstraint, sloganImageViewWidthConstraint])
    self.view.addConstraints([sloganImageViewCenterXConstraint, sloganImageViewTopConstraint])
    
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