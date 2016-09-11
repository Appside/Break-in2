//
//  quizzPageViewController.swift
//  Break in2
//
//  Created by Jean-Charles Koch on 24/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import Charts
import SCLAlertView
import Parse
import SwiftSpinner
import GoogleMobileAds


class programmingViewController: QuestionViewController, UIScrollViewDelegate, GADInterstitialDelegate {
    
    //Ad variables
    var interstitialAd:GADInterstitial!
    var testStarted:Bool = Bool()
    var AdBeforeClosing:Bool = false
    let defaults = NSUserDefaults.standardUserDefaults()
    var membershipType:String = String()
    
    //Declare variables
    let backgroundUIView:UIView = UIView()
    let swipeUIView:UIView = UIView()
    var swipeMenuHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    var swipeMenuBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
    let menuBackButton:UIView = UIView()
    let questionMenu:UIView = UIView()
    let questionMenuLabel:UILabel = UILabel()
    let swipeMenuTopBar:UIView = UIView()
    let timeLabel:UILabel = UILabel()
    var timeTimer:NSTimer = NSTimer()
    let mainView:UIView = UIView()
    let questionView:UIView = UIView()
    var quizzModel:JSONModel = JSONModel()
    var quizzArray:[programmingQuestion] = [programmingQuestion]()
    var displayedQuestionIndex:Int = 0
    var totalNumberOfQuestions:Int = 4
    let questionLabel:UITextView = UITextView()
    var allowedSeconds:Int = Int()
    var allowedMinutes:Int = Int()
    var countSeconds:Int = Int()
    var countMinutes:Int = Int()
    let answerView:UIView = UIView()
    let nextButton:UIButton = UIButton()
    var selectedAnswers:[Bool] = [Bool]()
    var qViewHeight:NSLayoutConstraint = NSLayoutConstraint()
    let feebdackScreen:UIScrollView = UIScrollView()
    var scoreRatio:Float = Float()
    var isTestComplete:Bool = false
    var resultsUploaded:Bool = false
    var testEnded:Bool = false
    
    //tableview variables
    let passageView:UIView = UIView()
    var currentIndexPath: NSIndexPath?
    var correctOrder:[String] = [String]()
    var cellTitles:[String] = [String]()
    var skipquestion:Bool = false
    
    //Screen size
    var widthRatio:CGFloat = CGFloat()
    var heightRatio:CGFloat = CGFloat()
    
    //Tutorial Views
    var showTutorial:Bool = true
    let tutoView:UIView = UIView()
    let tutoDescription:UILabel = UILabel()
    let tutoDescriptionTitle:UILabel = UILabel()
    let tutoDescriptionText:UILabel = UILabel()
    let tutoDescriptionTitle2:UILabel = UILabel()
    let tutoDescriptionText2:UILabel = UILabel()
    let tutoNextButton:UIButton = UIButton()
    let tutoSkipButton:UIButton = UIButton()
    let logoImageView:UILabel = UILabel()
    let tutorialFingerImageView:UIImageView = UIImageView()
    var tutoPage:Int = 0
    let tutoDescriptionSep:UIView = UIView()
    let tutoDescriptionSep2:UIView = UIView()
    let whiteBGView:UIView = UIView()
    let newTutoButton:UIButton = UIButton()
    var numberOfAttempts:[Int] = [Int]()
    var passageTableView:TableViewEdited = TableViewEdited()
    
    //ViewDidLoad call
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.membershipType = defaults.objectForKey("Membership") as! String
        self.interstitialAd = self.createAndLoadInterstitial()
        self.testStarted = false
        self.questionLabel.editable = false
        
        //Screen size and constraints
        let screenFrame:CGRect = UIScreen.mainScreen().bounds
        self.widthRatio = screenFrame.size.width / 414
        self.heightRatio = screenFrame.size.height / 736
        
        //Initialize timer depending on difficulty
        if self.difficulty == "H" {
            self.allowedSeconds = 15
            self.allowedMinutes = 00
        }
        else if self.difficulty == "M" {
            self.allowedSeconds = 00
            self.allowedMinutes = 10
        }
        else {
            self.allowedSeconds = 00
            self.allowedMinutes = 15
        }
        
        //Initialize timer
        self.countSeconds = self.allowedSeconds
        self.countMinutes = self.allowedMinutes
        
