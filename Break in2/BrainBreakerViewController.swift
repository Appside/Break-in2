//
//  quizzPageViewController.swift
//  Break in2
//
//  Created by Jean-Charles Koch on 24/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import SCLAlertView
import Parse
import GoogleMobileAds
import SwiftSpinner

class BrainBreakerViewController: UIViewController, GADInterstitialDelegate {
    
    //Ad variables
    var interstitialAd:GADInterstitial!
    var testStarted:Bool = Bool()
    var AdBeforeClosing:Bool = false
    let defaults = NSUserDefaults.standardUserDefaults()
    var membershipType:String = String()
    
    //Other variables
    var backButton:UIButton = UIButton()
    var helpButton:UIButton = UIButton()
    var statusBarFrame:CGRect = CGRect()
    let majorMargin:CGFloat = 20
    let minorMargin:CGFloat = 10
    var backButtonHeight:CGFloat = CGFloat()
    var screenFrame:CGRect = CGRect()
    var brainBreakerLabel:UILabel = UILabel()
    var nextButton:UIButton = UIButton()
    var brainLogo:UIImageView = UIImageView()
    var flexibleHeight:CGFloat = CGFloat()
    var prizeLabel:UILabel = UILabel()
    var numberOfLives:Int = 2
    var life1:UIImageView = UIImageView()
    var life2:UIImageView = UIImageView()
    var life3:UIImageView = UIImageView()
    var timeRemaining:UILabel = UILabel()
    var welcomeMenu:UIView = UIView()
    var helpMenu:UIView = UIView()
    var mainView:UIView = UIView()
    var questionType:String = String()
    var passage:String = String()
    var question:String = String()
    var answers:[String] = [String]()
    var correctAnswer:Int = Int()
    var explanation:String = String()
    var attemptsRemaining:Int = Int()
    var currentPrize:String = String()
    var questionNumber:Int = Int()
    let swipeUIView:UIView = UIView()
    var swipeMenuHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    var swipeMenuBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
    var widthRatio:CGFloat = CGFloat()
    var heightRatio:CGFloat = CGFloat()
    let swipeMenuTopBar:UIView = UIView()
    let timeLabel:UILabel = UILabel()
    let descriptionSwipeLabel:UILabel = UILabel()
    var countSeconds:Int = Int()
    var countMinutes:Int = Int()
    var allowedSeconds:Int = Int()
    var allowedMinutes:Int = Int()
    let answerView:UIView = UIView()
    let questionView:UIView = UIView()
    let passageView:UIView = UIView()
    let passageLabel:UITextView = UITextView()
    let questionLabel:UITextView = UITextView()
    let submitButton:UILabel = UILabel()
    var quizzArray:[verbalQuestion] = [verbalQuestion]()
    var totalNumberOfQuestions:Int = 0
    var displayedQuestionIndex:Int = 0
    var selectedAnswers:[Int] = [Int]()
    var testEnded:Bool = false
    var timeTimer:NSTimer = NSTimer()
    var startTime:CFAbsoluteTime = CFAbsoluteTime()
    var time:Int = Int()
    let feebdackScreen:UIScrollView = UIScrollView()
    var scoreRatio:Float = Float()
    var isTestComplete:Bool = false
    var resultsUploaded:Bool = false
    var newLabel:String = String()
    var timer:NSTimer = NSTimer()
    var frameTop:UIView = UIView()
    var frameMid:UIView = UIView()
    var frameBottom:UIView = UIView()
    var brainBreakerAlreadySolved:Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Ad loading
        self.membershipType = defaults.objectForKey("Membership") as! String
        self.interstitialAd = self.createAndLoadInterstitial()
        self.testStarted = false
        self.questionLabel.userInteractionEnabled = false
        self.passageLabel.userInteractionEnabled = false
        
        //Size variables
        self.screenFrame = UIScreen.mainScreen().bounds
        self.statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.backButtonHeight = UIScreen.mainScreen().bounds.width/12
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        self.flexibleHeight = (height-(self.statusBarFrame.height+10*self.minorMargin+5.5*backButtonHeight))/3
        self.widthRatio = self.screenFrame.size.width / 414
        self.heightRatio = self.screenFrame.size.height / 736
        
        //Initialize timer
        self.allowedSeconds = 00
        self.allowedMinutes = self.defaults.integerForKey("MinutesToAnswerBrainBreaker")
        self.countSeconds = self.allowedSeconds
        self.countMinutes = self.allowedMinutes
        
        //Current Prize and BB variables
        self.questionType = self.defaults.objectForKey("BrainBreakerQuestionType") as? String ?? String()
        self.passage = self.defaults.objectForKey("BrainBreakerPassage") as? String ?? String()
        self.question = self.defaults.objectForKey("BrainBreakerQuestion") as? String ?? String()
        self.answers = self.defaults.objectForKey("BrainBreakerAnswers") as? [String] ?? [String]()
        self.correctAnswer = self.defaults.integerForKey("BrainBreakerCorrectAnswerIndex")
        self.explanation = self.defaults.objectForKey("BrainBreakerExplanation") as? String ?? String()
        self.attemptsRemaining = self.defaults.integerForKey("NoOfBrainBreakerLives")
        self.currentPrize = self.defaults.objectForKey("BrainBreakerTestPrize") as? String ?? String()
        self.questionNumber = self.defaults.integerForKey("BrainBreakerQuestionNumber")
        self.brainBreakerAlreadySolved = self.defaults.boolForKey("brainBreakerAnsweredCorrectly") as? Bool ?? Bool()
        
