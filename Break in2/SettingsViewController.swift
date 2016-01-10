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

class SettingsViewController: UIViewController, UIScrollViewDelegate, ChooseCareerViewDelegate {
  
  let settingsModel:JSONModel = JSONModel()
  let defaults = NSUserDefaults.standardUserDefaults()
  
  // Declare and initialize types of settings
  
  var settings:[String] = [String]()
  var careerTypes:[String] = [String]()
  var careerTypeImages:[String:String] = [String:String]()
  var chosenCareers:[String] = [String]()
  var careerColors:[String:UIColor] = [String:UIColor]()
  var tutorialViews:[UIView] = [UIView]()
  
  // Declare and initialize views
  
  let logoImageView:UIImageView = UIImageView()
  let backButton:UIButton = UIButton()
  let settingsMenuView:UIView = UIView()
  let chooseCareersView:UIView = UIView()
  let facebookLogoutButton:FacebookButton = FacebookButton()
  let scrollInfoLabel:UILabel = UILabel()
  let settingsScrollView:UIScrollView = UIScrollView()
  var settingsButtons:[CareerButton] = [CareerButton]()
  let chooseCareersTitleView:ChooseCareerTitleView = ChooseCareerTitleView()
  let currentCareerLabel:UILabel = UILabel()
  let chooseCareersInfoLabel:UILabel = UILabel()
  let chooseCareersScrollView:UIScrollView = UIScrollView()
  var chooseCareerViews:[ChooseCareerView] = [ChooseCareerView]()
  let tutorialView:UIView = UIView()
  let tutorialNextButton:UIButton = UIButton()
  
  var settingsMenuViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint()
    
    let moc = DataController().managedObjectContext
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let borderWidth:CGFloat = 3
  
  let menuButtonHeight:CGFloat = 50
  let backButtonHeight:CGFloat = UIScreen.mainScreen().bounds.width/12
  var chooseCareersInfoLabelHeight:CGFloat = 50
  
  // Declare and initialize tracking variables
  
  var currentChooseCareersScrollViewPage:Int = 0
  var firstTimeUser:Bool = false
  var tutorialPageNumber:Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addHomeBG()
    
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
    
    self.settingsMenuView.addSubview(self.facebookLogoutButton)
    self.settingsMenuView.addSubview(self.scrollInfoLabel)
    self.settingsMenuView.addSubview(self.settingsScrollView)
    
    self.chooseCareersView.addSubview(self.chooseCareersTitleView)
    self.chooseCareersView.addSubview(self.currentCareerLabel)
    self.chooseCareersView.addSubview(self.chooseCareersInfoLabel)
    self.chooseCareersView.addSubview(self.chooseCareersScrollView)
    
    self.view.addSubview(self.tutorialView)
    self.view.addSubview(self.tutorialNextButton)
    
    // Adjust backButton appearance
    
    self.backButton.setImage(UIImage.init(named: "back")!, forState: UIControlState.Normal)
    self.backButton.addTarget(self, action: "savePrefsToParse:", forControlEvents: UIControlEvents.TouchUpInside)
    self.backButton.clipsToBounds = true
    self.backButton.alpha = 0
    
    self.tutorialNextButton.backgroundColor = UIColor.turquoiseColor()
    self.tutorialNextButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    self.tutorialNextButton.setTitle("Next", forState: UIControlState.Normal)
    self.tutorialNextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    self.tutorialNextButton.alpha = 0
    self.tutorialNextButton.addTarget(self, action: "nextTutorialButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    
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
    
    self.tutorialView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.86)
    self.tutorialView.alpha = 0
    
    // Customize facebookLogoutButton
    
    self.facebookLogoutButton.facebookButtonTitle = "Deactivate"
    self.facebookLogoutButton.displayButton()
    self.facebookLogoutButton.addTarget(self, action: "deactivateFB:", forControlEvents: UIControlEvents.TouchUpInside)
    
    // Customize scrollInfoLabel and chooseCareersInfoLabel
    