        //Initialize background UIView
        self.view.addSubview(self.backgroundUIView)
        self.backgroundUIView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "hexagonBGDark")
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        self.backgroundUIView.addSubview(imageViewBackground)
        self.backgroundUIView.sendSubviewToBack(imageViewBackground)
        
        //Initialize menuBackButton UIView
        self.view.addSubview(self.menuBackButton)
        self.menuBackButton.translatesAutoresizingMaskIntoConstraints = false
        let topMenuViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30*self.heightRatio)
        let topMenuViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35*self.heightRatio)
        let topMenuViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35*self.heightRatio)
        let topMenuViewLeftMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20*self.widthRatio)
        self.menuBackButton.addConstraints([topMenuViewHeight, topMenuViewWidth])
        self.view.addConstraints([topMenuViewLeftMargin,topMenuViewTopMargin])
        self.menuBackButton.layer.cornerRadius = 8.0
        let menuBackImageVIew:UIImageView = UIImageView()
        menuBackImageVIew.image = UIImage(named: "back")
        menuBackImageVIew.translatesAutoresizingMaskIntoConstraints = false
        self.menuBackButton.addSubview(menuBackImageVIew)
        let arrowTop:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant:0)
        let arrowLeft:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant:0)
        let arrowHeight:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30*self.heightRatio)
        let arrowWidth:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35*self.heightRatio)
        self.menuBackButton.addConstraints([arrowTop,arrowLeft])
        menuBackImageVIew.addConstraints([arrowHeight,arrowWidth])
        let tapGestureBackHome:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(programmingViewController.backHome(_:)))
        tapGestureBackHome.numberOfTapsRequired = 1
        self.menuBackButton.addGestureRecognizer(tapGestureBackHome)
        
        //Initialize questionMenu UIView
        self.view.addSubview(self.questionMenu)
        self.questionMenu.translatesAutoresizingMaskIntoConstraints = false
        let questionViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        let questionViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 40*self.widthRatio)
        let questionViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35*self.heightRatio)
        let questionViewRightMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20*self.widthRatio)
        self.questionMenu.addConstraints([questionViewHeight, questionViewWidth])
        self.view.addConstraints([questionViewRightMargin,questionViewTopMargin])
        self.view.bringSubviewToFront(self.menuBackButton)
        
        self.questionMenu.addSubview(self.questionMenuLabel)
        self.questionMenuLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        questionMenuLabel.textAlignment = NSTextAlignment.Center
        self.questionMenuLabel.textColor = UIColor.whiteColor()
        
        //Initialize swipeMenuTopBar UIView
        self.swipeUIView.addSubview(self.swipeMenuTopBar)
        self.swipeMenuTopBar.translatesAutoresizingMaskIntoConstraints = false
        let swipeMenuTopBarTop:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10*self.heightRatio)
        let swipeMenuTopBarLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10*self.widthRatio)
        let swipeMenuTopBarRight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10*self.widthRatio)
        self.swipeUIView.addConstraints([swipeMenuTopBarTop,swipeMenuTopBarLeft,swipeMenuTopBarRight])
        let swipeMenuTopBarHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.heightRatio)
        self.swipeMenuTopBar.addConstraint(swipeMenuTopBarHeight)
        self.swipeMenuTopBar.addSubview(self.timeLabel)
        self.timeLabel.text = String(format: "%02d", self.countMinutes) + " : " + String(format: "%02d", self.countSeconds)
        self.timeLabel.setConstraintsToSuperview(0, bottom: Int(30*self.heightRatio), left: 0, right: 0)
        self.timeLabel.font = UIFont(name: "HelveticaNeue-Bold",size: self.view.getTextSize(18))
        self.timeLabel.textAlignment = NSTextAlignment.Center
        self.timeLabel.textColor = UIColor.redColor()
        self.timeLabel.userInteractionEnabled = true
        self.swipeUIView.addSubview(self.answerView)
        self.answerView.translatesAutoresizingMaskIntoConstraints = false
        self.answerView.setConstraintsToSuperview(Int(80*self.heightRatio), bottom: Int(70*self.heightRatio), left: 0, right: 0)
        
        //Initialize mainView, questionView and passageView
        self.passageTableView = TableViewEdited(frame: view.frame, style: .Plain)
        self.passageTableView.delegate = self
        self.passageTableView.dataSource = self
        self.passageTableView.setRearrangeOptions([.hover, .translucency], dataSource: self)
        
        self.view.addSubview(self.mainView)
        self.mainView.setConstraintsToSuperview(Int(75*self.heightRatio), bottom: Int(135*self.heightRatio), left: Int(20*self.widthRatio), right: Int(20*self.widthRatio))
        self.mainView.addSubview(self.questionView)
        self.mainView.addSubview(self.passageView)
        self.passageView.addSubview(passageTableView)
        passageTableView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.questionView.translatesAutoresizingMaskIntoConstraints = false
        self.passageView.translatesAutoresizingMaskIntoConstraints = false
        
        let questionViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let questionViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let questionViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.mainView.addConstraints([questionViewTop,questionViewRight,questionViewLeft])
        self.qViewHeight = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 90*self.heightRatio)
        self.mainView.addConstraint(qViewHeight)
        
        //Set passageView topMenu
        let layer1:UIView = UIView()
        let layer2:UIView = UIView()
        self.passageView.addSubview(layer1)
        self.passageView.addSubview(layer2)
        
        layer1.translatesAutoresizingMaskIntoConstraints = false
        layer2.translatesAutoresizingMaskIntoConstraints = false
        
        let layer1top:NSLayoutConstraint = NSLayoutConstraint(item: layer1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.passageView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let layer1left:NSLayoutConstraint = NSLayoutConstraint(item: layer1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.passageView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let layer1right:NSLayoutConstraint = NSLayoutConstraint(item: layer1, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.passageView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let layer1height:NSLayoutConstraint = NSLayoutConstraint(item: layer1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 20*self.heightRatio)
        self.passageView.addConstraints([layer1left,layer1right,layer1top])
        layer1.addConstraint(layer1height)
        
        let layer2top:NSLayoutConstraint = NSLayoutConstraint(item: layer2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.passageView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 5*self.heightRatio)
        let layer2left:NSLayoutConstraint = NSLayoutConstraint(item: layer2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.passageView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let layer2right:NSLayoutConstraint = NSLayoutConstraint(item: layer2, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.passageView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let layer2height:NSLayoutConstraint = NSLayoutConstraint(item: layer2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 30*self.heightRatio)
        self.passageView.addConstraints([layer2left,layer2right,layer2top])
        layer2.addConstraint(layer2height)
        
        layer1.backgroundColor = UIColor.whiteColor()
        layer1.alpha = 0.0
        layer2.backgroundColor = UIColor.whiteColor()
        layer2.alpha = 0.0
        layer1.layer.cornerRadius = 8.0
        
        //Design of passageView
        self.passageView.layer.cornerRadius = 10.0
        
        //update questionView
        self.questionView.addSubview(self.questionLabel)
        self.questionLabel.setConstraintsToSuperview(Int(10*self.heightRatio), bottom: 0, left: Int(15*self.widthRatio), right: Int(15*self.widthRatio))
        self.questionLabel.textColor = UIColor.whiteColor()
        self.questionLabel.font = UIFont(name: "HelveticaNeue-Medium",size: self.view.getTextSize(17))
        self.questionLabel.textAlignment = NSTextAlignment.Center
        self.questionLabel.backgroundColor = UIColor(white: 0, alpha: 0)
        self.questionView.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.5)        
        
        //self.questionView.layer.cornerRadius = 8.0
        
        //Update top constraint
        let passageViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 100*self.heightRatio)
        let passageViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let passageViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let passageViewBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.mainView.addConstraints([passageViewTop,passageViewRight,passageViewLeft,passageViewBottom])
        
        //Create nextButton
        self.swipeUIView.addSubview(self.nextButton)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.nextButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.nextButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        self.nextButton.setTitle("Next", forState: .Normal)
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 50*self.heightRatio)
        let rightLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20)*self.widthRatio)
        let leftLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20)*self.widthRatio)
        self.swipeUIView.addConstraints([topLabelMargin,rightLabelMargin,leftLabelMargin])
        let heightLabelConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 50*self.heightRatio)
        self.nextButton.addConstraint(heightLabelConstraint)
        self.nextButton.addTarget(self, action: #selector(programmingViewController.nextQuestion(_:)), forControlEvents: .TouchUpInside)
        
        //Set answersArray
      for _:Int in 0...self.totalNumberOfQuestions {
            self.selectedAnswers.append(false)
            self.numberOfAttempts.append(0)
        }
        
        //Display questions
        self.displayedQuestionIndex = 0
        self.quizzArray = self.quizzModel.selectProgramming(self.totalNumberOfQuestions+1)
        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex, feedback: false)
        
        //Initialize swipeUIView
        self.view.addSubview(self.swipeUIView)
        self.swipeUIView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeMenuHeightConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120*self.heightRatio)
        self.swipeUIView.addConstraint(self.swipeMenuHeightConstraint)
        self.swipeMenuBottomConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5*self.heightRatio)
        let leftMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20*self.widthRatio)
        let rightMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20*self.widthRatio)
        self.view.addConstraints([leftMargin,rightMargin,self.swipeMenuBottomConstraint])
        self.swipeUIView.backgroundColor = UIColor.whiteColor()
        self.swipeUIView.layer.cornerRadius = 8.0
        
        if self.showTutorial == true {
            
            //Set constraints to each view
            self.tutoView.tag = 999
            self.view.addSubview(self.tutoView)
            self.tutoView.addSubview(self.tutoNextButton)
            self.tutoView.addSubview(self.tutoSkipButton)
            self.tutoView.addSubview(self.tutoDescription)
            self.tutoView.addSubview(self.logoImageView)
            self.tutoView.addSubview(self.tutorialFingerImageView)
            self.tutoDescription.addSubview(self.tutoDescriptionTitle)
            self.tutoDescription.addSubview(self.tutoDescriptionText)
            self.tutoDescription.addSubview(self.tutoDescriptionTitle2)
            self.tutoDescription.addSubview(self.tutoDescriptionText2)
            self.tutoDescription.addSubview(self.tutoDescriptionSep)
            self.tutoDescriptionSep.backgroundColor = UIColor.whiteColor()
            self.tutoDescription.addSubview(self.tutoDescriptionSep2)
            self.tutoDescriptionSep2.backgroundColor = UIColor.whiteColor()
            
            self.tutoView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
            
            self.tutoDescription.translatesAutoresizingMaskIntoConstraints = false
            let tutoDescriptionCenterY:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: (300/2-60)*self.heightRatio)
            let tutoDescriptionLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 50*self.widthRatio)
            let tutoDescriptionRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -50*self.widthRatio)
            self.tutoView.addConstraints([tutoDescriptionCenterY,tutoDescriptionLeft,tutoDescriptionRight])
            let tutoDescriptionHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 300*self.heightRatio)
            self.tutoDescription.addConstraint(tutoDescriptionHeight)
            
            self.tutoNextButton.translatesAutoresizingMaskIntoConstraints = false
            let tutoNextButtonBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -10*self.heightRatio)
            let tutoNextButtonLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 40*self.widthRatio)
            let tutoNextButtonRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -40*self.widthRatio)
            self.tutoView.addConstraints([tutoNextButtonBottom,tutoNextButtonLeft,tutoNextButtonRight])
            let tutoNextButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.heightRatio)
            self.tutoNextButton.addConstraint(tutoNextButtonHeight)
            
            self.tutoSkipButton.translatesAutoresizingMaskIntoConstraints = false
            let tutoSkipButtonTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: (self.view.frame.width/12)+30*self.heightRatio)
            let tutoSkipButtonCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            self.tutoView.addConstraints([tutoSkipButtonTop,tutoSkipButtonCenterX])
            let tutoSkipButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20*self.heightRatio)
            let tutoSkipButtonWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 200*self.widthRatio)
            self.tutoSkipButton.addConstraints([tutoSkipButtonHeight,tutoSkipButtonWidth])
            
            self.tutoDescriptionTitle.setConstraintsToSuperview(0, bottom: Int(285*self.heightRatio), left: 0, right: 0)
            self.tutoDescriptionSep.setConstraintsToSuperview(Int(17*self.heightRatio), bottom: Int(282*self.heightRatio), left: 0, right: 0)
            self.tutoDescriptionTitle2.setConstraintsToSuperview(Int(160*self.heightRatio), bottom: Int(125*self.heightRatio), left: 0, right: 0)
            self.tutoDescriptionSep2.setConstraintsToSuperview(Int(177*self.heightRatio), bottom: Int(122*self.heightRatio), left: 0, right: 0)
            
            self.tutoDescriptionText.translatesAutoresizingMaskIntoConstraints = false
            let tutoDescriptionTextTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20*self.heightRatio)
            let tutoDescriptionTextLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let tutoDescriptionTextRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            self.tutoDescription.addConstraints([tutoDescriptionTextTop,tutoDescriptionTextLeft,tutoDescriptionTextRight])
            let tutoDescriptionText2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 180*self.heightRatio)
            let tutoDescriptionText2Left:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let tutoDescriptionText2Right:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            self.tutoDescription.addConstraints([tutoDescriptionText2Top,tutoDescriptionText2Left,tutoDescriptionText2Right])
            
            self.tutoDescriptionText2.translatesAutoresizingMaskIntoConstraints = false
            self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
            let logoImageViewCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            let logoImageViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 25*self.heightRatio)
            let logoImageViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/12)
            let logoImageViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-40*self.widthRatio)
            self.logoImageView.addConstraints([logoImageViewHeight, logoImageViewWidth])
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
            let labelString:String = String("PROGRAMMING TEST")
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 7, length: NSString(string: labelString).length-7))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: NSString(string: labelString).length))
            self.logoImageView.attributedText = attributedString
            
            //Design
            self.logoImageView.textAlignment = NSTextAlignment.Center
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
            self.tutoNextButton.setTitle("Continue", forState: .Normal)
            self.tutoNextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            self.tutoNextButton.titleLabel?.textAlignment = NSTextAlignment.Center
            let tutoNextButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(programmingViewController.tutoNext(_:)))
            self.tutoNextButton.addGestureRecognizer(tutoNextButtonTap)
            self.tutoSkipButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.tutoSkipButton.setTitle("Skip the Tutorial", forState: .Normal)
            self.tutoSkipButton.titleLabel?.font = UIFont(name: "HelveticaNeue-LightItalic", size: self.view.getTextSize(15))
            self.tutoSkipButton.titleLabel?.textAlignment = NSTextAlignment.Center
            let tutoSkipButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(programmingViewController.tutoSkip(_:)))
            self.tutoSkipButton.addGestureRecognizer(tutoSkipButtonTap)
            
            //Set tutorial text
            self.tutoDescriptionTitle.text = "Test Description:"
            self.tutoDescriptionText.text = "You will be tested on your ability to understand and write code. This test does not explicitly refer to one programming language in particular, but rather tests your general logical ability. You will have \(self.allowedMinutes) minutes to answer up to \(self.totalNumberOfQuestions+1) questions."
            self.tutoDescriptionTitle2.text = "Our Recommendation:"
            self.tutoDescriptionText2.text = "We recommend that you are able to score at least 85% on medium difficulty before taking the actual test."
            self.passageView.alpha = 0.0
            
            //Set Tutorial page
            self.tutoPage = 1
            
        } else {
            //Launch timer
            if self.interstitialAd.isReady && self.membershipType == "Free" {
                self.interstitialAd.presentFromRootViewController(self)
            } else {
                print("Ad wasn't ready")
                self.testStarted = true
                self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(programmingViewController.updateTimer), userInfo: nil, repeats: true)
            }
        }
        
    }
    
    func tutoNext(sender:UITapGestureRecognizer) {
        self.tutoPage += 1
        if self.tutoPage==2 {
            self.tutoDescriptionSep2.alpha = 0
            self.tutoDescriptionText2.alpha = 0
            self.tutoDescriptionTitle2.alpha = 0
            self.tutoDescriptionText.textAlignment = NSTextAlignment.Center
            self.tutoDescriptionTitle.alpha = 0.0
            self.tutorialFingerImageView.alpha = 0.0
            self.tutoDescriptionText.text = "We have written passages of code, then shuffled them. Hold then drag each line to rearrange the code into the correct order. You will be scored based on your ability to answer correctly on your first attempt.\n\nHave a go on the next page..."
        }
        if self.tutoPage==3 {
            self.tutoSkipButton.alpha = 0.0
            self.tutoDescriptionText.alpha = 0.0
            self.tutoDescriptionSep.alpha = 0.0
            self.view.bringSubviewToFront(self.mainView)
            self.view.bringSubviewToFront(self.swipeUIView)
            self.passageView.alpha = 1.0
            self.nextButton.setTitle("Continue", forState: .Normal)
        }
        if self.tutoPage==4 {
            self.passageView.alpha = 0.0
            self.view.bringSubviewToFront(self.tutoView)
            self.nextButton.setTitle("Next", forState: .Normal)
            self.tutoSkipButton.alpha = 1.0
            self.tutoDescriptionTitle.alpha = 1.0
            self.tutoDescriptionSep.alpha = 1.0
            self.tutoDescriptionText.alpha = 1.0
            self.tutoDescriptionTitle.textAlignment = NSTextAlignment.Center
            self.tutoDescriptionTitle.text = "Ready to start?"
            self.tutoDescriptionText.text = "You are now ready to start the test. Practice hard, and remember that both speed AND accuracy in the candidate selection process!"
            self.tutoNextButton.setTitle("Start Test", forState: .Normal)
        }
        if self.tutoPage==5 {
            self.tutoView.alpha = 0
            self.passageView.alpha = 1.0
            self.selectedAnswers[self.displayedQuestionIndex] = false
            self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex, feedback: false)
            self.showTutorial = false
            if self.interstitialAd.isReady && self.membershipType == "Free" {
                self.interstitialAd.presentFromRootViewController(self)
            } else {
                self.testStarted = true
                self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(programmingViewController.updateTimer), userInfo: nil, repeats: true)
                print("Ad wasn't ready")
            }
        }
        
    }
    
    func tutoSkip(sender:UITapGestureRecognizer) {
        self.passageView.alpha = 1.0
        self.showTutorial = false
        if self.interstitialAd.isReady && self.membershipType == "Free" {
            self.interstitialAd.presentFromRootViewController(self)
        } else {
            self.testStarted = true
            self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(programmingViewController.updateTimer), userInfo: nil, repeats: true)
            print("Ad wasn't ready")
        }
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.tutoView.alpha = 0.0
            }, completion: nil)
    }
    
    func updateTimer() {
        if self.testEnded {
            self.displayedQuestionIndex = self.totalNumberOfQuestions
            self.skipquestion = true
            self.nextQuestion(UITapGestureRecognizer(target: self, action: #selector(programmingViewController.nextQuestion(_:))))
            self.timeTimer.invalidate()
        }
        else {
            if (self.countSeconds-1<0) {
                if (self.countMinutes+self.countSeconds==0) {
                    self.timeTimer.invalidate()
                }
                else {
                    self.countMinutes -= 1
                    self.countSeconds = 59
                }
            }
            else {
                self.countSeconds -= 1
            }
            let newMin:String = String(format: "%02d", self.countMinutes)
            let newSec:String = String(format: "%02d", self.countSeconds)
            let newLabel:String = "\(newMin) : \(newSec)"
            self.timeLabel.text = newLabel
            if (self.countMinutes==0 && self.countSeconds==0) {
                self.testEnded = true
            }
        }
    }
    
    func backHome(sender:UITapGestureRecognizer) {
        var alertMessage:String = String()
        if (self.isTestComplete==false) {
            alertMessage = "Are you sure you want to return home? All progress will be lost!"
        } else {
            alertMessage = "Are you sure you want to return home?"
        }
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let backAlert = SCLAlertView(appearance: appearance)
        backAlert.addButton("Yes", target:self, selector:#selector(programmingViewController.goBack))
        backAlert.showTitle(
            "Return to Menu", // Title of view
            subTitle: alertMessage, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Cancel", // Optional button value, default: ""
            style: .Error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
            colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
            colorTextButton: 0xFFFFFF
        )
        
    }
    
    func goBack(){
        
        self.AdBeforeClosing = true
        if self.interstitialAd.isReady && self.membershipType == "Free" {
            self.interstitialAd.presentFromRootViewController(self)
        } else {
            self.timeTimer.invalidate()
            self.performSegueWithIdentifier("backHomeSegue", sender: nil)
            print("Ad wasn't ready")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "backHomeSegue" {
            self.timeTimer.invalidate()
            let destinationVC:HomeViewController = segue.destinationViewController as! HomeViewController
            destinationVC.segueFromLoginView = false
        }
        
    }
    
    func displayQuestion(arrayOfQuestions:[programmingQuestion], indexQuestion:Int, feedback:Bool) {
        
        self.passageTableView.answerArray = []
        
        //Initialize labels
        let labelString:String = String("QUESTION \(indexQuestion+1)/\(self.totalNumberOfQuestions+1)")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 9, length: NSString(string: labelString).length-9))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.questionMenuLabel.attributedText = attributedString
        self.questionMenuLabel.attributedText = attributedString
        
        //Update the view with the new question
        let questionText:String = arrayOfQuestions[indexQuestion].question
        self.questionLabel.text = questionText
        
        if feedback == false {
            self.cellTitles = self.randomizeQuestion(self.quizzArray[indexQuestion].codePassage)
        } else {
            self.cellTitles = self.quizzArray[indexQuestion].feedback
        }
        print(self.cellTitles)
        self.passageTableView.reloadData()
        
    }
    
    func nextQuestion(gesture:UITapGestureRecognizer) {
        
        //Check if button pressed during tutorial ?
        if self.tutoPage==3 {
            self.tutoNext(UITapGestureRecognizer())
        } else {
            
            // If no answer is selected, show Alert
            if self.checkAnswer(self.displayedQuestionIndex) == false && self.skipquestion == false {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                let exitAlert = SCLAlertView(appearance:appearance)
                exitAlert.addButton("Skip question", action: {
                    self.skipquestion = true
                    self.numberOfAttempts[self.displayedQuestionIndex] = 1000
                    self.nextQuestion(UITapGestureRecognizer())
                })
                exitAlert.showTitle(
                    "Incorrect answer", // Title of view
                    subTitle: "Your answer is incorrect. Do you want to move to the next question?", // String of view
                    duration: 0.0, // Duration to show before closing automatically, default: 0.0
                    completeText: "Close", // Optional button value, default: ""
                    style: .Warning, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
                    colorStyle: 0xFFD110,
                    colorTextButton: 0xFFFFFF
                )
            }
            else {
                //Else go to next question
                //Go to the feedback screen
                if self.displayedQuestionIndex + 1 > self.totalNumberOfQuestions {
                    
                    if self.resultsUploaded==false {
                        //Stop Timer
                        self.timeTimer.invalidate()
                        
                        if self.testStarted == true {
                            if self.interstitialAd.isReady && self.membershipType == "Free" {
                                self.interstitialAd.presentFromRootViewController(self)
                            } else {
                                print("Ad wasn't ready")
                                self.testStarted = false
                                self.nextQuestion(UITapGestureRecognizer())
                            }
                        } else {
                            
                            //Upload Results to Parse
                            var nbCorrectAnswers:Double = 0
                            
                          for i:Int in 0..<self.selectedAnswers.count {
                                if self.selectedAnswers[i] && self.numberOfAttempts[i] == 1 {
                                    nbCorrectAnswers += 1
                                }
                                else if self.selectedAnswers[i] && self.numberOfAttempts[i] == 2 {
                                    nbCorrectAnswers += 0.5
                                }
                             }
                            
                            self.scoreRatio = (Float(nbCorrectAnswers) / Float(self.quizzArray.count)) * 100
                            //Add: test type (numerical / verbal ...)
                            
                            var timeTaken:Float = Float(60 * self.allowedMinutes + self.allowedSeconds) - Float(60 * self.countMinutes + self.countSeconds)
                            timeTaken = timeTaken/Float(self.quizzArray.count)
                            
                            SwiftSpinner.show("Saving Results")
                            
                            let user = PFUser.currentUser()
                            let analytics = PFObject(className: PF_PROG_CLASS_NAME)
                            analytics[PF_PROG_USER] = user
                            analytics[PF_PROG_SCORE] = self.scoreRatio
                            analytics[PF_PROG_TIME] = timeTaken
                            analytics[PF_PROG_USERNAME] = user![PF_USER_USERNAME]
                            
                            analytics.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                                if error == nil {
                                    
                                    SwiftSpinner.show("Results Saved", animated: false).addTapHandler({
                                        SwiftSpinner.hide()
                                        self.resultsUploaded = true
                                        self.feedbackScreen()
                                        }, subtitle: "Tap to proceed to feedback screen")
                                    
                                } else {
                                    
                                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                                        
                                        SwiftSpinner.hide()
                                        self.feedbackScreen()
                                        
                                        }, subtitle: "Results unsaved, tap to proceed to feedback")
                                    
                                }
                            })
                        }
                    }
                    else {
                        self.feedbackScreen()
                    }
                }
                    //Continue to the next question
                else {
                    if self.skipquestion == true {
                    
                        self.skipquestion = false
                        
                        UIView.animateWithDuration(1, animations: {
                            self.passageView.alpha = 1.0
                            }, completion: nil)
                        self.displayedQuestionIndex += 1
                        if self.displayedQuestionIndex==self.totalNumberOfQuestions{
                            //Switch Button text to "Complete"
                        self.nextButton.setTitle("Complete Test", forState: .Normal)                        }
                        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex, feedback: false)
                        
                    } else {
                        
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                    let backAlert = SCLAlertView(appearance: appearance)
                    backAlert.addButton("Ok", action: {
                        UIView.animateWithDuration(1, animations: {
                            self.passageView.alpha = 1.0
                            }, completion: nil)
                        self.displayedQuestionIndex += 1
                        if self.displayedQuestionIndex==self.totalNumberOfQuestions{
                            //Switch Button text to "Complete"
                            self.nextButton.setTitle("Complete Test", forState: .Normal)
                        }
                        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex, feedback: false)
                    })
                    backAlert.showTitle(
                        "Correct Answer", // Title of view
                        subTitle: "Move to the next question", // String of view
                        duration: 0.0, // Duration to show before closing automatically, default: 0.0
                        completeText: "Ok", // Optional button value, default: ""
                        style: .Success, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
                        colorStyle: 0x22B573,//0x526B7B,//0xD0021B - RED
                        colorTextButton: 0xFFFFFF
                        
                    )
                    }
                }
            }
        }
    }
    
    func backFeedbackScreen(sender:UITapGestureRecognizer) {
        
        self.mainView.alpha = 0.0
        self.swipeUIView.alpha = 0.0
        self.feebdackScreen.alpha = 1.0
        
        let labelString:String = String("SCORE: \(round(self.scoreRatio))%")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 6, length: NSString(string: labelString).length-6))
        if self.scoreRatio<70 {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: 6, length: NSString(string: labelString).length-6))
        }
        else {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location: 6, length: NSString(string: labelString).length-6))
        }
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: 6))
        self.questionMenuLabel.attributedText = attributedString
        
    }
    
    func feedbackScreen() {
        //Display feedback screen here
        
        self.nextButton.addTarget(self, action: #selector(programmingViewController.backFeedbackScreen(_:)), forControlEvents: .TouchUpInside)
        
        self.isTestComplete = true
        let buttonHeight:Int = Int(40*self.heightRatio)
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            let labelString:String = String("SCORE: \(round(self.scoreRatio))%")
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 6, length: NSString(string: labelString).length-6))
            if self.scoreRatio<70 {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: 6, length: NSString(string: labelString).length-6))
            }
            else {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location: 6, length: NSString(string: labelString).length-6))
            }
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: 6))
            self.questionMenuLabel.attributedText = attributedString
            
            self.mainView.alpha = 0.0
            self.swipeUIView.alpha = 0.0
            self.feebdackScreen.alpha = 1.0
            self.view.addSubview(self.feebdackScreen)
            self.feebdackScreen.setConstraintsToSuperview(Int(75*self.heightRatio), bottom: Int(20*self.heightRatio), left: Int(20*self.widthRatio), right: Int(20*self.widthRatio))
            self.feebdackScreen.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.feebdackScreen.layer.cornerRadius = 8.0
            }, completion: nil)
        
        let topComment:UILabel = UILabel()
        self.feebdackScreen.addSubview(topComment)
        topComment.translatesAutoresizingMaskIntoConstraints = false
        let topMg:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10*self.heightRatio)
        let leftMg:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20*self.widthRatio)
        self.feebdackScreen.addConstraints([topMg,leftMg])
        
        let widthCt:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 80*self.widthRatio)
        let heightCt:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 15*self.heightRatio)
        topComment.addConstraints([heightCt,widthCt])
        topComment.text = "Select Question For Feedback"
        topComment.numberOfLines = 0
        topComment.textAlignment = NSTextAlignment.Center
        topComment.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        topComment.textColor = UIColor.whiteColor()
        
      for i:Int in 0..<self.quizzArray.count {
            let answerUIButton:UIButton = UIButton()
            let answerUILabel:UILabel = UILabel()
            let answerNumber:UILabel = UILabel()
            answerUIButton.translatesAutoresizingMaskIntoConstraints = false
            answerUILabel.translatesAutoresizingMaskIntoConstraints = false
            answerNumber.translatesAutoresizingMaskIntoConstraints = false
            self.feebdackScreen.addSubview(answerUIButton)
            answerUIButton.tag = i
            answerUIButton.addSubview(answerUILabel)
            answerUIButton.addSubview(answerNumber)
            answerNumber.text = String(i+1)
            answerNumber.textAlignment = NSTextAlignment.Center
            answerNumber.textColor = UIColor.whiteColor()
            answerUILabel.textAlignment = NSTextAlignment.Center
            answerUILabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            answerUILabel.numberOfLines = 0
            answerUILabel.adjustsFontSizeToFitWidth = true
            answerUIButton.backgroundColor = UIColor.whiteColor()
            answerUILabel.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            answerUIButton.layer.borderWidth = 3.0
            answerUIButton.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
            
             if self.numberOfAttempts[i] < 3 && self.numberOfAttempts[i] > 0 && self.selectedAnswers[i] {
                answerUILabel.text = "Correct (" + String(self.numberOfAttempts[i]) + " attemps)"
                answerNumber.backgroundColor = UIColor.greenColor()
             }
             else if self.numberOfAttempts[i] > 2 && self.numberOfAttempts[i] < 1000 && self.selectedAnswers[i] {
                answerUILabel.text = "Correct (" + String(self.numberOfAttempts[i]) + " attemps)"
                answerNumber.backgroundColor = UIColor.orangeColor()
             }
             else if self.numberOfAttempts[i] > 2 && self.numberOfAttempts[i] < 1000 && !self.selectedAnswers[i] {
                answerUILabel.text = "Incorrect (" + String(self.numberOfAttempts[i]) + " attemps)"
                answerNumber.backgroundColor = UIColor.redColor()
             }
             else {
                answerUILabel.text = "Question skipped"
                answerNumber.backgroundColor = UIColor.redColor()
            }
            
            //Set constraints to answerViews
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+Int(10*self.heightRatio)) + 40))
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20*self.widthRatio)
            self.feebdackScreen.addConstraints([topMargin,leftMargin])
            
            let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 80*self.widthRatio)
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: CGFloat(buttonHeight))
            answerUIButton.addConstraints([heightConstraint,widthConstraint])
            
            let topM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let rightM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            let leftM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 50*self.widthRatio)
            let bottomM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topM,rightM,leftM,bottomM])
            
            let topMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let leftMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let bottomMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topMM,leftMM,bottomMM])
            let widthMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.widthRatio)
            answerNumber.addConstraint(widthMM)
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(programmingViewController.displayAnswerWithFeedback(_:)))
            answerUIButton.addGestureRecognizer(tapGesture)
            
        }
        
        self.feebdackScreen.scrollEnabled = true
        let totalHeight:CGFloat = CGFloat(self.selectedAnswers.count+1) * (CGFloat(buttonHeight) + 10*self.heightRatio)
        self.feebdackScreen.contentSize = CGSize(width: (self.view.frame.width - 40*self.widthRatio), height: totalHeight+30)
        
    }
    
        func displayAnswerWithFeedback(gesture:UITapGestureRecognizer) {
    
            UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.mainView.alpha = 1.0
                self.swipeUIView.alpha = 1.0
                self.feebdackScreen.alpha = 0.0
                self.questionMenuLabel.textColor = UIColor.blackColor()
    
                for recognizer in self.nextButton.gestureRecognizers ?? [] {
                    self.nextButton.removeGestureRecognizer(recognizer)
                }
                
                let tapGestureNext:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(programmingViewController.backFeedbackScreen(_:)))
                tapGestureNext.numberOfTapsRequired = 1
                self.nextButton.addGestureRecognizer(tapGestureNext)
                
                var questionFeedback:Int = Int()
                let buttonTapped:UIView? = gesture.view
                if let actualButton = buttonTapped {
                    questionFeedback = actualButton.tag
                }
                self.displayQuestion(self.quizzArray, indexQuestion: questionFeedback, feedback: true)
    
                let feedbackLabel:UITextView = UITextView()
                feedbackLabel.userInteractionEnabled = false
                self.answerView.addSubview(feedbackLabel)
                
                feedbackLabel.setConstraintsToSuperview(Int(10*self.heightRatio), bottom: Int(10*self.heightRatio), left: Int(30*self.widthRatio), right: Int(30*self.widthRatio))
                feedbackLabel.font = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(14))
                
                UIView.animateWithDuration(1, animations: {
                    self.passageView.alpha = 1.0
                    self.nextButton.setTitle("Return to Results", forState: .Normal)
                    }, completion: nil)
    
                if self.selectedAnswers[questionFeedback] == true {
                    self.timeLabel.text = "Correct Answer"
                    self.timeLabel.textColor = UIColor.greenColor()
                    feedbackLabel.textColor = UIColor.greenColor()
                }
                else {
                    self.timeLabel.text = "Wrong Answer"
                    self.timeLabel.textColor = UIColor.redColor()
                    feedbackLabel.textColor = UIColor.redColor()
                }
                
                }, completion: nil)
            
        }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: AD_ID_PROGRAMMING)
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "kGADSimulatorID" ]
        interstitial.delegate = self
        interstitial.loadRequest(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        self.interstitialAd = createAndLoadInterstitial()
        if self.AdBeforeClosing == true {
            self.timeTimer.invalidate()
            self.performSegueWithIdentifier("backHomeSegue", sender: nil)
        } else {
            if self.testStarted == false {
                self.testStarted = true
                self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(programmingViewController.updateTimer), userInfo: nil, repeats: true)
            } else if self.testStarted == true {
                self.testStarted = false
                self.nextQuestion(UITapGestureRecognizer())
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func randomizeQuestion(questionArray:[String])  -> [String] {
        
        var inputQuestionArray:[String] = [String]()
        var randomizedArray:[String] = [String]()
        let numberOfCells:Int = questionArray.count
        var j:Int = numberOfCells
        
        inputQuestionArray = questionArray
        
      for i:Int in 0..<numberOfCells {
            
            let randomIndex = arc4random_uniform(UInt32(j))
            randomizedArray.append(inputQuestionArray[Int(randomIndex)])
            
            inputQuestionArray.removeAtIndex(Int(randomIndex))
            j = j - 1
            
            self.correctOrder.append(questionArray[i])
            
        }
        
        self.passageTableView.answerArray = randomizedArray
        
        return randomizedArray
        
    }
    
    func checkAnswer(answerToQuestion:Int) -> Bool {
        
        self.numberOfAttempts[answerToQuestion] += 1
        
        var returnedValue:Bool = true
        
//        var i:Int = 0
//        var returnedValue:Bool = true
//        
//        for i=0;i<self.quizzArray[answerToQuestion].codePassage.count;i += 1 {
//            
//            let indexPath = NSIndexPath(forRow: i, inSection: 0)
//            
//            let cell = self.passageTableView.cellForRowAtIndexPath(indexPath)
//
//            //print(cell!.textLabel!.text)
//            
//            if self.quizzArray[answerToQuestion].codePassage[i] != cell!.textLabel!.text {
//                
//                returnedValue = false
//                
//            }
//            
//        }
//        
//        self.selectedAnswers[answerToQuestion] = returnedValue
        
        if self.passageTableView.answerArray == self.quizzArray[answerToQuestion].codePassage {
            self.selectedAnswers[answerToQuestion] = true
            returnedValue = true
        }
        else {
            returnedValue = false
        }
        
        return returnedValue
        
    }
    
}

extension programmingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

extension programmingViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: String(indexPath.row))
        print(String(indexPath.row))
        cell.textLabel!.font = UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(15))
        
        if indexPath == currentIndexPath {
            
            cell.backgroundColor = nil
        }
        else {
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = cellTitles[indexPath.row]
            if (cell.textLabel!.text?.hasPrefix("//") == true) {
                cell.textLabel?.textColor = UIColor(red: 1/255, green: 121/255, blue: 111/255, alpha: 1.0)
            }else{
                cell.textLabel?.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            }
        }
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
}

extension programmingViewController: RearrangeDataSource {
    
    func moveObjectAtCurrentIndexPath(to indexPath: NSIndexPath) {
        
        guard let unwrappedCurrentIndexPath = currentIndexPath else { return }
        
        let object = cellTitles[unwrappedCurrentIndexPath.row]
        
        cellTitles.removeAtIndex(unwrappedCurrentIndexPath.row)
        cellTitles.insert(object, atIndex: indexPath.row)
    }

}