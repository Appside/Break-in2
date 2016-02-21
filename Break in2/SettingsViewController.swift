//
//  SettingsViewController.swift
//  Break in2
//
//  Created by Jonathan Crawford on 08/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4
import FBSDKCoreKit
import FBSDKLoginKit
import SCLAlertView
import CoreData
import SwiftSpinner
import MessageUI

/*
DIRECTORY

NUMBER 1: ACCOUNT STATUS

*/

class SettingsViewController: UIViewController, UIScrollViewDelegate, ChooseCareerViewDelegate, MFMailComposeViewControllerDelegate {
  
  let settingsModel:JSONModel = JSONModel()
  let defaults = NSUserDefaults.standardUserDefaults()
    
    //****************************************************************************************************
    //NUMBER 1: VARIABLES
    //****************************************************************************************************
    var showMembership:Bool = true
    let conduitView:UIView = UIView()
    let tutoView:UIView = UIView()
    let tutoDescription:UIScrollView = UIScrollView()
    let tutoDescriptionTitle:UILabel = UILabel()
    let tutoDescriptionText:UILabel = UILabel()
    let tutoDescriptionTitle2:UILabel = UILabel()
    let tutoDescriptionText2:UILabel = UILabel()
    let tutoNextButton:UIButton = UIButton()
    let tutoSkipButton:UIButton = UIButton()
    let logoImageViewMembership:UILabel = UILabel()
    let tutorialFingerImageViewMembership:UIImageView = UIImageView()
    var tutoPage:Int = 0
    let tutoDescriptionSep:UIView = UIView()
    let tutoDescriptionSep2:UIView = UIView()
    let whiteBGView:UIView = UIView()
    let newTutoButton:UILabel = UILabel()
    //Screen size
    var widthRatio:CGFloat = CGFloat()
    var heightRatio:CGFloat = CGFloat()
  
  // Declare and initialize types of settings
  
  var settings:[String] = [String]()
  var careerTypes:[String] = [String]()
  var careerTypeImages:[String:String] = [String:String]()
  var chosenCareers:[String] = [String]()
  var careerColors:[String:UIColor] = [String:UIColor]()
  var tutorialViews:[UIView] = [UIView]()
  var tutorialDescriptions:[UIView:[String]] = [UIView:[String]]()
  
  // Declare and initialize views
  
  let logoImageView:UIImageView = UIImageView()
  let backButton:UIButton = UIButton()
  let settingsMenuView:UIView = UIView()
  let chooseCareersView:UIView = UIView()
  let facebookLogoutButton:FacebookButton = FacebookButton()
  let scrollInfoLabel:UILabel = UILabel()
  let settingsScrollView:UIScrollView = UIScrollView()
  var settingsButtons:[UIButton] = [UIButton]()
  let chooseCareersTitleView:ChooseCareerTitleView = ChooseCareerTitleView()
  let currentCareerLabel:UILabel = UILabel()
  let chooseCareersInfoLabel:UILabel = UILabel()
  let chooseCareersScrollView:UIScrollView = UIScrollView()
  var chooseCareerViews:[ChooseCareerView] = [ChooseCareerView]()
  let tutorialView:UIView = UIView()
  let tutorialNextButton:UIButton = UIButton()
  var descriptionLabelView:TutorialDescriptionView = TutorialDescriptionView()
  var tutorialFingerImageView:UIImageView = UIImageView()
  let noDataLabel:UIView = UIView()
  let noDataUILabel:UILabel = UILabel()
  let saveCareersChoicesButton:UIButton = UIButton()
  
  var settingsMenuViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint()
    
    let moc = DataController().managedObjectContext
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let borderWidth:CGFloat = 3
  
  var menuButtonHeight:CGFloat = 50
  let backButtonHeight:CGFloat = UIScreen.mainScreen().bounds.width/12
  var chooseCareersViewHeight:CGFloat = 300
  var chooseCareersInfoLabelHeight:CGFloat = 50
  var textSize:CGFloat = 15
  
  // Declare and initialize tracking variables
  
  var currentChooseCareersScrollViewPage:Int = 0
  var firstTimeUser:Bool = false
  var tutorialPageNumber:Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addHomeBG()
    self.textSize = self.view.getTextSize(15)
    
    //Screen size and constraints
    self.widthRatio = screenFrame.size.width / 414
    self.heightRatio = screenFrame.size.height / 736
    
    // Get app variables
    
