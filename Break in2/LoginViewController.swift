//
//  LoginViewController.swift
//  Break in2
//
//  Created by Jonathan Crawford on 08/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

// STEP 0: GLOBAL VARIABLES
// STEP 1: VIEW DID LOAD


import UIKit
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit
import CoreData
import SwiftSpinner
import SCLAlertView
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController, UIScrollViewDelegate {

//---------------------------------------------------------------
// STEP 0: GLOBAL VARIABLES
//---------------------------------------------------------------
    
    // Set up Firebase for read / write access
    var ref: DatabaseReference!
    
    // Declare and initialize types of tests and difficulties available for selected career
    
    let loginViewModel:JSONModel = JSONModel()
    
    // Set number of lives
    
    var setNumberOfLivesFree:Int = 3
    
    // Declare and initialize views
    
    let logoImageView:UILabel = UILabel()
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
    
    let defaults = UserDefaults.standard
    
    // Declare and initialize design constants
    
    let screenFrame:CGRect = UIScreen.main.bounds
    let statusBarFrame:CGRect = UIApplication.shared.statusBarFrame
    
    let majorMargin:CGFloat = 20
    let minorMargin:CGFloat = 10
    
    let borderWidth:CGFloat = 3
    
    let loginPageControllerViewHeight:CGFloat = 50
    var tutorialImageHeight:CGFloat = 150
    var buttonHeight:CGFloat = 50
    var textSize:CGFloat = 15

//---------------------------------------------------------------
// STEP 1: VIEW DID LOAD
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
        
        self.logoImageView.contentMode = UIViewContentMode.scaleAspectFit
        let labelString:String = String("BREAKIN2")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(26))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(26))!, range: NSRange(location: 5, length: NSString(string: labelString).length-5))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.logoImageView.attributedText = attributedString
        
        self.profilePictureImageView.contentMode = UIViewContentMode.scaleAspectFit
        self.profilePictureImageView.image = UIImage.init(named: "planeLogo")
        
        self.sloganImageView.contentMode = UIViewContentMode.scaleAspectFit
        self.sloganImageView.image = UIImage.init(named: "asSlogan")
        
        // Customize loginView and it's subviews
        
        self.loginView.layer.cornerRadius = self.minorMargin
        self.loginView.backgroundColor = UIColor.white
        
        self.facebookLoginButton.facebookButtonTitle = "Login With Facebook"
        self.facebookLoginButton.displayButton()
        
        // Add target for facebookLoginButton
        
        self.facebookLoginButton.addTarget(self, action: #selector(LoginViewController.hideLoginView), for: UIControlEvents.touchUpInside)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
        self.showLoginView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//---------------------------------------------------------------
// TAP FACEBOOK BUTTON
//---------------------------------------------------------------
    
    func buttonFBTapped(_ sender: AnyObject) {
        
        SwiftSpinner.show("Logging in...")
        
        self.ref = Database.database().reference()
        let fbLoginManager = FBSDKLoginManager()
        
        SwiftSpinner.hide()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            
            // Begin login process
            SwiftSpinner.show("Creating profile...")
            
            // Error handling
            if let error = error {
                
                SwiftSpinner.show("Login Error 1", animated: false).addTapHandler({
                    
                    SwiftSpinner.hide()
                    
                }, subtitle: "Please try again. Tap to dismiss")
                
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            // Get access token
            guard let accessToken = FBSDKAccessToken.current() else {
                
                SwiftSpinner.show("Login Error 2: Failed to get access token", animated: false).addTapHandler({
                    
                    SwiftSpinner.hide()
                    
                }, subtitle: "Please try again. Tap to dismiss")
                
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    
                    SwiftSpinner.show("Login Error 3", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                    }, subtitle: "Please try again. Tap to dismiss")
                    
                    print("Login error: \(error.localizedDescription)")
                    return
                }
                
                // Successful logon
                if let currentUser = Auth.auth().currentUser {
                
                    // Check if user exists
                    self.ref.child(FBASE_USER_ACTIVE_UIDS).child(currentUser.uid).observeSingleEvent(of: .value, with: {(userIdSnap) in
                        
                        if userIdSnap.exists(){
                            
                            self.firstTimeUser = false
                            SwiftSpinner.hide()
                            self.userLoggedIn()
                            
                        }else{
                            
                            self.firstTimeUser = true
                            
                            //create user profile
                            self.ref.child(FBASE_USER_NODE).child(currentUser.uid).setValue(
                                [FBASE_USER_FULLNAME: currentUser.displayName,
                                 FBASE_USER_EMAIL: currentUser.email,
                                 FBASE_USER_USERID: currentUser.uid,
                                 FBASE_USER_FREEMEMBERSHIP: true,
                                 FBASE_USER_NUMBER_LIVES: self.setNumberOfLivesFree
                                ])
                            
                            //create user preferences
                            self.ref.child(FBASE_PREFERENCES_NODE).child(currentUser.uid).setValue(
                                [FBASE_PREFERENCES_ACCOUNTING: true,
                                 FBASE_PREFERENCES_BANKING: true,
                                 FBASE_PREFERENCES_TRADING: true,
                                 FBASE_PREFERENCES_CONSULTING: true,
                                 FBASE_PREFERENCES_TECHNOLOGY: true,
                                 FBASE_PREFERENCES_ENGINEERING: true
                                ])
                            
                            self.defaults.set("Free", forKey: "Membership")
                            self.defaults.set(self.setNumberOfLivesFree, forKey: "Lives")
                            SwiftSpinner.hide()
                            self.userLoggedIn()
                            
                        }
                        
                    })

                }
                
            })
            
        }
    }
    