    self.scrollInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: 15)
    self.scrollInfoLabel.textAlignment = NSTextAlignment.Center
    self.scrollInfoLabel.textColor = UIColor.lightGrayColor()
    self.scrollInfoLabel.text = "Scroll For More Settings"
    
    self.chooseCareersInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: 15)
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
        //        for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
        //
        //            if self.chosenCareers.contains(self.careerTypes[index]) {
        //                chooseCareerViews[index].careerChosen = true
        //                chooseCareerViews[index].displayView()
        //            }
        //        }
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
    self.currentCareerLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    
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
        var date:NSDate = NSDate()
        self.saveToCoreData("", p: [], dP: [], aI: "", uI: "", ex: date, r: date)
        self.view.loginUser(self)
        SwiftSpinner.hide()
        
      } else {
        if let error: NSError = error {
          if let errorString = error.userInfo["error"] as? String {
            self.noticeOnlyText("Please try again")
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
        
        var query = PFQuery(className: PF_PREFERENCES_CLASS_NAME)
        let currentUser = PFUser.currentUser()!
        let username = currentUser.username
        //let usernameString = username as! String
        query.whereKey(PF_PREFERENCES_USERNAME, equalTo: username!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
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
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
        
    }
    
    func savePrefsToParse(sender:UIButton){
        
        SwiftSpinner.show("Saving career preferences")
        let currentUser = PFUser.currentUser()!
        let objID = currentUser.objectId
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
                        print(array)
                        SwiftSpinner.hide()
                        self.hideSettingsMenuView(sender)
                        
                    } else {
                        
                        let saveError = SCLAlertView()
                        saveError.showError("Error", subTitle: "Try again")
                        
                    }
                })
                
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
        careerPrefs[PF_PREFERENCES_USER] = PFUser.currentUser()!
        careerPrefs[PF_PREFERENCES_CAREERPREFS] = self.chosenCareers
        
        careerPrefs.saveInBackgroundWithBlock({ (succeeded, error: NSError?) -> Void in
            if error == nil {
                
                SwiftSpinner.hide()
                self.hideSettingsMenuView(sender)
                
            } else {
                
                let saveError = SCLAlertView()
                saveError.showError("Error", subTitle: "Try again")
                
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
    
    let settingsMenuViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.minorMargin * 7) + (self.menuButtonHeight * 4.5))
    
    let settingsMenuViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let settingsMenuViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.settingsMenuViewTopConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.screenFrame.height - ((self.minorMargin * 7) + (self.menuButtonHeight * 4.5)) + self.minorMargin)
    
    self.settingsMenuView.addConstraint(settingsMenuViewHeightConstraint)
    self.view.addConstraints([settingsMenuViewRightConstraint, settingsMenuViewLeftConstraint, self.settingsMenuViewTopConstraint])
    
    // Create and add constraints for chooseCareersView
    
    self.chooseCareersView.translatesAutoresizingMaskIntoConstraints = false
    
    let chooseCareersViewTopConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.backButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin)
    
    let chooseCareersViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let chooseCareersViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let chooseCareersViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.height - (self.statusBarFrame.height + (self.minorMargin * 7) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.backButtonHeight))
    
    self.chooseCareersView.addConstraint(chooseCareersViewHeightConstraint)
    self.view.addConstraints([chooseCareersViewTopConstraint, chooseCareersViewLeftConstraint, chooseCareersViewRightConstraint])
    
    // Create and add constraints for facebookLogoutButton
    
    self.facebookLogoutButton.translatesAutoresizingMaskIntoConstraints = false
    
    let facebookLogoutButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoutButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
    
    let facebookLogoutButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoutButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let facebookLogoutButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoutButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let facebookLogoutButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoutButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    self.facebookLogoutButton.addConstraint(facebookLogoutButtonHeightConstraint)
    self.view.addConstraints([facebookLogoutButtonLeftConstraint, facebookLogoutButtonRightConstraint, facebookLogoutButtonBottomConstraint])
    
    // Create and add constraints for scrollInfoLabel
    
    self.scrollInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let scrollInfoLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let scrollInfoLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight/2)
    
    self.scrollInfoLabel.addConstraint(scrollInfoLabelHeightConstraint)
    self.view.addConstraints([scrollInfoLabelLeftConstraint, scrollInfoLabelTopConstraint, scrollInfoLabelRightConstraint])
    
    // Create and add constraints for settingsScrollView
    
    self.settingsScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let settingsScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let settingsScrollViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.facebookLogoutButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    
    let settingsScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let settingsScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    self.view.addConstraints([settingsScrollViewLeftConstraint, settingsScrollViewBottomConstraint, settingsScrollViewRightConstraint, settingsScrollViewTopConstraint])
    
    // Create and add constraints for each settingsButton and set content size for settingsScrollView
    
    for var index:Int = 0 ; index < self.settingsButtons.count ; index++ {
      
      self.settingsButtons[index].translatesAutoresizingMaskIntoConstraints = false
      
      let settingsButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
      
      let settingsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
      
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
        else if sender == self.facebookLogoutButton {
            
            self.deleteFBTapped(self.facebookLogoutButton)
    
        }
        
    })
    
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
  
  func showTutorial() {
    
    self.view.insertSubview(self.logoImageView, aboveSubview: self.tutorialView)

    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      self.tutorialView.alpha = 1
      self.tutorialNextButton.alpha = 1
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        self.view.insertSubview(self.tutorialViews[0], aboveSubview: self.tutorialView)
        
    })
  }
  
  func nextTutorialButtonClicked(sender:UIButton) {
    
    self.tutorialPageNumber++
    
    if self.tutorialViews[self.tutorialPageNumber - 1] == self.backButton {
      self.savePrefsToParse(sender)
      self.performSegueWithIdentifier("backFromEditProfile", sender: sender)
    }
    else {
      for var index:Int = 0 ; index < self.tutorialViews.count ; index++ {
        if index == self.tutorialPageNumber {
          self.view.insertSubview(self.tutorialViews[index], belowSubview: self.tutorialNextButton)
          if self.tutorialViews[index] == self.chooseCareersView {
            self.tutorialViews[index].userInteractionEnabled = true
          }
          else {
            self.tutorialViews[index].userInteractionEnabled = false
          }
        }
        else {
          self.view.insertSubview(self.tutorialViews[index], belowSubview: self.tutorialView)
          self.tutorialViews[index].userInteractionEnabled = true
        }
      }
      if self.tutorialPageNumber == self.tutorialViews.count - 1 {
        self.tutorialNextButton.setTitle("Back Home", forState: UIControlState.Normal)
      }
    }
    
  }
  
}