    self.settings = self.settingsModel.getAppVariables("settings") as! [String]
    //self.chosenCareers = self.settingsModel.getAppVariables("chosenCareers") as! [String]
    let appColors:[UIColor] = self.settingsModel.getAppColors()
    for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
      self.careerColors.updateValue(appColors[index], forKey: self.careerTypes[index])
    }
    
    // Add subviews to the main view
    
    self.view.addSubview(self.logoImageView)
    self.view.addSubview(self.backButton)
    self.view.addSubview(self.settingsMenuView)
    self.view.addSubview(self.chooseCareersView)
    
    self.settingsMenuView.addSubview(self.scrollInfoLabel)
    self.settingsMenuView.addSubview(self.settingsScrollView)
    self.settingsMenuView.addSubview(self.saveCareersChoicesButton)
    
    self.chooseCareersView.addSubview(self.chooseCareersTitleView)
    self.chooseCareersView.addSubview(self.currentCareerLabel)
    self.chooseCareersView.addSubview(self.chooseCareersInfoLabel)
    self.chooseCareersView.addSubview(self.chooseCareersScrollView)
    
    self.view.addSubview(self.tutorialView)
    self.view.addSubview(self.tutorialNextButton)
    
    // Adjust backButton appearance
    
    self.backButton.setImage(UIImage.init(named: "back")!, forState: UIControlState.Normal)
    self.backButton.addTarget(self, action: "hideSettingsMenuView:", forControlEvents: UIControlEvents.TouchUpInside)
    self.backButton.clipsToBounds = true
    self.backButton.alpha = 0
    
    self.tutorialNextButton.backgroundColor = UIColor.turquoiseColor()
    self.tutorialNextButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: self.textSize)
    self.tutorialNextButton.setTitle("Back To Home Screen", forState: UIControlState.Normal)
    self.tutorialNextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    self.tutorialNextButton.alpha = 0
    self.tutorialNextButton.addTarget(self, action: "nextTutorialButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.tutorialView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.86)
    
    // Set tutorialView and tutorialNextButton alpha values
    
    if self.firstTimeUser {
      self.tutorialView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(1)
      self.tutorialNextButton.alpha = 1
    }
    else {
      self.tutorialView.alpha = 0
      self.tutorialNextButton.alpha = 0
    }

    // Customize and add content to imageViews
    
    self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
    
    // Customize settingMenuView, chooseCareersView and tutorialView
    
    self.settingsMenuView.backgroundColor = UIColor.whiteColor()
    self.settingsMenuView.layer.cornerRadius = self.minorMargin
    self.settingsMenuView.alpha = 0
    
    self.chooseCareersView.backgroundColor = UIColor.whiteColor()
    self.chooseCareersView.layer.cornerRadius = self.minorMargin
    self.chooseCareersView.clipsToBounds = true
    self.chooseCareersView.alpha = 0
    
    // Customize facebookLogoutButton and saveCareersChoicesButton
    
    self.facebookLogoutButton.facebookButtonTitle = "Deactivate"
    self.facebookLogoutButton.displayButton()
    self.facebookLogoutButton.addTarget(self, action: "deactivateFB:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.saveCareersChoicesButton.backgroundColor = UIColor.turquoiseColor()
    self.saveCareersChoicesButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: self.textSize)
    self.saveCareersChoicesButton.setTitle("Save Career Preferences", forState: UIControlState.Normal)
    self.saveCareersChoicesButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    self.saveCareersChoicesButton.addTarget(self, action: "hideSettingsMenuView:", forControlEvents: UIControlEvents.TouchUpInside)
    
    // Customize scrollInfoLabel and chooseCareersInfoLabel
    
    self.scrollInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: self.textSize)
    self.scrollInfoLabel.textAlignment = NSTextAlignment.Center
    self.scrollInfoLabel.textColor = UIColor.lightGrayColor()
    self.scrollInfoLabel.text = "Scroll For More Settings"
    
    self.chooseCareersInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: self.textSize)
    self.chooseCareersInfoLabel.textAlignment = NSTextAlignment.Center
    self.chooseCareersInfoLabel.textColor = UIColor.lightGrayColor()
    self.chooseCareersInfoLabel.numberOfLines = 0
    self.chooseCareersInfoLabel.text = "Select The Careers You Are Interested In"
    
    // Customize settingsScrollView and chooseCareersScrollView
    
    self.settingsScrollView.showsVerticalScrollIndicator = false
    
    self.chooseCareersScrollView.pagingEnabled = true
    self.chooseCareersScrollView.showsHorizontalScrollIndicator = false
    self.chooseCareersScrollView.delegate = self
    
    //********************************************************************************
    // INITIATE THE CHOSEN CAREERS
    //********************************************************************************
    
    if (PFUser.currentUser() != nil) {
        self.loadUser()
    }
    else {
        self.view.loginUser(self)
    }
    
    // Customize chooseCareersTitleView and currentCareerLabel
    
    self.chooseCareersTitleView.careerSelectedLabel.text = self.careerTypes[0]
    self.chooseCareersTitleView.previousCareerButton.alpha = 0
    
    self.currentCareerLabel.backgroundColor = UIColor.turquoiseColor()
    self.currentCareerLabel.textAlignment = NSTextAlignment.Center
    self.currentCareerLabel.textColor = UIColor.whiteColor()
    self.currentCareerLabel.font = UIFont(name: "HelveticaNeue-Medium", size: self.textSize)
    
    // Create settingsButtons for each setting
    
    for var index:Int = 0 ; index < self.settings.count ; index++ {
      
      let settingsButtonAtIndex:CareerButton = CareerButton()
      
      // Set settingsButton properties
      
      settingsButtonAtIndex.careerTitle = self.settings[index]
      settingsButtonAtIndex.borderWidth = self.borderWidth
      
      // Call method to display careerButton content and add to settingsScrollView
      
      self.settingsScrollView.addSubview(settingsButtonAtIndex)
      settingsButtonAtIndex.displayButton()
      
      // Store each button in the careerButtons array
      
      self.settingsButtons.append(settingsButtonAtIndex)
      
      // Make each button perform a segue to the TestSelectionViewController
      
      settingsButtonAtIndex.addTarget(self, action: "hideSettingsMenuView:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    self.settingsScrollView.addSubview(self.facebookLogoutButton)
    self.settingsButtons.append(self.facebookLogoutButton)
    
    for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
      
      // Create each chooseCareerView
      
      let chooseCareerViewAtIndex:ChooseCareerView = ChooseCareerView()
      
      // Set delegate
      
      chooseCareerViewAtIndex.delegate = self
      
      // Set chooseCareerView properties
      
      chooseCareerViewAtIndex.careerImage = UIImage.init(named: self.careerTypeImages[self.careerTypes[index]]!)!
      chooseCareerViewAtIndex.careerColorView.backgroundColor = self.careerColors[self.careerTypes[index]]
      if self.chosenCareers.contains(self.careerTypes[index]) {
        chooseCareerViewAtIndex.careerChosen = true
      }
      
      chooseCareerViewAtIndex.majorMargin = self.majorMargin
      chooseCareerViewAtIndex.minorMargin = self.minorMargin
      
      let chooseCareersViewHeight = self.screenFrame.height - ((self.minorMargin * 7) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.statusBarFrame.height + self.backButtonHeight)
      chooseCareerViewAtIndex.height =  chooseCareersViewHeight - (self.chooseCareersInfoLabelHeight * 2)
      
      chooseCareerViewAtIndex.clipsToBounds = true
      
      // Call method to display chooseCareerView
      
      //chooseCareerViewAtIndex.displayView()
      
      // Add each chooseCareerView to chooseCareersScrollView
      
      self.chooseCareersScrollView.addSubview(chooseCareerViewAtIndex)
      
      // Store each chooseCareerView into the chooseCareerViews array
      
      self.chooseCareerViews.append(chooseCareerViewAtIndex)
      
    }
    
    // Set menuButtonHeight, backButtonHeight and chooseCareersViewHeight
    
    if self.screenFrame.height <= 738 {
      self.chooseCareersViewHeight = self.screenFrame.width - (self.majorMargin * 4)
      
      let careerBackgroundViewHeight:CGFloat = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.chooseCareersViewHeight + self.minorMargin)
      self.menuButtonHeight = (careerBackgroundViewHeight - ((self.minorMargin * 6) + 25))/4
      
    }
    else {
      self.chooseCareersViewHeight = self.screenFrame.width - (self.majorMargin * 14)
      
      let careerBackgroundViewHeight:CGFloat = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.chooseCareersViewHeight + self.minorMargin)
      self.menuButtonHeight = (careerBackgroundViewHeight - ((self.minorMargin * 7) + 25))/5
    }

    // Set constraints
    
    self.setConstraints()
    
    // Display chosseCareersTitleView
    
    self.chooseCareersTitleView.displayView()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    self.showSettingsMenuView()
    
    // Show tutorial to first time users
    
    if self.firstTimeUser {
      self.tutorialViews.appendContentsOf([self.chooseCareersView, self.backButton])
      self.tutorialDescriptions.updateValue(["CHOOSE CAREERS", "This is where you can select the careers that are most appropriate to you. Have a go now! Pressing the Back arrow will save your changes.\n\nYou can return to the Settings page at any time to change your choices."], forKey: self.chooseCareersView)
      self.showTutorial()
    }
  }

    //********************************************************************************
    // DEACTIVATE FBOOK
    //********************************************************************************
    
    
  @IBAction func deleteFBTapped(sender: AnyObject) {
    
    SwiftSpinner.show("Deactivating account", animated: true)
    
    let facebookRequest: FBSDKGraphRequest! = FBSDKGraphRequest(graphPath: "/me/permissions", parameters: nil, HTTPMethod: "DELETE")
    
    facebookRequest.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
      
      if(error == nil && result != nil){
        
        let user = PFUser.currentUser()!
        ParseExtensions.deleteUserFB(user)
        
        //self.deleteFromCoreData()
        let date:NSDate = NSDate()
        self.saveToCoreData("", p: [], dP: [], aI: "", uI: "", ex: date, r: date)
        self.view.loginUser(self)
        SwiftSpinner.hide()
        
      } else {
        if let error: NSError = error {
          if let errorString = error.userInfo["error"] as? String {
            self.noticeOnlyText("Please try again \(errorString)")
          }
        } else {
          self.noticeOnlyText("Please try again")
        }
      }
    }
    
  }
    
    func deleteFromCoreData() {
    
        let PersonFetch = NSFetchRequest(entityName: "Person")
        PersonFetch.returnsObjectsAsFaults = false
        
        do {
            let details = try moc.executeFetchRequest(PersonFetch)
            
            if details.count > 0 {
                
                for item in details as! [NSManagedObject] {
                    
                    let itemData:NSManagedObject = item 
                    moc.deleteObject(itemData)
                    
                }
                
            }else{
                //do nothing
            }
            
        }catch{
            
            let coreDataError = SCLAlertView()
            coreDataError.showError("Local Save Error", subTitle: "Try Again")
            
        }
        
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
  
    func loadUser() {
        
        //    let currentUser = PFUser.currentUser()!
        //    let username = currentUser.username
        //    let query = PFQuery(className: PF_PREFERENCES_CLASS_NAME)
        //    //query.whereKey(PF_PREFERENCES_USERNAME, equalTo: currentUser.username!)
        //    query.includeKey()
        //
        //    query.findObjectsInBackgroundWithBlock{(objects:[PFObject]?, error:NSError?) -> Void in
        //
        //        if error == nil {
        //
        ////            for singleObject in objects! {
        ////                if let stringData = singleObject[PF_PREFERENCES_CAREERPREFS] as? String {
        ////                    self.chosenCareers.append(stringData)
        ////                }
        ////            }
        //
        //            for singleObject in objects! {
        //                if let stringData = singleObject["careerPrefs"]{
        //                    self.chosenCareers = stringData as! [String]
        //                    //parseObjecsArrary.append(stringData as! PFObject)
        //                }
        //            }
        //        //self.chosenCareers = objects?[PF_USER_CAREERPREFS] //as! [String]
        //
        //        }
        //
        //
        //    }
        
        self.chooseCareersView.addSubview(self.noDataLabel)
        
        self.noDataLabel.setConstraintsToSuperview(Int(self.minorMargin), bottom: Int(self.minorMargin), left: Int(self.minorMargin), right: Int(self.minorMargin))
        self.noDataLabel.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
        self.noDataLabel.addSubview(self.noDataUILabel)
        self.noDataUILabel.setConstraintsToSuperview(25, bottom: 10, left: 5, right: 5)
        self.noDataUILabel.text = "Loading..."
        self.noDataUILabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        let textSize2:CGFloat = self.view.getTextSize(14)
        self.noDataUILabel.font = UIFont(name: "HelveticaNeue-Medium", size: textSize2)
        self.noDataUILabel.textAlignment = NSTextAlignment.Center
        self.noDataUILabel.numberOfLines = 0
        //self.noDataLabel.alpha = 0
        self.noDataLabel.alpha = 1.0
        
        let query = PFQuery(className: PF_PREFERENCES_CLASS_NAME)
        let currentUser = PFUser.currentUser()!
        let username = currentUser.username
        //let usernameString = username as! String
        query.whereKey(PF_PREFERENCES_USERNAME, equalTo: username!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                self.noDataLabel.alpha = 0
                self.noDataUILabel.alpha = 0
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.chosenCareers = object[PF_PREFERENCES_CAREERPREFS] as! [String]
                        print(self.chosenCareers)
                        for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
                            
                            if self.chosenCareers.contains(self.careerTypes[index]) {
                                self.chooseCareerViews[index].careerChosen = true
                            }
                          
                          self.chooseCareerViews[index].displayView()
                          
                        }
                      
                      if self.chosenCareers.contains(self.careerTypes[0]) {
                        self.currentCareerLabel.text = "Career Selected"
                      }
                      else {
                        self.currentCareerLabel.text = "Career Unselected"
                      }
                        
                    }
                }
            } else {
                // Log details of the failure
                self.noDataUILabel.text = "Connection Error"
            }
        }
        
        
        
    }
    
    func savePrefsToParse(sender:UIButton){
        
        SwiftSpinner.show("Saving career preferences")
        let currentUser = PFUser.currentUser()!
        //let objID = currentUser.objectId
        let username = currentUser.username
        let query = PFQuery(className: PF_PREFERENCES_CLASS_NAME)
        query.whereKey(PF_PREFERENCES_USERNAME, equalTo: username!)
        //query.getObjectInBackgroundWithId(objID!)
        query.getFirstObjectInBackgroundWithBlock({ (user: PFObject?, error: NSError?) -> Void in
            
            if error == nil {
                
                user![PF_PREFERENCES_CAREERPREFS] = self.chosenCareers
                user?.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                    if error == nil {
                        
                        self.defaults.setObject(self.chosenCareers, forKey: "SavedCareerPreferences")
                        let array = self.defaults.objectForKey("SavedCareerPreferences") as? [String] ?? [String]()
                        
                        SwiftSpinner.show("Career Preferences Saved", animated: false).addTapHandler({
                            
                        print(array)
                        SwiftSpinner.hide()
                        //self.hideSettingsMenuView(sender)
                            
                        }, subtitle: "Tap to return to settings")
                        
                    } else {
                        
                        SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                            
                            SwiftSpinner.hide()
                            //self.hideSettingsMenuView(sender)
                            
                            }, subtitle: "Preferences unsaved, tap to return to settings")
                        
                    }
                    
                })
                
            }else{
                
                SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                    
                    SwiftSpinner.hide()
                    //self.hideSettingsMenuView(sender)
                    
                    }, subtitle: "Preferences unsaved, to return to settings")
                
            }
        })
        