        //Background Image
        let backgroundImageView = UIImageView(frame: CGRectMake(0, 0, width, height))
        backgroundImageView.image = UIImage(named: "brainbreakerBG")
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
     
        //Back Button
        self.view.addSubview(self.backButton)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
        self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
        self.backButton.setImage(UIImage.init(named: "prevButton")!, forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: #selector(BrainBreakerViewController.backHome(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.backButton.clipsToBounds = true
        
        //Main Title
        self.view.addSubview(self.brainBreakerLabel)
        self.brainBreakerLabel.translatesAutoresizingMaskIntoConstraints = false
        let brainBreakerLabelCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let brainBreakerLabelTop:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        let brainBreakerLabelHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        let brainBreakerLabelWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-4*self.majorMargin - 2*self.backButtonHeight)
        self.brainBreakerLabel.addConstraints([brainBreakerLabelHeight, brainBreakerLabelWidth])
        self.view.addConstraints([brainBreakerLabelCenterX, brainBreakerLabelTop])
        let labelString:String = String("BRAIN BREAKER")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 6, length: NSString(string: labelString).length-6))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.turquoiseColor(), range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.brainBreakerLabel.attributedText = attributedString
        self.brainBreakerLabel.textAlignment = NSTextAlignment.Center
        
        //Help Button
        self.view.addSubview(self.helpButton)
        self.helpButton.translatesAutoresizingMaskIntoConstraints = false
        let helpButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -self.majorMargin)
        let helpButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        let helpButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        let helpButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        self.helpButton.addConstraints([helpButtonHeightConstraint, helpButtonWidthConstraint])
        self.view.addConstraints([helpButtonRightConstraint, helpButtonTopConstraint])
        self.helpButton.addTarget(self, action: #selector(BrainBreakerViewController.ShowHelpScreen(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.helpButton.clipsToBounds = true
        self.helpButton.layer.cornerRadius = self.screenFrame.width/24
        self.helpButton.layer.borderWidth = 2
        self.helpButton.layer.borderColor = UIColor.turquoiseColor().CGColor
        self.helpButton.setTitle("?", forState: UIControlState.Normal)
        self.helpButton.setTitleColor(UIColor.turquoiseColor(), forState: UIControlState.Normal)
        self.helpButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 24.0)

        //Add Welcome Menu
        self.view.addSubview(self.welcomeMenu)
        self.welcomeMenu.setConstraintsToSuperview(Int(self.statusBarFrame.height + 3*self.minorMargin + self.backButtonHeight), bottom: Int(3*self.minorMargin+1.5*self.backButtonHeight), left: 0, right: 0)
        
        //Next Button
        self.view.addSubview(self.nextButton)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        let nextButtonLabelBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -2*self.minorMargin)
        let nextButtonLabelHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight*1.5)
        let nextButtonLabelLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        let nextButtonLabelRight:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -self.majorMargin)
        self.view.addConstraints([nextButtonLabelBottom, nextButtonLabelLeft, nextButtonLabelRight])
        self.nextButton.addConstraints([nextButtonLabelHeight])
        self.nextButton.backgroundColor = UIColor.turquoiseColor()
        self.nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.nextButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.nextButton.setTitle("START", forState: UIControlState.Normal)
        self.nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.StartTest(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        //Brain Breaker Brain Logo
        self.welcomeMenu.addSubview(self.brainLogo)
        self.brainLogo.translatesAutoresizingMaskIntoConstraints = false
        let brainLogoCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.brainLogo, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let brainLogoTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainLogo, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
        let brainLogoHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainLogo, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 3*self.backButtonHeight)
        let brainLogoWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainLogo, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 3*self.backButtonHeight)
        self.brainLogo.addConstraints([brainLogoHeightConstraint, brainLogoWidthConstraint])
        self.welcomeMenu.addConstraints([brainLogoTopConstraint,brainLogoCenterX])
        self.brainLogo.image = UIImage.init(named: "brainbreakerBrainLogo")
        self.brainLogo.clipsToBounds = true
        
        //Split remaining height in 3 frames
        self.welcomeMenu.addSubview(self.frameTop)
        self.welcomeMenu.addSubview(self.frameMid)
        self.welcomeMenu.addSubview(self.frameBottom)
        self.frameTop.translatesAutoresizingMaskIntoConstraints = false
        self.frameMid.translatesAutoresizingMaskIntoConstraints = false
        self.frameBottom.translatesAutoresizingMaskIntoConstraints = false
        self.frameMid.alpha = 0.0
        
        //Frame 1
        let frameTopTopConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameTop, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 3*self.minorMargin+3*self.backButtonHeight)
        let frameTopLeftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameTop, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        let frameTopRightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameTop, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -self.majorMargin)
        self.welcomeMenu.addConstraints([frameTopTopConstraint,frameTopLeftConstraint,frameTopRightConstraint])
        let frameTopHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.frameTop, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.flexibleHeight)
        self.frameTop.addConstraint(frameTopHeight)
        
        //Frame 2
        let frameMidTopConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameMid, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 3*self.minorMargin+3*self.backButtonHeight+self.flexibleHeight)
        let frameMidLeftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameMid, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        let frameMidRightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameMid, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -self.majorMargin)
        self.view.addConstraints([frameMidTopConstraint,frameMidLeftConstraint,frameMidRightConstraint])
        let frameMidHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.frameMid, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.flexibleHeight)
        self.frameMid.addConstraint(frameMidHeight)

        //Frame 3
        let frameBottomTopConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameBottom, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 3*self.minorMargin+3*self.backButtonHeight+2*self.flexibleHeight)
        let frameBottomLeftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameBottom, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        let frameBottomRightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameBottom, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -self.majorMargin)
        self.welcomeMenu.addConstraints([frameBottomTopConstraint,frameBottomLeftConstraint,frameBottomRightConstraint])
        let frameBottomHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.frameBottom, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.flexibleHeight)
        self.frameBottom.addConstraint(frameBottomHeight)
        
        //Frame 1 -- Content
        self.frameTop.addSubview(self.prizeLabel)
        self.prizeLabel.setConstraintsToSuperview(Int(self.flexibleHeight)/2-50, bottom: Int(self.flexibleHeight)/2, left: 0, right: 0)
        self.prizeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        self.prizeLabel.text = self.currentPrize.uppercaseString
        self.prizeLabel.numberOfLines = 0
        self.prizeLabel.textAlignment = NSTextAlignment.Center
        self.prizeLabel.textColor = UIColor.turquoiseColor()
        let currentPrize:UILabel =  UILabel()
        self.frameTop.addSubview(currentPrize)
        currentPrize.setConstraintsToSuperview(Int(self.flexibleHeight)/2, bottom: Int(self.flexibleHeight)/2-20, left: 0, right: 0)
        currentPrize.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        currentPrize.text = "CURRENT PRIZE"
        currentPrize.textAlignment = NSTextAlignment.Center
        currentPrize.textColor = UIColor.turquoiseColor()
        let borderBottom:UIView = UIView()
        self.frameTop.addSubview(borderBottom)
        borderBottom.setConstraintsToSuperview(Int(self.flexibleHeight)-1, bottom: 0, left: 0, right: 0)
        borderBottom.backgroundColor = UIColor.turquoiseColor()
        
        //Frame 2 -- Content
        let livesUIView:UIView = UIView()
        self.frameMid.addSubview(livesUIView)
        livesUIView.setConstraintsToSuperview(Int(self.flexibleHeight)/2-30, bottom: Int(self.flexibleHeight)/2, left: 0, right: 0)
        
        livesUIView.addSubview(self.life2)
        self.life2.translatesAutoresizingMaskIntoConstraints = false
        let life2CenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let life2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        livesUIView.addConstraints([life2CenterX,life2Top])
        let life2Width:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        let life2Height:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        self.life2.addConstraints([life2Width,life2Height])
        self.life2.clipsToBounds = true
        
        livesUIView.addSubview(self.life1)
        self.life1.translatesAutoresizingMaskIntoConstraints = false
        let life1CenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: -self.backButtonHeight/1.3-2*self.minorMargin)
        let life1Top:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        livesUIView.addConstraints([life1CenterX,life1Top])
        let life1Width:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        let life1Height:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        self.life1.addConstraints([life1Width,life1Height])
        self.life1.clipsToBounds = true
        
        livesUIView.addSubview(self.life3)
        self.life3.translatesAutoresizingMaskIntoConstraints = false
        let life3CenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: self.backButtonHeight/1.3+2*self.minorMargin)
        let life3Top:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        livesUIView.addConstraints([life3CenterX,life3Top])
        let life3Width:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        let life3Height:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        self.life3.addConstraints([life3Width,life3Height])
        self.life3.clipsToBounds = true
        
        if self.attemptsRemaining == 3 {
            self.life1.image = UIImage(named: "tickSelectedBrainbreaker")
            self.life2.image = UIImage(named: "tickSelectedBrainbreaker")
            self.life3.image = UIImage(named: "tickSelectedBrainbreaker")
        } else if self.attemptsRemaining == 2 {
            self.life1.image = UIImage(named: "tickSelectedBrainbreaker")
            self.life2.image = UIImage(named: "tickSelectedBrainbreaker")
            self.life3.image = UIImage(named: "crossSelected")
        } else if self.attemptsRemaining == 1 {
            self.life1.image = UIImage(named: "tickSelectedBrainbreaker")
            self.life2.image = UIImage(named: "crossSelected")
            self.life3.image = UIImage(named: "crossSelected")
        } else {
            self.life1.image = UIImage(named: "crossSelected")
            self.life2.image = UIImage(named: "crossSelected")
            self.life3.image = UIImage(named: "crossSelected")
        }
        
        let attemptsLabel:UILabel =  UILabel()
        self.frameMid.addSubview(attemptsLabel)
        attemptsLabel.setConstraintsToSuperview(Int(self.flexibleHeight)/2, bottom: Int(self.flexibleHeight)/2-30, left: 0, right: 0)
        attemptsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        attemptsLabel.text = "NUMBER OF ATTEMPTS REMAINING"
        attemptsLabel.textAlignment = NSTextAlignment.Center
        attemptsLabel.textColor = UIColor.turquoiseColor()
        let borderBottom2:UIView = UIView()
        self.frameMid.addSubview(borderBottom2)
        borderBottom2.setConstraintsToSuperview(Int(self.flexibleHeight)-1, bottom: 0, left: 0, right: 0)
        borderBottom2.backgroundColor = UIColor.turquoiseColor()
        
        //Frame 3 -- Content
        self.frameBottom.addSubview(self.timeRemaining)
        self.timeRemaining.setConstraintsToSuperview(Int(self.flexibleHeight)/2-25, bottom: Int(self.flexibleHeight)/2, left: 0, right: 0)
        self.timeRemaining.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        self.timeRemaining.text = "00:00:00"
        self.timeRemaining.textAlignment = NSTextAlignment.Center
        self.timeRemaining.textColor = UIColor.turquoiseColor()
        let timeLabel:UILabel =  UILabel()
        self.frameBottom.addSubview(timeLabel)
        timeLabel.setConstraintsToSuperview(Int(self.flexibleHeight)/2, bottom: Int(self.flexibleHeight)/2-25, left: 0, right: 0)
        timeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        timeLabel.text = "TIME REMAINING BEFORE CLOSING"
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.textColor = UIColor.turquoiseColor()
        
        //Set up Help Menu
        self.helpMenu.alpha = 0.0
        self.view.addSubview(self.helpMenu)
        self.helpMenu.setConstraintsToSuperview(Int(self.statusBarFrame.height + 3*self.minorMargin + self.backButtonHeight), bottom: Int(2*self.minorMargin+1.5*self.backButtonHeight), left: 0, right: 0)
        
        let pageTitle:UILabel = UILabel()
        self.helpMenu.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        let pageTitleCenterX:NSLayoutConstraint = NSLayoutConstraint(item: pageTitle, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let pageTitleTop:NSLayoutConstraint = NSLayoutConstraint(item: pageTitle, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.flexibleHeight-20)
        let pageTitleLeft:NSLayoutConstraint = NSLayoutConstraint(item: pageTitle, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 4*self.minorMargin)
        let pageTitleRight:NSLayoutConstraint = NSLayoutConstraint(item: pageTitle, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -4*self.minorMargin)
        self.helpMenu.addConstraints([pageTitleCenterX,pageTitleTop,pageTitleLeft,pageTitleRight])
        let pageTitleHeight:NSLayoutConstraint = NSLayoutConstraint(item: pageTitle, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        pageTitle.addConstraint(pageTitleHeight)
        
        pageTitle.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        pageTitle.textAlignment = NSTextAlignment.Center
        pageTitle.textColor = UIColor.turquoiseColor()
        pageTitle.text = "What is the BrainBreaker?"
        
        let explanation:UILabel = UILabel()
        self.helpMenu.addSubview(explanation)
        explanation.translatesAutoresizingMaskIntoConstraints = false
        let explanationCenterX:NSLayoutConstraint = NSLayoutConstraint(item: explanation, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let explanationTop:NSLayoutConstraint = NSLayoutConstraint(item: explanation, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.flexibleHeight+50)
        let explanationLeft:NSLayoutConstraint = NSLayoutConstraint(item: explanation, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 4*self.minorMargin)
        let explanationRight:NSLayoutConstraint = NSLayoutConstraint(item: explanation, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -4*self.minorMargin)
        self.helpMenu.addConstraints([explanationCenterX,explanationTop,explanationLeft,explanationRight])
        let explanationHeight:NSLayoutConstraint = NSLayoutConstraint(item: explanation, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.flexibleHeight)
        explanation.addConstraint(explanationHeight)

        explanation.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        explanation.textAlignment = NSTextAlignment.Center
        explanation.textColor = UIColor.turquoiseColor()
        explanation.numberOfLines = 0
        explanation.text = "The BrainBreaker is a challenge giving you the chance to win great prizes. For each new challenge you will get one chance to answer correctly, with 3 additional chances if you opted for our Premium version."
        
        //Set Up QUestion Menu
        self.mainView.alpha = 0.0
        self.swipeUIView.alpha = 0.0
        
        self.view.addSubview(self.mainView)
        self.mainView.setConstraintsToSuperview(Int(self.statusBarFrame.height + 3*self.minorMargin + self.backButtonHeight), bottom: Int(2*self.minorMargin+1.5*self.backButtonHeight), left: Int(self.majorMargin), right: Int(self.majorMargin))
        
        self.view.addSubview(self.swipeUIView)
        self.swipeUIView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeMenuHeightConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 450*self.heightRatio)
        self.swipeUIView.addConstraint(self.swipeMenuHeightConstraint)
        self.swipeMenuBottomConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 380*self.heightRatio)
        let leftMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        let rightMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant:-self.majorMargin)
        self.view.addConstraints([leftMargin,rightMargin,self.swipeMenuBottomConstraint])
        self.swipeUIView.backgroundColor = UIColor.whiteColor()
        self.swipeUIView.layer.cornerRadius = 8.0
        var swipeUpGesture:UITapGestureRecognizer = UITapGestureRecognizer()
        swipeUpGesture = UITapGestureRecognizer.init(target: self, action: #selector(BrainBreakerViewController.SwipeMenu(_:)))
        self.swipeUIView.addGestureRecognizer(swipeUpGesture)
        
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
        self.swipeMenuTopBar.addSubview(self.descriptionSwipeLabel)
        self.descriptionSwipeLabel.setConstraintsToSuperview(Int(30*self.heightRatio), bottom: 0, left: 0, right: 0)
        self.descriptionSwipeLabel.text = "Tap for Answers"
        self.descriptionSwipeLabel.font = UIFont(name: "HelveticaNeue-Medium",size: self.view.getTextSize(14))
        self.descriptionSwipeLabel.textAlignment = NSTextAlignment.Center
        self.descriptionSwipeLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.descriptionSwipeLabel.userInteractionEnabled = true
        self.swipeUIView.addSubview(self.answerView)
        self.answerView.translatesAutoresizingMaskIntoConstraints = false
        self.answerView.setConstraintsToSuperview(Int(80*self.heightRatio), bottom: Int(70*self.heightRatio), left: 0, right: 0)
        self.mainView.addSubview(self.questionView)
        self.mainView.addSubview(self.passageView)
        self.questionView.translatesAutoresizingMaskIntoConstraints = false
        self.passageView.translatesAutoresizingMaskIntoConstraints = false
        let questionViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let questionViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let questionViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.mainView.addConstraints([questionViewTop,questionViewRight,questionViewLeft])
        let qViewHeight = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 90*self.heightRatio)
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
        layer1.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        layer2.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        layer1.layer.cornerRadius = 8.0
        let passageText:UILabel = UILabel()
        layer2.addSubview(passageText)
        passageText.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        passageText.textColor = UIColor.whiteColor()
        passageText.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(16))
        passageText.textAlignment = NSTextAlignment.Center
        passageText.text = "QUESTION"
        self.passageView.addSubview(self.passageLabel)
        self.passageLabel.setConstraintsToSuperview(Int(50*self.heightRatio), bottom: Int(40*self.heightRatio), left: Int(40*self.widthRatio), right: Int(40*self.widthRatio))
        self.passageLabel.textColor = UIColor.blackColor()
        self.passageView.backgroundColor = UIColor.whiteColor()
        self.passageLabel.font = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(16))
        self.passageLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        self.passageView.layer.cornerRadius = 10.0
        self.passageLabel.textAlignment = NSTextAlignment.Justified
        self.questionView.addSubview(self.questionLabel)
        self.questionLabel.setConstraintsToSuperview(Int(10*self.heightRatio), bottom: 0, left: Int(15*self.widthRatio), right: Int(15*self.widthRatio))
        self.questionLabel.textColor = UIColor.whiteColor()
        self.questionLabel.font = UIFont(name: "HelveticaNeue-Bold",size: self.view.getTextSize(17))
        self.questionLabel.textAlignment = NSTextAlignment.Center
        self.questionLabel.backgroundColor = UIColor(white: 0, alpha: 0)
        self.questionView.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.questionView.layer.cornerRadius = 8.0
        let passageViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 100*self.heightRatio)
        let passageViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let passageViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let passageViewBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -15)
        self.mainView.addConstraints([passageViewTop,passageViewRight,passageViewLeft,passageViewBottom])
        let nextUIView:UIView = UIView()
        self.swipeUIView.addSubview(nextUIView)
        nextUIView.translatesAutoresizingMaskIntoConstraints = false
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.submitButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.submitButton.textColor = UIColor.whiteColor()
        self.submitButton.textAlignment = NSTextAlignment.Center
        self.submitButton.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        self.submitButton.text = "Submit Answer"
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 380*self.heightRatio)
        let rightLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20)*self.widthRatio)
        let leftLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20)*self.widthRatio)
        self.swipeUIView.addConstraints([topLabelMargin,rightLabelMargin,leftLabelMargin])
        let heightLabelConstraint:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 50*self.heightRatio)
        nextUIView.addConstraint(heightLabelConstraint)
        nextUIView.addSubview(self.submitButton)
        self.submitButton.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        let tapGestureNext:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("nextQuestion:"))
        tapGestureNext.numberOfTapsRequired = 1
        nextUIView.addGestureRecognizer(tapGestureNext)
        
        //Set answersArray
        var answerIndex:Int = 0
        for answerIndex=0;answerIndex<=self.totalNumberOfQuestions;answerIndex++ {
            let fixedNumber:Int = 20
            self.selectedAnswers.append(fixedNumber)
        }
        
        //Display questions
        self.displayedQuestionIndex = 0
        let newQuestion:verbalQuestion = verbalQuestion()
        //Assign values to the newQuestion
        newQuestion.questionType = self.questionType
        newQuestion.passage = self.passage
        newQuestion.question = self.question
        newQuestion.answers = self.answers
        newQuestion.correctAnswer = self.correctAnswer
        newQuestion.explanation = self.explanation
        self.quizzArray.append(newQuestion)
        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
        
    }
    
    func backHome(sender:UITapGestureRecognizer) {

        let alertMessage:String = "Are you sure you want to return home?"
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let backAlert = SCLAlertView(appearance: appearance)
        backAlert.addButton("Yes", target:self, selector:Selector("goBack"))
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
            self.timer.invalidate()
            self.performSegueWithIdentifier("backHomeSegue", sender: nil)
            print("Ad wasn't ready")
        }
        
    }
    
    func ShowHelpScreen(sender:UITapGestureRecognizer) {

        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.welcomeMenu.alpha = 0.0
            self.helpMenu.alpha = 1.0
            self.helpButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
            self.helpButton.addTarget(self, action: #selector(BrainBreakerViewController.HideHelpScreen(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.helpButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.helpButton.backgroundColor = UIColor.turquoiseColor()
            
            }, completion: nil)
        
    }
    
    func HideHelpScreen(sender:UITapGestureRecognizer) {
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.welcomeMenu.alpha = 1.0
            self.helpMenu.alpha = 0.0
            self.helpButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
            self.helpButton.addTarget(self, action: #selector(BrainBreakerViewController.ShowHelpScreen(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.helpButton.setTitleColor(UIColor.turquoiseColor(), forState: UIControlState.Normal)
            self.helpButton.backgroundColor = UIColor.clearColor()
            
            }, completion: nil)
        
    }
    
    func StartTest(sender:UITapGestureRecognizer) {

        let alertMessage:String = "You are about to take a chance at the Brain Breaker. Are you ready ?"
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let backAlert = SCLAlertView(appearance: appearance)
        backAlert.addButton("Yes", target:self, selector:Selector("setUpTest"))
        backAlert.showTitle(
            "Start the Challenge", // Title of view
            subTitle: alertMessage, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Cancel", // Optional button value, default: ""
            style: .Error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
            colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
            colorTextButton: 0xFFFFFF
        )
        
    }
    
    func setUpTest() {
        
        if (self.attemptsRemaining > 0) {
            
            self.attemptsRemaining--
            self.defaults.setInteger(self.attemptsRemaining, forKey: "NoOfBrainBreakerLives")
            
            if self.interstitialAd.isReady && self.membershipType == "Free" {
                self.interstitialAd.presentFromRootViewController(self)
            } else {
                print("Ad wasn't ready")
                self.testStarted = true
                self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
            }
            
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                self.welcomeMenu.alpha = 0.0
                self.helpMenu.alpha = 0.0
                self.helpButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
                self.helpButton.alpha = 0.0
                self.nextButton.alpha = 0.0
                self.mainView.alpha = 1.0
                self.swipeUIView.alpha = 1.0
                
                }, completion: nil)
            
        } else {
            
            var alertMessage:String = String()
            alertMessage = "You have no attempts remaining"
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let backAlert = SCLAlertView(appearance: appearance)
            backAlert.addButton("Return Home", target:self, selector:Selector("goBack"))
            backAlert.showTitle(
                "Sorry", // Title of view
                subTitle: alertMessage, // String of view
                duration: 0.0, // Duration to show before closing automatically, default: 0.0
                completeText: "Cancel", // Optional button value, default: ""
                style: .Error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
                colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
                colorTextButton: 0xFFFFFF
            )
        }
        
    }
    
    func SwipeMenu(sender: UITapGestureRecognizer) {
     
        UIView.animateWithDuration(1, animations: {
            if(self.swipeMenuBottomConstraint.constant == 380*self.heightRatio) {
                self.swipeMenuBottomConstraint.constant = 5*self.heightRatio
                self.view.layoutIfNeeded()
                self.descriptionSwipeLabel.text = "Tap here for Question"
                self.mainView.alpha = 0.0
            }
            else if (self.swipeMenuBottomConstraint.constant == 5*self.heightRatio) {
                self.swipeMenuBottomConstraint.constant = 380*self.heightRatio
                self.view.layoutIfNeeded()
                self.descriptionSwipeLabel.text = "Tap here for Answers"
                self.mainView.alpha = 1.0
            }
            }, completion: nil)
        
    }
    
    func displayQuestion(arrayOfQuestions:[verbalQuestion], indexQuestion:Int) {
        
        self.passageLabel.text = self.quizzArray[indexQuestion].passage
        let questionText:String = arrayOfQuestions[indexQuestion].question
        self.questionLabel.text = questionText
        for answerSubView in self.answerView.subviews {
            answerSubView.removeFromSuperview()
        }
        let arrayAnswers:[String] = self.quizzArray[indexQuestion].answers
        let buttonHeight:Int = Int(50*self.heightRatio)
        var i:Int = 0
        
        for i=0; i<arrayAnswers.count;i++ {
            let answerUIButton:UIView = UIView()
            let answerUILabel:UILabel = UILabel()
            let answerNumber:UIButton = UIButton()
            answerUIButton.translatesAutoresizingMaskIntoConstraints = false
            answerUILabel.translatesAutoresizingMaskIntoConstraints = false
            answerNumber.translatesAutoresizingMaskIntoConstraints = false
            self.answerView.addSubview(answerUIButton)
            answerUIButton.addSubview(answerUILabel)
            answerUIButton.addSubview(answerNumber)
            answerNumber.tag = i
            answerNumber.setTitle(String(i+1), forState: .Normal)
            answerNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            answerNumber.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            answerNumber.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            answerUILabel.text = String(arrayAnswers[i])
            answerUILabel.textAlignment = NSTextAlignment.Center
            answerUILabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            answerUILabel.numberOfLines = 0
            answerUILabel.adjustsFontSizeToFitWidth = true
            answerUIButton.backgroundColor = UIColor.whiteColor()
            answerUILabel.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            answerUIButton.layer.borderWidth = 3.0
            answerUIButton.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
            
            //Set constraints to answerViews
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i)*(CGFloat(buttonHeight)+10*self.heightRatio))
            let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20)*self.widthRatio)
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20)*self.widthRatio)
            self.answerView.addConstraints([topMargin,rightMargin,leftMargin])
            
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: CGFloat(buttonHeight))
            answerUIButton.addConstraint(heightConstraint)
            
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
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("answerIsSelected:"))
            answerUIButton.addGestureRecognizer(tapGesture)
        }
    }
    
    func answerIsSelected(gesture:UITapGestureRecognizer) {
        let buttonTapped:UIView? = gesture.view
        if let actualButton = buttonTapped {
            for singleView in self.answerView.subviews {
                for labelView1 in singleView.subviews {
                    if let labelsView = labelView1 as? UILabel {
                        labelsView.backgroundColor = UIColor.whiteColor()
                        labelsView.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                    }
                }
            }
            UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                for labels in actualButton.subviews {
                    if let labelView = labels as? UILabel {
                        labelView.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                        labelView.textColor = UIColor.whiteColor()
                    }
                    if let btnView = labels as? UIButton {
                        self.selectedAnswers[self.displayedQuestionIndex] = Int(btnView.tag)
                    }
                }
                }, completion: nil)
        }
    }
    
    func updateTimer() {
        if self.testEnded {
            self.displayedQuestionIndex = self.totalNumberOfQuestions
            if self.selectedAnswers[self.displayedQuestionIndex]==20 {
                self.selectedAnswers[self.displayedQuestionIndex]=21
            }
            self.nextQuestion(UITapGestureRecognizer(target: self, action: Selector("nextQuestion:")))
            self.timeTimer.invalidate()
        }
        else {
            if (self.countSeconds-1<0) {
                if (self.countMinutes+self.countSeconds==0) {
                    self.timeTimer.invalidate()
                }
                else {
                    self.countMinutes--
                    self.countSeconds = 59
                }
            }
            else {
                self.countSeconds--
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
    
    func feedbackScreen() {
        
        self.timeTimer.invalidate()
        self.timer.invalidate()
        
        UIView.animateWithDuration(0.75, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.welcomeMenu.alpha = 1.0
            self.helpMenu.alpha = 0.0
            self.helpButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
            self.helpButton.alpha = 0.0
            self.nextButton.alpha = 1.0
            self.mainView.alpha = 0.0
            self.swipeUIView.alpha = 0.0
            self.frameTop.alpha = 1.0
            self.frameMid.alpha = 1.0
            self.frameBottom.alpha = 0.0
            
        }, completion: nil)
        
        self.nextButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
        self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.goBackHome(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.nextButton.setTitle("Return Home", forState: UIControlState.Normal)
        
        for view in self.frameMid.subviews {
            view.removeFromSuperview()
        }
        let attemptsLabel:UILabel =  UILabel()
        self.frameMid.addSubview(attemptsLabel)
        attemptsLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        attemptsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        attemptsLabel.textAlignment = NSTextAlignment.Center
        attemptsLabel.textColor = UIColor.turquoiseColor()
        attemptsLabel.numberOfLines = 0
        var feedbackDescription:String = "Error - No feedback available"
        
        if self.quizzArray[0].correctAnswer == self.selectedAnswers[0] {
        
            feedbackDescription = "Well done, you are now in with a chance of winning the Brain Breaker prize! The winner(s) will be announced on our social media pages and we will be in touch by email."
        
        } else {
        
            feedbackDescription = "Unlucky, please try again to be in with a chance of winning a great prize!\n\nJust to let you know, if you sign up for our premium membership, you are allowed up to three attempts every new Question."
        }

        attemptsLabel.text = feedbackDescription
        
        for view in self.frameTop.subviews {
            view.removeFromSuperview()
        }
        let resultsLabel:UILabel =  UILabel()
        self.frameTop.addSubview(resultsLabel)
        resultsLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        resultsLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        resultsLabel.textAlignment = NSTextAlignment.Center
        resultsLabel.textColor = UIColor.turquoiseColor()
        resultsLabel.numberOfLines = 0
        var resultsDescription:String = "Error - No results available"
        
        if self.quizzArray[0].correctAnswer == self.selectedAnswers[0] {
            
            resultsDescription = "Correct Answer!"
            
        } else {
            
            resultsDescription = "Wrong Answer!"
        }
        
        resultsLabel.text = resultsDescription
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //Call tutoNextPage
        let dateBB = NSDate().dateByAddingTimeInterval(0)
        self.timer = NSTimer(fireDate: dateBB, interval: 1, target: self, selector: "brainBreakerTimer", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
        
        if self.brainBreakerAlreadySolved == true {
            
            for view in self.frameMid.subviews {
                view.removeFromSuperview()
            }

            let livesUIView:UIView = UIView()
            self.frameMid.addSubview(livesUIView)
            livesUIView.setConstraintsToSuperview(15, bottom: Int(self.flexibleHeight)/2-40, left: 0, right: 0)
            
            let Image1:UIImageView =  UIImageView()
            self.frameMid.addSubview(Image1)
            Image1.translatesAutoresizingMaskIntoConstraints = false
            let Image1CenterX:NSLayoutConstraint = NSLayoutConstraint(item: Image1, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            let Image1Top:NSLayoutConstraint = NSLayoutConstraint(item: Image1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            self.frameMid.addConstraints([Image1CenterX,Image1Top])
            let Image1Width:NSLayoutConstraint = NSLayoutConstraint(item: Image1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
            let Image1Height:NSLayoutConstraint = NSLayoutConstraint(item: Image1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
            Image1.addConstraints([Image1Width,Image1Height])
            Image1.clipsToBounds = true
            Image1.image = UIImage(named: "tickSelected")
            
            let Label1:UILabel =  UILabel()
            self.frameMid.addSubview(Label1)
            Label1.setConstraintsToSuperview(Int(self.flexibleHeight)/2-30, bottom: Int(self.flexibleHeight)/2, left: 0, right: 0)
            Label1.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
            Label1.textAlignment = NSTextAlignment.Center
            Label1.textColor = UIColor.turquoiseColor()
            Label1.numberOfLines = 0
            Label1.text = "Congratulations !"

            let Label2:UILabel =  UILabel()
            self.frameMid.addSubview(Label2)
            Label2.setConstraintsToSuperview(Int(self.flexibleHeight)/2, bottom: 10, left: 0, right: 0)
            Label2.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            Label2.textAlignment = NSTextAlignment.Center
            Label2.textColor = UIColor.turquoiseColor()
            Label2.numberOfLines = 0
            Label2.text = "Results will be showed on our Social Media pages soon and we will get in touch by email with the winners."
            
            self.nextButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
            self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.goBackHome(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.nextButton.setTitle("Return Home", forState: UIControlState.Normal)
            
            self.frameMid.alpha = 1.0
            
        } else {
            
            self.frameMid.alpha = 1.0
            
        }
        
    }
    
    func brainBreakerTimer(){
        
        startTime = CFAbsoluteTimeGetCurrent()
        let initialTime: NSDate = defaults.objectForKey("BrainBreakerExpirationDate") as! NSDate
        let diff:CFTimeInterval = initialTime.timeIntervalSinceReferenceDate - startTime
        self.time = Int(diff)
        
        if self.time > 0 {
            let newHour:String = String(format: "%02d", (self.time / 3600))
            let newMin:String = String(format: "%02d", (self.time % 3600) / 60)
            let newSec:String = String(format: "%02d", (self.time % 3600) % 60)
            self.newLabel = "\(newHour) : \(newMin) : \(newSec)"
            self.timeRemaining.text = self.newLabel
            
        }else{
            
            self.frameTop.alpha = 0.0
            self.frameMid.alpha = 1.0
            self.frameBottom.alpha = 0.0
            self.nextButton.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
            self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.goBackHome(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.nextButton.setTitle("Return Home", forState: UIControlState.Normal)
            
            for view in self.frameMid.subviews {
                view.removeFromSuperview()
            }
            let attemptsLabel:UILabel =  UILabel()
            self.frameMid.addSubview(attemptsLabel)
            attemptsLabel.setConstraintsToSuperview(Int(self.flexibleHeight)/2-25, bottom: Int(self.flexibleHeight)/2-25, left: 0, right: 0)
            attemptsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            attemptsLabel.text = "Current Brain Breaker Ended, New Question Coming Soon!".uppercaseString
            attemptsLabel.textAlignment = NSTextAlignment.Center
            attemptsLabel.textColor = UIColor.turquoiseColor()
            attemptsLabel.numberOfLines = 0
            
            self.timer.invalidate()
            self.timeTimer.invalidate()
            
        }
        
    }
    
    func goBackHome(sender:UITapGestureRecognizer) {

        self.goBack()

    }
    
    func nextQuestion(gesture:UITapGestureRecognizer) {
        
        if self.selectedAnswers[self.displayedQuestionIndex] == 20 {
            let exitAlert = SCLAlertView()
            exitAlert.showError("No Answer Selected", subTitle: "Please Select An Answer Before Proceeding")
        }
        else {
            if self.displayedQuestionIndex + 1 > self.totalNumberOfQuestions {
                if self.resultsUploaded==false {
                    //Stop Timer
                    self.timeTimer.invalidate()
                    //Upload Results to Parse
                    var nbCorrectAnswers:Int = 0
                    if self.quizzArray[0].correctAnswer == self.selectedAnswers[0] {
                        nbCorrectAnswers++
                        self.defaults.setBool(true, forKey: "brainBreakerAnsweredCorrectly")
                    }
                    SwiftSpinner.show("Saving Results")
                    let currentUser = PFUser.currentUser()!
                    let query = PFQuery(className: PF_USER_CLASS_NAME)
                    let username = currentUser.username
                    query.whereKey(PF_USER_USERNAME, equalTo: username!)
                    query.getFirstObjectInBackgroundWithBlock({ (userBB: PFObject?, error: NSError?) -> Void in
                        
                        if error == nil {
                            
                            let analytics = PFObject(className: PF_BRAINBREAKER_A_CLASS_NAME)
                            analytics[PF_BRAINBREAKER_A_EMAIL] = userBB![PF_USER_EMAILCOPY]
                            analytics[PF_BRAINBREAKER_A_FULLNAME] = userBB![PF_USER_FULLNAME]
                            analytics[PF_BRAINBREAKER_A_Q_NUMBER] = self.questionNumber
                            analytics[PF_BRAINBREAKER_A_ANSWER_CORRECT] = nbCorrectAnswers
                            
                            analytics.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                                if error == nil {
                                    
                                    SwiftSpinner.show("Answer Submitted", animated: false).addTapHandler({
                                        SwiftSpinner.hide()
                                        self.resultsUploaded = true
                                        self.feedbackScreen()
                                        }, subtitle: "Tap to proceed to feedback")
                                    
                                } else {
                                    
                                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                                        
                                        self.attemptsRemaining++
                                        self.defaults.setInteger(self.attemptsRemaining, forKey: "NoOfBrainBreakerLives")
                                        self.goBack()
                                        SwiftSpinner.hide()
                                        
                                        }, subtitle: "You will not lose a life. Tap to return home.")
                                    
                                }
                            })
                            
                        }else{
                            
                            SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                                
                                self.attemptsRemaining++
                                self.defaults.setInteger(self.attemptsRemaining, forKey: "NoOfBrainBreakerLives")
                                self.goBack()
                                SwiftSpinner.hide()
                                
                                }, subtitle: "You will not lose a life. Tap to return home.")
                            
                        }
                        
                    })
                    
                }else {
                    self.feedbackScreen()
                }
            }
                //Continue to the next question
            else {
                UIView.animateWithDuration(1, animations: {
                    self.swipeMenuBottomConstraint.constant = 380*self.heightRatio
                    self.view.layoutIfNeeded()
                    self.passageView.alpha = 1.0
                    self.descriptionSwipeLabel.text = "Tap for Answers"
                    }, completion: nil)
                self.displayedQuestionIndex++
                if self.displayedQuestionIndex==self.totalNumberOfQuestions{
                    //Switch Button text to "Complete"
                    self.submitButton.text = "Complete Test"
                }
                self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
            }
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: AD_ID_BRAINBREAKER)
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
            self.timer.invalidate()
            self.performSegueWithIdentifier("backHomeSegue", sender: nil)
        } else {
            if self.testStarted == false {
                self.testStarted = true
                self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(BrainBreakerViewController.updateTimer), userInfo: nil, repeats: true)
            } else if self.testStarted == true {
                self.testStarted = false
                self.nextQuestion(UITapGestureRecognizer())
            }
        }
    }
    
}
    