//---------------------------------------------------------------
// SHOW / HIDE LOGIN VIEWS
//---------------------------------------------------------------

    func showLoginView() {
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.loginViewBottomConstraint.constant = self.minorMargin
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }

    func hideLoginView() {
        
        UIView.animate(withDuration: 1, animations: {
            
            if self.loginTutorialViewVisible {
                
                self.loginViewHeightConstraint.constant = self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 2)
                self.loginScrollViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
                
                self.loginTutorialViewVisible = false
                
            }
            
        }, completion: {(Bool) in
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.loginViewBottomConstraint.constant = self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 3)
                self.view.layoutIfNeeded()
                
            }, completion: {(Bool) in
                
                self.buttonFBTapped(self.facebookLoginButton)
                
            })
            
        })
        
    }

//---------------------------------------------------------------
// USER LOGGED IN
//---------------------------------------------------------------
    
    func userLoggedIn() {
        
        if self.firstTimeUser {
            
            performSegue(withIdentifier: "showTutorial", sender: self)
            
        }else {
            
            performSegue(withIdentifier: "userLoggedOn", sender: self)
            
        }
        
    }
    
//---------------------------------------------------------------
// CONSTRAINTS
//---------------------------------------------------------------
    
func setConstraints() {
    
    // Create and add constraints for logoImageView
    
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    
    let logoImageViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.profilePictureImageView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.minorMargin * -1)
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
    self.view.addConstraints([logoImageViewCenterXConstraint, logoImageViewBottomConstraint])
    
    // Create and add constraints for profilePictureImageView
    
    self.profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let profilePictureImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    
    let profilePictureImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.profilePictureImageViewCenterYConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: (self.screenFrame.height - (self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 3)) + self.statusBarFrame.height)/2)
    
    let profilePictureImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.profilePictureImageView.addConstraints([profilePictureImageViewWidthConstraint, profilePictureImageViewHeightConstraint])
    self.view.addConstraints([profilePictureImageViewCenterXConstraint, self.profilePictureImageViewCenterYConstraint])
    
    // Create and add constraints for loginView
    
    self.loginView.translatesAutoresizingMaskIntoConstraints = false
    
    self.loginViewHeightConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.buttonHeight + (self.minorMargin * 3))
    
    let loginViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: self.majorMargin)
    
    let loginViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.loginViewBottomConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: self.buttonHeight + (self.minorMargin * 3))
    
    self.loginView.addConstraint(self.loginViewHeightConstraint)
    self.view.addConstraints([loginViewLeftConstraint, loginViewRightConstraint, self.loginViewBottomConstraint])
    
    // Create and add constraints for facebookLoginButton
    
    self.facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
    
    let facebookLoginButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.buttonHeight)
    
    let facebookLoginButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.loginView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: self.minorMargin)
    
    let facebookLoginButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.loginView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: self.minorMargin * -1)
    
    let facebookLoginButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLoginButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.loginView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    self.facebookLoginButton.addConstraint(facebookLoginButtonHeightConstraint)
    self.view.addConstraints([facebookLoginButtonLeftConstraint, facebookLoginButtonRightConstraint, facebookLoginButtonBottomConstraint])
    
    // Create and add constraints for sloganImageView
    
    self.sloganImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let sloganImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    
    let sloganImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.profilePictureImageView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    
    let sloganImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let sloganImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.sloganImageView.addConstraints([sloganImageViewHeightConstraint, sloganImageViewWidthConstraint])
    self.view.addConstraints([sloganImageViewCenterXConstraint, sloganImageViewTopConstraint])
    
}
}