//        SwiftSpinner.show("Saving career preferences")
//        
//        var query = PFQuery(className: PF_PREFERENCES_CLASS_NAME)
//        let currentUser = PFUser.currentUser()!
//        let username = currentUser.username
//        //let usernameString = username as! String
//        query.whereKey(PF_PREFERENCES_USERNAME, equalTo: username!)
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) scores.")
//                // Do something with the found objects
//                if let objects = objects {
//                    for object in objects {
//                        
//                        object[PF_PREFERENCES_CAREERPREFS] = self.chosenCareers
//                        //self.chosenCareers = object[PF_PREFERENCES_CAREERPREFS] as! [String]
//                        print(self.chosenCareers)
//                        SwiftSpinner.hide()
//                        self.hideSettingsMenuView(sender)
//    
//                    }
//                }
//            } else {
//                // Log details of the failure
//                let saveError = SCLAlertView()
//                saveError.showError("Error", subTitle: "Try again")
//            }
//        }

        
        
    }
    
    func savePrefsToParse2(sender:UIButton){
        
        SwiftSpinner.show("Saving career preferences")
        
        let user = PFUser.currentUser()
        let careerPrefs = PFObject(className: PF_PREFERENCES_CLASS_NAME)
        careerPrefs[PF_PREFERENCES_USER] = user!
        careerPrefs[PF_PREFERENCES_CAREERPREFS] = self.chosenCareers
        
        careerPrefs.saveInBackgroundWithBlock({ (succeeded, error: NSError?) -> Void in
            if error == nil {
                
                SwiftSpinner.hide()
                self.hideSettingsMenuView(sender)
                
            } else {
                
                SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                    
                    SwiftSpinner.hide()
                    self.hideSettingsMenuView(sender)
                    
                    }, subtitle: "Preferences unsaved, tap to return home")
                
            }
        })
        
    }


  
  func setConstraints() {
    
    // Create and add constraints for logoImageView
    
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let logoImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
    self.view.addConstraints([logoImageViewCenterXConstraint, logoImageViewTopConstraint])
    
    // Create and add constraints for backButton
    
    self.backButton.translatesAutoresizingMaskIntoConstraints = false
    
    let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
    self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
    
    // Create and add constraints for settingsMenuView
    
    self.settingsMenuView.translatesAutoresizingMaskIntoConstraints = false
    
    let settingsMenuViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.chooseCareersViewHeight + self.minorMargin) + self.minorMargin)
    
    let settingsMenuViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let settingsMenuViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.settingsMenuViewTopConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.chooseCareersViewHeight + self.minorMargin)
    
    self.settingsMenuView.addConstraint(settingsMenuViewHeightConstraint)
    self.view.addConstraints([settingsMenuViewRightConstraint, settingsMenuViewLeftConstraint, self.settingsMenuViewTopConstraint])
    
    // Create and add constraints for chooseCareersView
    
    self.chooseCareersView.translatesAutoresizingMaskIntoConstraints = false
    
    let chooseCareersViewTopConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.backButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin)
    
    let chooseCareersViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let chooseCareersViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let chooseCareersViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.chooseCareersViewHeight)
    
    self.chooseCareersView.addConstraint(chooseCareersViewHeightConstraint)
    self.view.addConstraints([chooseCareersViewTopConstraint, chooseCareersViewLeftConstraint, chooseCareersViewRightConstraint])
    
    // Create and add constraints for saveCareersChoicesButton
    
    self.saveCareersChoicesButton.translatesAutoresizingMaskIntoConstraints = false
    
    let saveCareersChoicesButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveCareersChoicesButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
    
    let saveCareersChoicesButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveCareersChoicesButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let saveCareersChoicesButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveCareersChoicesButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let saveCareersChoicesButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveCareersChoicesButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    self.saveCareersChoicesButton.addConstraint(saveCareersChoicesButtonHeightConstraint)
    self.view.addConstraints([saveCareersChoicesButtonLeftConstraint, saveCareersChoicesButtonRightConstraint, saveCareersChoicesButtonBottomConstraint])
    
    // Create and add constraints for scrollInfoLabel
    
    self.scrollInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let scrollInfoLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let scrollInfoLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
    self.scrollInfoLabel.addConstraint(scrollInfoLabelHeightConstraint)
    self.view.addConstraints([scrollInfoLabelLeftConstraint, scrollInfoLabelTopConstraint, scrollInfoLabelRightConstraint])
    
    // Create and add constraints for settingsScrollView
    
    self.settingsScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let settingsScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let settingsScrollViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.saveCareersChoicesButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    
    let settingsScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let settingsScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    self.view.addConstraints([settingsScrollViewLeftConstraint, settingsScrollViewBottomConstraint, settingsScrollViewRightConstraint, settingsScrollViewTopConstraint])
    
    // Create and add constraints for each settingsButton and set content size for settingsScrollView
    
    for var index:Int = 0 ; index < self.settingsButtons.count ; index++ {
      
      self.settingsButtons[index].translatesAutoresizingMaskIntoConstraints = false
      
      let settingsButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
      
      let settingsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
      
      let settingsButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (2 * (self.majorMargin + self.minorMargin)))
      
      if index == 0 {
        
        let settingsButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        self.view.addConstraint(settingsButtonTopConstraint)
        
      }
      else {
        
        let settingsButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsButtons[index - 1], attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
        
        self.view.addConstraint(settingsButtonTopConstraint)
        
      }
      
      self.settingsButtons[index].addConstraints([settingsButtonWidthConstraint, settingsButtonHeightConstraint])
      self.view.addConstraint(settingsButtonLeftConstraint)
      
      if index == self.settingsButtons.count - 1 {
        
        let settingsButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsScrollView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraint(settingsButtonBottomConstraint)
        
      }
      
    }
    
    // Create and add constraints for chooseCareersTitleView
    
    self.chooseCareersTitleView.translatesAutoresizingMaskIntoConstraints = false
    
    let chooseCareersTitleViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersTitleView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let chooseCareersTitleViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersTitleView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let chooseCareersTitleViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersTitleView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let chooseCareersTitleViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersTitleView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: ((self.screenFrame.height - (self.statusBarFrame.height + (self.minorMargin * 9) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.backButtonHeight)) * 2)/9)
    
    self.chooseCareersTitleView.addConstraint(chooseCareersTitleViewHeightConstraint)
    self.view.addConstraints([chooseCareersTitleViewTopConstraint, chooseCareersTitleViewLeftConstraint, chooseCareersTitleViewRightConstraint])
    
    // Create and add constraints for currentCareerLabel
    
    self.currentCareerLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let currentCareerLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.currentCareerLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersTitleView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let currentCareerLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.currentCareerLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let currentCareerLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.currentCareerLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let currentCareerLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.currentCareerLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.screenFrame.height - (self.statusBarFrame.height + (self.minorMargin * 9) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.backButtonHeight))/9)
    
    self.currentCareerLabel.addConstraint(currentCareerLabelHeightConstraint)
    self.view.addConstraints([currentCareerLabelTopConstraint, currentCareerLabelLeftConstraint, currentCareerLabelRightConstraint])
    
    // Create and add constraints for chooseCareersInfoLabel
    
    self.chooseCareersInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let chooseCareersInfoLabelBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersInfoLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let chooseCareersInfoLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersInfoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let chooseCareersInfoLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersInfoLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let chooseCareersInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.chooseCareersInfoLabelHeight)
    
    self.chooseCareersInfoLabel.addConstraint(chooseCareersInfoLabelHeightConstraint)
    self.view.addConstraints([chooseCareersInfoLabelBottomConstraint, chooseCareersInfoLabelLeftConstraint, chooseCareersInfoLabelRightConstraint])
    
    // Create and add constraints for chooseCareersScrollView
    
    self.chooseCareersScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let chooseCareersScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let chooseCareersScrollViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersInfoLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let chooseCareersScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let chooseCareersScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.currentCareerLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    self.view.addConstraints([chooseCareersScrollViewLeftConstraint, chooseCareersScrollViewBottomConstraint, chooseCareersScrollViewRightConstraint, chooseCareersScrollViewTopConstraint])
    
    // Create and add constraints for each chooseCareerView and set content size for chooseCareersScrollView
    
    for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
      
      self.chooseCareerViews[index].translatesAutoresizingMaskIntoConstraints = false
      
      let chooseCareerViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
      
      let chooseCareerViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersInfoLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
      
      let chooseCareerViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (2 * self.majorMargin))
      
      if index == 0 {
        
        let chooseCareerViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.view.addConstraint(chooseCareerViewLeftConstraint)
        
      }
      else {
        
        let chooseCareerViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareerViews[index - 1], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.view.addConstraint(chooseCareerViewLeftConstraint)
        
      }
      
      self.chooseCareerViews[index].addConstraint(chooseCareerViewWidthConstraint)
      self.view.addConstraints([chooseCareerViewTopConstraint, chooseCareerViewBottomConstraint])
      
      if index == self.chooseCareerViews.count - 1 {
        
        let chooseCareersScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.view.addConstraint(chooseCareersScrollViewRightConstraint)
        
      }
      
    }
    
    // Create and add constraints for tutorialView
    
    self.tutorialView.translatesAutoresizingMaskIntoConstraints = false
    
    let tutorialViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let tutorialViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let tutorialViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.height)
    
    let tutorialViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width)
    
    self.tutorialView.addConstraints([tutorialViewHeightConstraint, tutorialViewWidthConstraint])
    self.view.addConstraints([tutorialViewLeftConstraint, tutorialViewTopConstraint])
    
    // Create and add constraints for tutorialNextButton
    
    self.tutorialNextButton.translatesAutoresizingMaskIntoConstraints = false
    
    let tutorialNextButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: (self.minorMargin + self.majorMargin) * -1)
    
    let tutorialNextButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin * -1)
    
    let tutorialNextButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin + self.majorMargin)
    
    let tutorialNextButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
    
    self.tutorialNextButton.addConstraint(tutorialNextButtonHeightConstraint)
    self.view.addConstraints([tutorialNextButtonLeftConstraint, tutorialNextButtonBottomConstraint, tutorialNextButtonRightConstraint])

  }
  
  func showSettingsMenuView() {
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      self.backButton.alpha = 1
      self.settingsMenuView.alpha = 1
      //self.settingsMenuViewTopConstraint.constant = self.screenFrame.height - ((self.minorMargin * 7) + (self.menuButtonHeight * 4.5)) + self.minorMargin
      self.chooseCareersView.alpha = 1
      self.view.layoutIfNeeded()
      
      }, completion: nil)
    
  }
    
    func deactivateFB(sender:UIButton){
        
        if sender == self.facebookLogoutButton {
            
            let alertView = SCLAlertView()
            
            alertView.addButton("Ok", target:self, selector:Selector("conduit"))
            alertView.showTitle(
                "Deactivate", // Title of view
                subTitle: "Are You Sure? Deactivation will delete all of your statistics, preferences and user data.", // String of view
                duration: 0.0, // Duration to show before closing automatically, default: 0.0
                completeText: "Cancel", // Optional button value, default: ""
                style: .Notice, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
                colorStyle: 0x526B7B,//0xD0021B - RED
                colorTextButton: 0xFFFFFF
            )
            alertView.showCloseButton = false
            
        }else{
            
        }
        
    }

  func hideSettingsMenuView(sender:UIButton) {
    
    if sender.currentTitle == "Contact Us" {
        
        self.sendEmailButtonTapped(sender)
        
    }else if sender.currentTitle == "About" {
        
      UIApplication.sharedApplication().openURL(NSURL(string: "http://www.appside.co.uk")!)
        
    }else if sender.currentTitle == "Refresh Job Deadlines" {
      
      self.settingsModel.downloadAndSaveJobDeadlines()
      
    }else if sender.currentTitle == "Update Questions" {
      
      self.settingsModel.downloadAndSaveQuestions()
      
    }else if sender.currentTitle == "Account Status" {
        
        //****************************************************************************************************
        //NUMBER 1B: ACCOUNT STATUS CLICK
        //****************************************************************************************************
        
        print("account status")
        self.tutoView.alpha = 1
        self.membershipTypeClicked()
        
    }else if sender == self.saveCareersChoicesButton {
        
      print("save choices")
        self.savePrefsToParse(sender)
        
    }else{
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
      
      self.chooseCareersView.alpha = 0
      self.backButton.alpha = 0
      self.settingsMenuView.alpha = 0
      //self.settingsMenuViewTopConstraint.constant = self.screenFrame.height
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        if sender == self.backButton {
          self.performSegueWithIdentifier("backFromEditProfile", sender: self.backButton)
        }
        else if sender == self.tutorialNextButton {
          self.performSegueWithIdentifier("backFromEditProfile", sender: self.tutorialNextButton)
        }
        else if sender.currentTitle == "Show Walkthrough" {
          self.performSegueWithIdentifier("showTutorialFromSettings", sender: self.settingsButtons[0])
        }
        else if sender == self.facebookLogoutButton {
            
            self.deleteFBTapped(self.facebookLogoutButton)
    
        }
        
    })
    }
    
  }
    
    
    
    func conduit(){
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.chooseCareersView.alpha = 0
            self.backButton.alpha = 0
            self.settingsMenuView.alpha = 0
            //self.settingsMenuViewTopConstraint.constant = self.screenFrame.height
            self.view.layoutIfNeeded()
            
            }, completion: {(Bool) in
        
        self.deleteFBTapped(self.facebookLogoutButton)
        
                })
    }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "backFromEditProfile" {
      let destinationVC:HomeViewController = segue.destinationViewController as! HomeViewController
      destinationVC.segueFromLoginView = false
      if sender as! UIButton == self.tutorialNextButton {
        destinationVC.firstTimeUser = true
        destinationVC.tutorialPageNumber = 3
      }
    }
    
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
    self.currentChooseCareersScrollViewPage = Int(self.chooseCareersScrollView.contentOffset.x / self.chooseCareersScrollView.frame.size.width)
    self.chooseCareersTitleView.careerSelectedLabel.text = self.careerTypes[self.currentChooseCareersScrollViewPage]
    
    if self.chosenCareers.contains(self.careerTypes[self.currentChooseCareersScrollViewPage]) {
      self.currentCareerLabel.text = "Career Selected"
    }
    else {
      self.currentCareerLabel.text = "Career Unselected"
    }
    
    if self.currentChooseCareersScrollViewPage == 0 {
      self.chooseCareersTitleView.previousCareerButton.alpha = 0
    }
    else if self.currentChooseCareersScrollViewPage == self.careerTypes.count - 1 {
      self.chooseCareersTitleView.nextCareerButton.alpha = 0
    }
    else {
      self.chooseCareersTitleView.previousCareerButton.alpha = 1
      self.chooseCareersTitleView.nextCareerButton.alpha = 1
    }
  }
  
  func appendChosenCareer() {
    
    self.chosenCareers.append(self.chooseCareersTitleView.careerSelectedLabel.text!)
    self.currentCareerLabel.text = "Career Selected"

  }
  
  func removeChosenCareer() {
    
    self.chosenCareers.removeAtIndex(self.chosenCareers.indexOf(self.chooseCareersTitleView.careerSelectedLabel.text!)!)
    self.currentCareerLabel.text = "Career Unselected"

  }
  
  func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    self.scrollViewDidEndDecelerating(scrollView)
  }
  
  func nextCareerButtonClicked(sender:UIButton) {
    
    if self.currentChooseCareersScrollViewPage < self.careerTypes.count - 1 {
      let nextCareerView:ChooseCareerView = self.chooseCareerViews[self.currentChooseCareersScrollViewPage + 1]
      self.chooseCareersScrollView.setContentOffset(nextCareerView.frame.origin, animated: true)
    }
    
  }
  
  func previousCareerButtonClicked(sender:UIButton) {
    
    if self.currentChooseCareersScrollViewPage > 0 {
      let previousCareerView:ChooseCareerView = self.chooseCareerViews[self.currentChooseCareersScrollViewPage - 1]
      self.chooseCareersScrollView.setContentOffset(previousCareerView.frame.origin, animated: true)
    }
    
  }
  
  func getChosenJobDeadlines() {
    
    let jobDeadlines:[[String:AnyObject]] = self.settingsModel.getJobDeadlines()
    var deadlines:[[String:AnyObject]] = [[String:AnyObject]]()
    
    for var index = 0 ; index < jobDeadlines.count ; index++ {
      if self.chosenCareers.contains(jobDeadlines[index]["career"] as! String) {
        deadlines.append(jobDeadlines[index])
      }
    }
      
  // ADD NOTIFICATIONS HERE
      
      
  }
  
  func showTutorial() {
    
    self.view.insertSubview(self.logoImageView, aboveSubview: self.tutorialView)
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      self.tutorialView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.86)
      self.tutorialNextButton.alpha = 1
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
          self.descriptionLabelView.alpha = 0
          }, completion: {(Bool) in
            self.descriptionLabelView.removeFromSuperview()
            for var index:Int = 0 ; index < self.tutorialViews.count ; index++ {
              if index == self.tutorialPageNumber {
                self.view.insertSubview(self.tutorialViews[index], belowSubview: self.tutorialNextButton)
                self.tutorialViews[index].userInteractionEnabled = true
              }
              else {
                self.view.insertSubview(self.tutorialViews[index], belowSubview: self.tutorialView)
                self.tutorialViews[index].userInteractionEnabled = false
              }
            }
            if self.tutorialViews[self.tutorialPageNumber] == self.chooseCareersView {
              self.view.insertSubview(self.backButton, belowSubview: self.tutorialNextButton)
              self.displayFinger(true)
              UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.tutorialFingerImageView.alpha = 1
                }, completion: nil)
            }
            self.updateDescriptionLabelView()
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
              self.descriptionLabelView.alpha = 1
              }, completion: nil)
            
        })
    })

}
  
  func nextTutorialButtonClicked(sender:UIButton) {
    
    self.tutorialPageNumber++
    
    if self.tutorialViews[self.tutorialPageNumber - 1] == self.chooseCareersView {
      self.savePrefsToParse(sender)
      self.hideSettingsMenuView(sender)
    }
    
  }
  
  func updateDescriptionLabelView () {
    
    // Create and add constraints for descriptionLabelView
    
    self.descriptionLabelView.titleLabel.text = self.tutorialDescriptions[self.tutorialViews[self.tutorialPageNumber]]![0]
    self.descriptionLabelView.descriptionLabel.text = self.tutorialDescriptions[self.tutorialViews[self.tutorialPageNumber]]![1]
    //self.descriptionLabelView.alpha = 0
    self.view.addSubview(self.descriptionLabelView)
    
    descriptionLabelView.translatesAutoresizingMaskIntoConstraints = false
    
    let descriptionLabelViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    if self.tutorialViews[self.tutorialPageNumber].frame.maxY < (self.screenFrame.height) {
      let descriptionLabelViewTopConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutorialViews[self.tutorialPageNumber], attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
      self.view.addConstraint(descriptionLabelViewTopConstraint)
    }
    else {
      let descriptionLabelViewBottomConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tutorialViews[self.tutorialPageNumber], attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -20)
      self.view.addConstraint(descriptionLabelViewBottomConstraint)
    }
    
    let descriptionLabelViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.descriptionLabelView.heightForView(self.descriptionLabelView.descriptionLabel.text!, font: self.descriptionLabelView.descriptionLabel.font, width: self.screenFrame.width - (self.majorMargin * 2)) + 60)
    
    let descriptionLabelViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (self.majorMargin * 2))
    
    self.descriptionLabelView.addConstraints([descriptionLabelViewHeightConstraint, descriptionLabelViewWidthConstraint])
    self.view.addConstraints([descriptionLabelViewCenterXConstraint])
  }
  
  func displayFinger(pointingLeft:Bool) {
    
    self.tutorialFingerImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.tutorialFingerImageView.alpha = 0
    self.view.addSubview(self.tutorialFingerImageView)
    
    tutorialFingerImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let tutorialFingerImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    if pointingLeft {
      self.tutorialFingerImageView.image = UIImage.init(named: "fingerSideways")
      let tutorialFingerImageViewLeftConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.backButton, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
      self.view.addConstraint(tutorialFingerImageViewLeftConstraint)
    }
    else {
      let image:UIImage = UIImage.init(named: "fingerSideways")!
      self.tutorialFingerImageView.image = UIImage.init(CGImage: image.CGImage!, scale: image.scale, orientation: UIImageOrientation.UpMirrored)
      let tutorialFingerImageViewRightConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.backButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
      self.view.addConstraint(tutorialFingerImageViewRightConstraint)
    }
    
    let tutorialFingerImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let tutorialFingerImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/6)
    
    self.tutorialFingerImageView.addConstraints([tutorialFingerImageViewHeightConstraint, tutorialFingerImageViewWidthConstraint])
    self.view.addConstraints([tutorialFingerImageViewTopConstraint])
    
  }

    func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            let emailError = SCLAlertView()
            emailError.showError("Could Not Send Email", subTitle: "Try Again")
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["team@appside.co.uk"])
        mailComposerVC.setSubject("Break In2 Feedback")
        //mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func membershipTypeClicked(){
        
        //****************************************************************************************************
        //NUMBER 1A: SETUP THE SCREEN
        //****************************************************************************************************
        
        //Set constraints to each view
        self.view.addSubview(self.tutoView)
        self.tutoView.addSubview(self.conduitView)
        self.tutoView.addSubview(self.tutoNextButton)
        self.tutoView.addSubview(self.tutoSkipButton)
        self.tutoView.addSubview(self.tutoDescription)
        self.tutoView.addSubview(self.logoImageViewMembership)
        self.tutoView.addSubview(self.tutorialFingerImageView)
        self.tutoDescription.addSubview(self.conduitView)
        self.conduitView.addSubview(self.tutoDescriptionTitle)
        self.conduitView.addSubview(self.tutoDescriptionText)
        self.conduitView.addSubview(self.tutoDescriptionTitle2)
        self.conduitView.addSubview(self.tutoDescriptionText2)
        self.conduitView.addSubview(self.tutoDescriptionSep)
        self.tutoDescriptionSep.backgroundColor = UIColor.whiteColor()
        self.conduitView.addSubview(self.tutoDescriptionSep2)
        self.tutoDescriptionSep2.backgroundColor = UIColor.whiteColor()
        
        self.tutoView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        
        //***************************
        //CONDUIT VIEW
        //***************************
        
        self.conduitView.translatesAutoresizingMaskIntoConstraints = false
        let conduitViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.conduitView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let conduitViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.conduitView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let conduitViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.conduitView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 300*self.heightRatio)
        let conduitViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.conduitView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.view.frame.width - 100*self.widthRatio))
        
        self.tutoDescription.addConstraints([conduitViewTop, conduitViewLeft])
        self.conduitView.addConstraints([conduitViewHeight, conduitViewWidth])
        
        //***************************
        //OUTER SCROLL VIEW: TUTO DES
        //***************************
        
        self.tutoDescription.translatesAutoresizingMaskIntoConstraints = false
        self.tutoDescription.contentSize = CGSize(width: (self.view.frame.width - 40*self.widthRatio), height: 500)
        let tutoDescriptionCenterY:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: (300/2-60)*self.heightRatio)
        let tutoDescriptionLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 50*self.widthRatio)
        let tutoDescriptionRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -50*self.widthRatio)
        
        self.tutoView.addConstraints([tutoDescriptionCenterY,tutoDescriptionLeft,tutoDescriptionRight])
        
        let tutoDescriptionHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 300*self.heightRatio)
        let tutoDescriptionWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.view.frame.width - 40*self.widthRatio))
        
        self.tutoDescription.addConstraints([tutoDescriptionHeight, tutoDescriptionWidth])
        self.tutoDescription.contentSize = CGSize(width: 300*self.heightRatio, height: self.view.frame.width - 40*self.widthRatio)
        
        //***************************
        //CLOSE BUTTON
        //***************************
        
        self.tutoNextButton.translatesAutoresizingMaskIntoConstraints = false
        let tutoNextButtonBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -10*self.heightRatio)
        let tutoNextButtonLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 40*self.widthRatio)
        let tutoNextButtonRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -40*self.widthRatio)
        self.tutoView.addConstraints([tutoNextButtonBottom,tutoNextButtonLeft,tutoNextButtonRight])
        let tutoNextButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.heightRatio)
        self.tutoNextButton.addConstraint(tutoNextButtonHeight)
        
        //***************************
        //MEMBERSHIP TYPE
        //***************************
        
        self.tutoSkipButton.translatesAutoresizingMaskIntoConstraints = false
        let tutoSkipButtonTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.view.frame.width/12+50*self.heightRatio)
        let tutoSkipButtonCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.tutoView.addConstraints([tutoSkipButtonTop,tutoSkipButtonCenterX])
        let tutoSkipButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20*self.heightRatio)
        let tutoSkipButtonWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 200*self.widthRatio)
        self.tutoSkipButton.addConstraints([tutoSkipButtonHeight,tutoSkipButtonWidth])
        
        //***************************
        //Top text
        //***************************
        
        self.tutoDescriptionTitle.translatesAutoresizingMaskIntoConstraints = false
        let tutoDescriptionTitleLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionTitle, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let tutoDescriptionTitleTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionTitle, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let tutoDescriptionTitleRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionTitle, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let tutoDescriptionTitleHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionTitle, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        self.conduitView.addConstraints([tutoDescriptionTitleTop, tutoDescriptionTitleLeft, tutoDescriptionTitleRight])
        self.tutoDescriptionTitle.addConstraints([tutoDescriptionTitleHeight])
        
        self.tutoDescriptionSep.translatesAutoresizingMaskIntoConstraints = false
        let tutoDescriptionSepLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionSep, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let tutoDescriptionSepTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionSep, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescriptionTitle, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let tutoDescriptionSepRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionSep, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let tutoDescriptionSepHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionSep, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 3)
        
        self.conduitView.addConstraints([tutoDescriptionSepLeft, tutoDescriptionSepRight, tutoDescriptionSepTop])
        self.tutoDescriptionSep.addConstraints([tutoDescriptionSepHeight])
        
        self.tutoDescriptionText.translatesAutoresizingMaskIntoConstraints = false
        let tutoDescriptionTextTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: tutoDescriptionSep, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let tutoDescriptionTextLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let tutoDescriptionTextRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.conduitView.addConstraints([tutoDescriptionTextTop,tutoDescriptionTextLeft,tutoDescriptionTextRight])
        
        //***************************
        //Bottom text
        //***************************
        
        self.tutoDescriptionTitle2.translatesAutoresizingMaskIntoConstraints = false
        let tutoDescriptionTitle2Left:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionTitle2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let tutoDescriptionTitle2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionTitle2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescriptionText, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let tutoDescriptionTitle2Right:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionTitle2, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let tutoDescriptionTitle2Height:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionTitle2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        self.conduitView.addConstraints([tutoDescriptionTitle2Top, tutoDescriptionTitle2Left, tutoDescriptionTitle2Right])
        self.tutoDescriptionTitle2.addConstraints([tutoDescriptionTitle2Height])
        
        self.tutoDescriptionSep2.translatesAutoresizingMaskIntoConstraints = false
        let tutoDescriptionSep2Left:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionSep2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let tutoDescriptionSep2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionSep2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescriptionTitle2, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let tutoDescriptionSep2Right:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionSep2, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let tutoDescriptionSep2Height:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionSep2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 3)
        
        self.conduitView.addConstraints([tutoDescriptionSep2Left, tutoDescriptionSep2Right, tutoDescriptionSep2Top])
        self.tutoDescriptionSep2.addConstraints([tutoDescriptionSep2Height])
        
        self.tutoDescriptionText2.translatesAutoresizingMaskIntoConstraints = false
        let tutoDescriptionText2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: tutoDescriptionSep2, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let tutoDescriptionText2Left:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let tutoDescriptionText2Right:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.conduitView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.conduitView.addConstraints([tutoDescriptionText2Top,tutoDescriptionText2Left,tutoDescriptionText2Right])
        

        self.logoImageViewMembership.translatesAutoresizingMaskIntoConstraints = false
        let logoImageViewCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageViewMembership, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let logoImageViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageViewMembership, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 25*self.heightRatio)
        let logoImageViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageViewMembership, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/12)
        let logoImageViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageViewMembership, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-40)
        self.logoImageViewMembership.addConstraints([logoImageViewHeight, logoImageViewWidth])
        self.tutoView.addConstraints([logoImageViewCenterX, logoImageViewTop])
        
        //Finger ImageView
        self.tutorialFingerImageView.image = UIImage.init(named: "fingbutton")
        self.tutorialFingerImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.tutorialFingerImageView.translatesAutoresizingMaskIntoConstraints = false
        let descriptionImageViewCenterX:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let descriptionImageViewCenterY:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -self.view.frame.width/8-100*self.heightRatio)
        let descriptionImageViewHeight:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/4)
        let descriptionImageViewWidth:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 10*self.widthRatio)
        self.tutorialFingerImageView.addConstraints([descriptionImageViewHeight, descriptionImageViewWidth])
        self.tutoView.addConstraints([descriptionImageViewCenterX, descriptionImageViewCenterY])
        
        //Tutorial Title
        let labelString:String = String("YOUR SUBSCRIPTION")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 5, length: NSString(string: labelString).length-5))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.logoImageViewMembership.attributedText = attributedString
        
        //Design
        self.logoImageViewMembership.textAlignment = NSTextAlignment.Center
        self.tutoView.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
        self.tutoDescriptionTitle.textColor = UIColor.whiteColor()
        self.tutoDescriptionTitle.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        self.tutoDescriptionTitle.textAlignment = NSTextAlignment.Justified
        self.tutoDescriptionTitle.numberOfLines = 0
        self.tutoDescriptionText.textColor = UIColor.whiteColor()
        self.tutoDescriptionText.font = UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(15))
        self.tutoDescriptionText.textAlignment = NSTextAlignment.Left
        self.tutoDescriptionText.numberOfLines = 0
        self.tutoDescriptionTitle2.textColor = UIColor.whiteColor()
        self.tutoDescriptionTitle2.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        self.tutoDescriptionTitle2.textAlignment = NSTextAlignment.Justified
        self.tutoDescriptionTitle2.numberOfLines = 0
        self.tutoDescriptionText2.textColor = UIColor.whiteColor()
        self.tutoDescriptionText2.font = UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(15))
        self.tutoDescriptionText2.textAlignment = NSTextAlignment.Left
        self.tutoDescriptionText2.numberOfLines = 0
        self.tutoNextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.tutoNextButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.tutoNextButton.setTitle("Close", forState: .Normal)
        self.tutoNextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        self.tutoNextButton.titleLabel?.textAlignment = NSTextAlignment.Center
        let tutoNextButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tutoNext"))
        self.tutoNextButton.addGestureRecognizer(tutoNextButtonTap)
        self.tutoSkipButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.tutoSkipButton.setTitle(self.defaults.objectForKey("Membership") as? String, forState: .Normal)
        self.tutoSkipButton.titleLabel?.font = UIFont(name: "HelveticaNeue-LightItalic", size: self.view.getTextSize(20))
        self.tutoSkipButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        //Set tutorial text
        self.tutoDescriptionTitle.text = "Free Subscription:"
        self.tutoDescriptionText.text = "We have provided full access to tests and the chance to win a prize through the Brain Breaker question. However, you are limited to 3 lives with which to take tests. We will give you a new life every 12 hours; but if you need lives more quickly, you can either purchase a set of 10 or upgrade to our Premium version."
        self.tutoDescriptionTitle2.text = "Premium Subscription:"
        self.tutoDescriptionText2.text = "Premium access allows you to practice tests with unlimited access. You are also granted 3 chances to win a prize through the Brain Breaker question."

        
    }
    
    func tutoNext(){
        
        self.tutoView.alpha = 0
        self.showMembership = false
        
    }
  
}
