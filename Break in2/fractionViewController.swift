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


class fractionsViewController: QuestionViewController, UIScrollViewDelegate, GADInterstitialDelegate {
    
    //Ad variables
    var interstitialAd:GADInterstitial!
    var testStarted:Bool = Bool()
    var AdBeforeClosing:Bool = false
    
    //Declare variables
    let backgroungUIView:UIView = UIView()
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
    var quizzArray:[fractionsQuestion] = [fractionsQuestion]()
    var displayedQuestionIndex:Int = 0
    var totalNumberOfQuestions:Int = 29
    var allowedSeconds:Int = 00
    var allowedMinutes:Int = 15
    var countSeconds:Int = Int()
    var countMinutes:Int = Int()
    let nextButton:UILabel = UILabel()
    var selectedAnswers:[Int] = [Int]()
    var qViewHeight:NSLayoutConstraint = NSLayoutConstraint()
    let feebdackScreen:UIScrollView = UIScrollView()
    var scoreRatio:Float = Float()
    var isTestComplete:Bool = false
    var resultsUploaded:Bool = false
    var testEnded:Bool = false
    var arrayOperation:[String] = [String]()
    
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
    
    //ViewDidLoad call
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interstitialAd = self.createAndLoadInterstitial()
        self.testStarted = false
        
        //Screen size and constraints
        let screenFrame:CGRect = UIScreen.mainScreen().bounds
        self.widthRatio = screenFrame.size.width / 414
        self.heightRatio = screenFrame.size.height / 736
        
        //Initialize difficulty level
        self.setDifficultyLevel()
        
        //Initialize timer
        self.countSeconds = self.allowedSeconds
        self.countMinutes = self.allowedMinutes
        
        //Initialize backgroun UIView
        self.view.addSubview(self.backgroungUIView)
        self.backgroungUIView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "hexagonBG")
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        self.backgroungUIView.addSubview(imageViewBackground)
        self.backgroungUIView.sendSubviewToBack(imageViewBackground)
        
        //Initialize back home button
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
        menuBackImageVIew.image = UIImage(named: "prevButton")
        menuBackImageVIew.translatesAutoresizingMaskIntoConstraints = false
        self.menuBackButton.addSubview(menuBackImageVIew)
        let arrowTop:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant:0)
        let arrowLeft:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant:0)
        let arrowHeight:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30*self.heightRatio)
        let arrowWidth:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35*self.heightRatio)
        self.menuBackButton.addConstraints([arrowTop,arrowLeft])
        menuBackImageVIew.addConstraints([arrowHeight,arrowWidth])
        let tapGestureBackHome:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("backHome:"))
        tapGestureBackHome.numberOfTapsRequired = 1
        self.menuBackButton.addGestureRecognizer(tapGestureBackHome)
        
        //Initialize questionNumber Label
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
        let swipeMenuTopBarHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30*self.heightRatio)
        
        self.swipeMenuTopBar.addConstraint(swipeMenuTopBarHeight)
        self.swipeMenuTopBar.addSubview(self.timeLabel)
        self.timeLabel.text = String(format: "%02d", self.countMinutes) + " : " + String(format: "%02d", self.countSeconds)
        self.timeLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.timeLabel.font = UIFont(name: "HelveticaNeue-Bold",size: self.view.getTextSize(18))
        self.timeLabel.textAlignment = NSTextAlignment.Center
        self.timeLabel.textColor = UIColor.redColor()
        self.timeLabel.userInteractionEnabled = true
        
        //Initialize mainView and answerView
        self.view.addSubview(self.mainView)
        self.mainView.setConstraintsToSuperview(Int(75*self.heightRatio), bottom: Int(130*self.heightRatio), left: Int(20*self.widthRatio), right: Int(20*self.widthRatio))
        
        //Create nextButton
        let nextUIView:UIView = UIView()
        self.swipeUIView.addSubview(nextUIView)
        nextUIView.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.nextButton.textColor = UIColor.whiteColor()
        self.nextButton.textAlignment = NSTextAlignment.Center
        self.nextButton.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        self.nextButton.text = "Next"
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 50*self.heightRatio)
        let rightLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20)*self.widthRatio)
        let leftLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20)*self.widthRatio)
        self.swipeUIView.addConstraints([topLabelMargin,rightLabelMargin,leftLabelMargin])
        let heightLabelConstraint:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 50*self.heightRatio)
        nextUIView.addConstraint(heightLabelConstraint)
        nextUIView.addSubview(self.nextButton)
        self.nextButton.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        let tapGestureNext:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("nextQuestion:"))
        tapGestureNext.numberOfTapsRequired = 1
        nextUIView.addGestureRecognizer(tapGestureNext)
        
        //Set answersArray
        var answerIndex:Int = 0
        let fixedNumber:Int = 20
        for answerIndex=0;answerIndex<=self.totalNumberOfQuestions;answerIndex++ {
            self.selectedAnswers.append(fixedNumber)
        }
        
        //Generate random questions for the test
        var questionNew:Int = Int()
        for questionNew=0;questionNew<=self.totalNumberOfQuestions;questionNew++ {
            self.addNewQuestion()
        }
        
        //Display first question
        self.displayedQuestionIndex = 0
        self.displayQuestion(self.displayedQuestionIndex)
        
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
            let tutoDescriptionCenterY:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: (300/2-50)*self.heightRatio)
            let tutoDescriptionLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 50*self.widthRatio)
            let tutoDescriptionRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -50*self.widthRatio)
            self.tutoView.addConstraints([tutoDescriptionCenterY,tutoDescriptionLeft,tutoDescriptionRight])
            let tutoDescriptionHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 300*self.heightRatio)
            self.tutoDescription.addConstraint(tutoDescriptionHeight)
            
            self.tutoNextButton.translatesAutoresizingMaskIntoConstraints = false
            let tutoNextButtonBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -20*self.heightRatio)
            let tutoNextButtonLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 40*self.widthRatio)
            let tutoNextButtonRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -40*self.widthRatio)
            self.tutoView.addConstraints([tutoNextButtonBottom,tutoNextButtonLeft,tutoNextButtonRight])
            let tutoNextButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.heightRatio)
            self.tutoNextButton.addConstraint(tutoNextButtonHeight)
            
            self.tutoSkipButton.translatesAutoresizingMaskIntoConstraints = false
            let tutoSkipButtonTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.view.frame.width/12 + 30*self.heightRatio)
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
            let labelString:String = String("FRACTIONS TEST")
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 10, length: NSString(string: labelString).length-10))
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
            let tutoNextButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tutoNext:"))
            self.tutoNextButton.addGestureRecognizer(tutoNextButtonTap)
            self.tutoSkipButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.tutoSkipButton.setTitle("Skip the Tutorial", forState: .Normal)
            self.tutoSkipButton.titleLabel?.font = UIFont(name: "HelveticaNeue-LightItalic", size: self.view.getTextSize(15))
            self.tutoSkipButton.titleLabel?.textAlignment = NSTextAlignment.Center
            let tutoSkipButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tutoSkip:"))
            self.tutoSkipButton.addGestureRecognizer(tutoSkipButtonTap)
            
            //Set tutorial text
            self.tutoDescriptionTitle.text = "Test Description:"
            self.tutoDescriptionText.text = "You will be tested on your ability to compute and reduce simple fractions in a limited amount of time. You will have \(self.allowedMinutes) minutes to answer up to \(self.totalNumberOfQuestions+1) questions."
            self.tutoDescriptionTitle2.text = "Our Recommendation:"
            self.tutoDescriptionText2.text = "We recommend that you are able to score at least 85% on Medium difficulty before taking the actual test."
            
            //Set Tutorial page
            self.tutoPage = 1
            
        } else {
            //Launch timer
            if self.interstitialAd.isReady {
                self.interstitialAd.presentFromRootViewController(self)
            } else {
                print("Ad wasn't ready")
                self.testStarted = true
                self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(fractionsViewController.updateTimer), userInfo: nil, repeats: true)
            }
        }
        
    }
    
    func tutoNext(sender:UITapGestureRecognizer) {
        self.tutoPage++
        if self.tutoPage==2 {
            self.tutoDescriptionSep2.alpha = 0
            self.tutoDescriptionText2.alpha = 0
            self.tutoDescriptionTitle2.alpha = 0
            self.tutoDescriptionText.textAlignment = NSTextAlignment.Center
            self.tutoDescriptionTitle.alpha = 0.0
            self.tutoDescriptionText.text = "Questions will appear here. You can select from a range of answers on the right."
            self.tutorialFingerImageView.alpha = 0.0
            self.tutoSkipButton.alpha = 0.0
            for answerView in self.mainView.subviews {
                if let answerRow = answerView as? UIButton {
                    if answerRow.tag>2 && answerRow.tag<10 {
                        answerRow.alpha = 0.0
                    }
                }
            }
            self.mainView.addSubview(self.whiteBGView)
            whiteBGView.setConstraintsToSuperview(0, bottom: Int(280*self.heightRatio), left: Int(10*self.widthRatio), right: Int(10*self.widthRatio))
            self.whiteBGView.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
            self.mainView.sendSubviewToBack(self.whiteBGView)
            self.view.bringSubviewToFront(self.mainView)
            self.whiteBGView.layer.cornerRadius = 8.0
        }
        if self.tutoPage==3 {
            self.view.bringSubviewToFront(self.tutoView)
            self.tutoView.insertSubview(self.swipeUIView, atIndex: 3)
            self.tutoView.bringSubviewToFront(self.tutoNextButton)
            self.tutoDescriptionText.text = "You will be shown how much time you have left. Once you have selected an answer, press the \"Continue\" button below to go to the next question."
        }
        if self.tutoPage==4 {
            self.view.insertSubview(self.swipeUIView, atIndex: 10)
            self.view.bringSubviewToFront(self.tutoView)
            self.tutoDescriptionTitle.alpha = 1.0
            self.tutoDescriptionTitle.textAlignment = NSTextAlignment.Center
            self.tutoDescriptionTitle.text = "Ready to Start ?"
            self.tutoDescriptionText.text = "You are now ready to Start the test. Practice hard, and remember: both your final score and speed matter when it comes to selecting candidates !"
            self.tutoNextButton.setTitle("Start Test", forState: .Normal)
        }
        if self.tutoPage==5 {
            self.selectedAnswers[self.displayedQuestionIndex] = 20
            self.tutoView.alpha = 0
            self.whiteBGView.alpha = 0
            self.displayQuestion(self.displayedQuestionIndex)
            self.showTutorial = false
            if self.interstitialAd.isReady {
                self.interstitialAd.presentFromRootViewController(self)
            } else {
                self.testStarted = true
                self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(fractionsViewController.updateTimer), userInfo: nil, repeats: true)
                print("Ad wasn't ready")
            }
        }
        
    }
    
    func tutoSkip(sender:UITapGestureRecognizer) {
        self.showTutorial = false
        if self.interstitialAd.isReady {
            self.interstitialAd.presentFromRootViewController(self)
        } else {
            self.testStarted = true
            self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(fractionsViewController.updateTimer), userInfo: nil, repeats: true)
            print("Ad wasn't ready")
        }
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.tutoView.alpha = 0.0
            }, completion: nil)
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
    
    func backHome(sender:UITapGestureRecognizer) {
        var alertMessage:String = String()
        if (self.isTestComplete==false) {
            alertMessage = "Are you sure you want to return home? All progress will be lost!"
        } else {
            alertMessage = "Are you sure you want to return home?"
        }
        
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
        if self.interstitialAd.isReady {
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
    
    func displayQuestion(indexQuestion:Int) {
        
        //Initialize labels
        let labelString:String = String("QUESTION \(indexQuestion+1)/\(self.totalNumberOfQuestions+1)")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 9, length: NSString(string: labelString).length-9))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0), range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.questionMenuLabel.attributedText = attributedString
        self.questionMenuLabel.attributedText = attributedString
        
        // add answers to SwipeUIVIew
        for answerSubView in self.mainView.subviews {
            answerSubView.removeFromSuperview()
        }
        let arrayAnswers:[[Int]] = self.quizzArray[indexQuestion].answers
        var operation:String = self.quizzArray[indexQuestion].operation
        let questionAsked:[Int] = self.quizzArray[indexQuestion].question
        let buttonHeight:Int = Int((self.view.frame.height-250*self.heightRatio)/4)
        var i:Int = 0
        
        if operation=="+" {
            operation = "➕"
        } else if operation=="-" {
            operation = "➖"
        } else if operation=="*" {
            operation = "✖️"
        } else {
            operation = "➗"
        }
        
        for i=0; i<arrayAnswers.count;i++ {
            let answerRow:UIButton = UIButton()
            let answerNumber:UIButton = UIButton()
            let matchingQuestionLabel:UIButton = UIButton()
            answerRow.translatesAutoresizingMaskIntoConstraints = false
            answerNumber.translatesAutoresizingMaskIntoConstraints = false
            matchingQuestionLabel.translatesAutoresizingMaskIntoConstraints = false
            self.mainView.addSubview(answerRow)
            answerRow.addSubview(answerNumber)
            answerRow.addSubview(matchingQuestionLabel)
            
            answerRow.tag = (i+1) * 1
            answerNumber.tag = (i+1) * 10
            matchingQuestionLabel.tag = (i+1) * 100
            
            let top:NSLayoutConstraint = NSLayoutConstraint(item: answerRow, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+Int(10*self.heightRatio))))
            let left:NSLayoutConstraint = NSLayoutConstraint(item: answerRow, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10*self.widthRatio)
            let right:NSLayoutConstraint = NSLayoutConstraint(item: answerRow, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10*self.widthRatio)
            self.mainView.addConstraints([top,left,right])
            let height:NSLayoutConstraint = NSLayoutConstraint(item: answerRow, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight))
            answerRow.addConstraint(height)
            
            let topM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 2*self.heightRatio)
            let leftM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5*self.widthRatio)
            let rightM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -90*self.widthRatio)
            let bottomM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -5*self.heightRatio)
            answerRow.addConstraints([topM,leftM,rightM,bottomM])
            
            let topMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 5*self.heightRatio)
            let rightMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -5*self.widthRatio)
            let bottomMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -5*self.heightRatio)
            answerRow.addConstraints([topMM,rightMM,bottomMM])
            let widthMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 75*self.widthRatio)
            answerNumber.addConstraint(widthMM)
            
            let answerContent:UIView = UIView()
            answerNumber.addSubview(answerContent)
            answerContent.translatesAutoresizingMaskIntoConstraints = false
            let answerContentTop:NSLayoutConstraint = NSLayoutConstraint(item: answerContent, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerNumber, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 2*self.heightRatio)
            let answerContentLeft:NSLayoutConstraint = NSLayoutConstraint(item: answerContent, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerNumber, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10*self.widthRatio)
            let answerContentWidth:NSLayoutConstraint = NSLayoutConstraint(item: answerContent, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 55*self.widthRatio)
            let answerContentHeight:NSLayoutConstraint = NSLayoutConstraint(item: answerContent, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight-Int(10*self.heightRatio)))
            answerNumber.addConstraints([answerContentTop,answerContentLeft])
            answerContent.addConstraints([answerContentWidth,answerContentHeight])
            self.createFraction(answerContent, viewHeight: Int(buttonHeight-Int(10*self.heightRatio)), fontName:"HelveticaNeue-Bold", fontSize:Int(self.view.getTextSize(22)), topNb: arrayAnswers[i][0], bottomNb: arrayAnswers[i][1])
            
            answerNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            answerNumber.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
            answerNumber.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
            answerNumber.layer.borderWidth = 2.0

            let leftOffset:CGFloat = (self.view.frame.width - 315*self.widthRatio)/2
            
            let questionContent1:UIView = UIView()
            matchingQuestionLabel.addSubview(questionContent1)
            questionContent1.translatesAutoresizingMaskIntoConstraints = false
            let questionContent1Top:NSLayoutConstraint = NSLayoutConstraint(item: questionContent1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: matchingQuestionLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 2*self.heightRatio)
            let questionContent1Left:NSLayoutConstraint = NSLayoutConstraint(item: questionContent1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: matchingQuestionLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(5*self.widthRatio + leftOffset))
            let questionContent1Width:NSLayoutConstraint = NSLayoutConstraint(item: questionContent1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.widthRatio)
            let questionContent1Height:NSLayoutConstraint = NSLayoutConstraint(item: questionContent1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight-Int(10*self.heightRatio)))
            matchingQuestionLabel.addConstraints([questionContent1Top,questionContent1Left])
            questionContent1.addConstraints([questionContent1Width,questionContent1Height])
            self.createFraction(questionContent1, viewHeight: Int(buttonHeight-Int(10*self.heightRatio)), fontName:"HelveticaNeue-Bold", fontSize:Int(self.view.getTextSize(28)), topNb: questionAsked[0], bottomNb: questionAsked[1])
            let questionContent2:UIView = UIView()
            matchingQuestionLabel.addSubview(questionContent2)
            questionContent2.translatesAutoresizingMaskIntoConstraints = false
            let questionContent2Top:NSLayoutConstraint = NSLayoutConstraint(item: questionContent2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: matchingQuestionLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 2*self.heightRatio)
            let questionContent2Left:NSLayoutConstraint = NSLayoutConstraint(item: questionContent2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: matchingQuestionLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(95*self.widthRatio + leftOffset))
            let questionContent2Width:NSLayoutConstraint = NSLayoutConstraint(item: questionContent2, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.widthRatio)
            let questionContent2Height:NSLayoutConstraint = NSLayoutConstraint(item: questionContent2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight-Int(10*self.heightRatio)))
            matchingQuestionLabel.addConstraints([questionContent2Top,questionContent2Left])
            questionContent2.addConstraints([questionContent2Width,questionContent2Height])
            self.createFraction(questionContent2, viewHeight: Int(buttonHeight-Int(10*self.heightRatio)), fontName:"HelveticaNeue-Bold", fontSize:Int(self.view.getTextSize(28)), topNb: questionAsked[2], bottomNb: questionAsked[3])
            let questionContent3:UIButton = UIButton()
            matchingQuestionLabel.addSubview(questionContent3)
            questionContent3.translatesAutoresizingMaskIntoConstraints = false
            let questionContent3Top:NSLayoutConstraint = NSLayoutConstraint(item: questionContent3, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: matchingQuestionLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 2*self.heightRatio)
            let questionContent3Left:NSLayoutConstraint = NSLayoutConstraint(item: questionContent3, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: matchingQuestionLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(60*self.widthRatio + leftOffset))
            let questionContent3Width:NSLayoutConstraint = NSLayoutConstraint(item: questionContent3, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30*self.widthRatio)
            let questionContent3Height:NSLayoutConstraint = NSLayoutConstraint(item: questionContent3, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight-Int(10*self.heightRatio)))
            matchingQuestionLabel.addConstraints([questionContent3Top,questionContent3Left])
            questionContent3.addConstraints([questionContent3Width,questionContent3Height])
            
            questionContent3.setTitle(operation, forState: .Normal)
            questionContent3.setTitleColor(UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0), forState: .Normal)
            questionContent3.titleLabel?.font = UIFont(name: "HelveticaNeue",size: self.view.getTextSize(15))
            let questionContent4:UIButton = UIButton()
            matchingQuestionLabel.addSubview(questionContent4)
            questionContent4.translatesAutoresizingMaskIntoConstraints = false
            let questionContent4Top:NSLayoutConstraint = NSLayoutConstraint(item: questionContent4, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: matchingQuestionLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 2*self.heightRatio)
            let questionContent4Left:NSLayoutConstraint = NSLayoutConstraint(item: questionContent4, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: matchingQuestionLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(150*self.widthRatio + leftOffset))
            let questionContent4Width:NSLayoutConstraint = NSLayoutConstraint(item: questionContent4, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20*self.widthRatio)
            let questionContent4Height:NSLayoutConstraint = NSLayoutConstraint(item: questionContent4, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight-Int(10*self.heightRatio)))
            matchingQuestionLabel.addConstraints([questionContent4Top,questionContent4Left])
            questionContent4.addConstraints([questionContent4Width,questionContent4Height])
            questionContent4.setTitle("=", forState: .Normal)
            questionContent4.setTitleColor(UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0), forState: .Normal)
            questionContent4.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold",size: self.view.getTextSize(28))
            
            matchingQuestionLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            matchingQuestionLabel.alpha = 0.0
            
            print(answerRow.frame.width)
            
            if i==0 {
                answerRow.alpha = 1.0
                answerRow.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.3)
                matchingQuestionLabel.alpha = 1.0
            }
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("answerIsSelected:"))
            answerNumber.addGestureRecognizer(tapGesture)
        }
        
    }
    
    func answerIsSelected(gesture:UITapGestureRecognizer) {

        for buttons in self.mainView.subviews {
            if let anyButton = buttons as? UIButton {
                if anyButton.tag <= 6 {
                    anyButton.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
                }
            }
            for vraiButton in buttons.subviews {
                if let anyButton = vraiButton as? UIButton {
                    if anyButton.tag >= 10 && anyButton.tag <= 60 {
                        anyButton.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
                        for buttonSubView in anyButton.subviews {
                            for answerSubView in buttonSubView.subviews {
                                if let answrButton = answerSubView as? UIButton {
                                    answrButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                                }
                                if let answrLabel = answerSubView as? UILabel {
                                    answrLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                                    answrLabel.font = UIFont(name: "HelveticaNeue-Bold", size: self.view.getTextSize(22))
                                }
                            }
                        }
                    }
                    if anyButton.tag > 60 {
                        anyButton.alpha = 0.0
                    }
                }
            }
        }
        let buttonTapped:UIView? = gesture.view
        if let actualButton = buttonTapped {
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                if let actButton = actualButton as? UIButton {
                    actButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                    for buttonSubView in actButton.subviews {
                            for answerSubView in buttonSubView.subviews {
                                if let answrButton = answerSubView as? UIButton {
                                    answrButton.backgroundColor = UIColor.whiteColor()
                                }
                                if let answrLabel = answerSubView as? UILabel {
                                    answrLabel.textColor = UIColor.whiteColor()
                                    answrLabel.font = UIFont(name: "HelveticaNeue-Bold", size: self.view.getTextSize(28))
                                }
                            }
                    }
                    self.selectedAnswers[self.displayedQuestionIndex] = Int(actualButton.tag/10 - 1)
                    for buttons in self.mainView.subviews {
                        if let corrButton = buttons as? UIButton {
                            if corrButton.tag*10 == actButton.tag {
                                corrButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.3)
                            }
                            for subButton in corrButton.subviews {
                                if let actualSubButton = subButton as? UIButton {
                                    if actualSubButton.tag == (actButton.tag)*10 {
                                        actualSubButton.alpha = 1.0
                                    }
                                }
                            }
                        }
                    }
                }
                }, completion: nil)
        }
        
    }
    
    func nextQuestion(gesture:UITapGestureRecognizer) {
        
        // If no answer is selected, show Alert
        if self.selectedAnswers[self.displayedQuestionIndex] == 20 {
            let exitAlert = SCLAlertView()
            exitAlert.showError("No Answer Selected", subTitle: "Please select an answer before proceeding")
        }
        else {
            //Else go to next question
            //Go to the feedback screen
            if self.displayedQuestionIndex + 1 > self.totalNumberOfQuestions {
                
                if self.resultsUploaded==false {
                    //Stop Timer
                    self.timeTimer.invalidate()
                    
                    if self.testStarted == true {
                        if self.interstitialAd.isReady {
                            self.interstitialAd.presentFromRootViewController(self)
                        } else {
                            print("Ad wasn't ready")
                            self.testStarted = false
                            self.nextQuestion(UITapGestureRecognizer())
                        }
                    } else {
                        
                    //Upload Results to Parse
                    var i:Int = 0
                    var nbCorrectAnswers:Int = 0
                    for i=0;i<self.quizzArray.count;i++ {
                        if self.quizzArray[i].correctAnswer == self.selectedAnswers[i] {
                            nbCorrectAnswers++
                        }
                    }
                    self.scoreRatio = (Float(nbCorrectAnswers) / Float(self.selectedAnswers.count)) * 100
                    //Add: test type (numerical / verbal ...)
                    
                    var timeTaken:Float = Float(60 * self.allowedMinutes + self.allowedSeconds) - Float(60 * self.countMinutes + self.countSeconds)
                    timeTaken = timeTaken/Float(self.selectedAnswers.count)
                    
                    SwiftSpinner.show("Saving Results")
                    
                    let user = PFUser.currentUser()
                    let analytics = PFObject(className: PF_FRACTIONS_CLASS_NAME)
                    analytics[PF_FRACTIONS_USER] = user
                    analytics[PF_FRACTIONS_SCORE] = self.scoreRatio
                    analytics[PF_FRACTIONS_TIME] = timeTaken
                    analytics[PF_FRACTIONS_USERNAME] = user![PF_USER_USERNAME]
                    
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
                self.displayedQuestionIndex++
                if self.displayedQuestionIndex==self.totalNumberOfQuestions{
                    //Switch Button text to "Complete"
                    self.nextButton.text = "Complete Test"
                }
                self.displayQuestion(self.displayedQuestionIndex)
            }
        }
    }
    
    func feedbackScreen() {
        
        //Display feedback screen here
        self.isTestComplete = true
        var i:Int = 0
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
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0), range: NSRange(location: 0, length: 6))
            self.questionMenuLabel.attributedText = attributedString
            
            self.mainView.alpha = 0.0
            self.swipeUIView.alpha = 0.0
            self.feebdackScreen.alpha = 1.0
            self.view.addSubview(self.feebdackScreen)
            self.feebdackScreen.setConstraintsToSuperview(Int(75*self.heightRatio), bottom: Int(20*self.heightRatio), left: Int(20*self.widthRatio), right: Int(20*self.widthRatio))
            self.feebdackScreen.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.feebdackScreen.layer.cornerRadius = 8.0
            }, completion: nil)
        
        for i=0; i<self.selectedAnswers.count;i++ {
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
            
            if self.quizzArray[i].correctAnswer == self.selectedAnswers[i] {
                answerUILabel.text = "Correct Answer"
                answerNumber.backgroundColor = UIColor.greenColor()
            }
            else if (self.selectedAnswers[i] != self.quizzArray[i].correctAnswer) && (self.selectedAnswers[i]<20) {
                answerUILabel.text = "Wrong Answer"
                answerNumber.backgroundColor = UIColor.redColor()
            }
            else {
                answerUILabel.text = "Unanswered"
                answerNumber.backgroundColor = UIColor.grayColor()
            }
            
            //Set constraints to answerViews
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+Int(10*self.heightRatio)) + Int(20*self.heightRatio)))
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
        }
        
        self.feebdackScreen.scrollEnabled = true
        let totalHeight:CGFloat = CGFloat((self.selectedAnswers.count+1) * (buttonHeight + Int(10*self.heightRatio)))
        self.feebdackScreen.contentSize = CGSize(width: (self.view.frame.width - 40*self.widthRatio), height: totalHeight+30)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNewQuestion() {
        //Add a new question to the array
        let newQuestion:fractionsQuestion = fractionsQuestion()
        var operation:String = String()
        operation = self.arrayOperation[Int(arc4random_uniform(UInt32(self.arrayOperation.count)))]
        let (questionNumbers, answerNumbers, correctIndex) = self.fillArrayWithRandomNumbers(operation)
        newQuestion.question = questionNumbers
        newQuestion.operation = operation
        newQuestion.answers = answerNumbers
        newQuestion.correctAnswer = correctIndex
        self.quizzArray.append(newQuestion)
    }
    
    func fillArrayWithRandomNumbers(operation:String) -> ([Int], [[Int]],Int) {
        
        //Set function's variables
        var number1:Float = Float()
        var number2:Float = Float()
        var number3:Float = Float()
        var number4:Float = Float()
        var returnedArray:[[Int]] = [[Int]]()
        var answersArray:[[Int]] = [[Int]]()
        var correctIndex:Int = Int()
        var randomIndex:Int = Int()
        var correctIndexSet:Bool = false
        var i:Int = 0

        //Randomize question numbers
        if self.difficulty=="H" {
            number1 = Float(arc4random_uniform(20))+1
            number2 = Float(arc4random_uniform(20))+1
            number3 = Float(arc4random_uniform(20))+1
            number4 = Float(arc4random_uniform(20))+1
        } else {
            number1 = Float(arc4random_uniform(10))+1
            number2 = Float(arc4random_uniform(10))+1
            number3 = Float(arc4random_uniform(10))+1
            number4 = Float(arc4random_uniform(10))+1
        }
        
        //Generate random answers
        if operation=="+" {
            let simplifiedFraction:[Int] = self.simplifyFraction(Int(number1*number4+number3*number2), bottom: Int(number2*number4))
            answersArray.append([simplifiedFraction[0],simplifiedFraction[1]])
            answersArray.append([simplifiedFraction[0]+1,simplifiedFraction[1]])
            answersArray.append([simplifiedFraction[0],simplifiedFraction[1]+1])
            answersArray.append([simplifiedFraction[0]+1,simplifiedFraction[1]+1])
        }
        if operation=="-" {
            let simplifiedFraction:[Int] = self.simplifyFraction(Int(number1*number4-number3*number2), bottom: Int(number2*number4))
            answersArray.append([simplifiedFraction[0],simplifiedFraction[1]])
            answersArray.append([simplifiedFraction[0]+1,simplifiedFraction[1]])
            answersArray.append([simplifiedFraction[0],simplifiedFraction[1]+1])
            answersArray.append([simplifiedFraction[0]+1,simplifiedFraction[1]+1])
        }
        if operation=="*" {
            let simplifiedFraction:[Int] = self.simplifyFraction(Int(number1*number3), bottom: Int(number2*number4))
            answersArray.append([simplifiedFraction[0],simplifiedFraction[1]])
            answersArray.append([simplifiedFraction[0]+1,simplifiedFraction[1]])
            answersArray.append([simplifiedFraction[0],simplifiedFraction[1]+1])
            answersArray.append([simplifiedFraction[0]+1,simplifiedFraction[1]+1])
        }
        if operation=="/" {
            let simplifiedFraction:[Int] = self.simplifyFraction(Int(number1*number4), bottom: Int(number2*number3))
            answersArray.append([simplifiedFraction[0],simplifiedFraction[1]])
            answersArray.append([simplifiedFraction[0]+1,simplifiedFraction[1]])
            answersArray.append([simplifiedFraction[0],simplifiedFraction[1]+1])
            answersArray.append([simplifiedFraction[0]+1,simplifiedFraction[1]+1])

        }
        
        //Shuffle array of answers
        for i=0;i<4;i++ {
            randomIndex = Int(arc4random_uniform(UInt32(4-i)))
            returnedArray.append(answersArray[randomIndex])
            answersArray.removeAtIndex(randomIndex)
            if randomIndex==0 && !correctIndexSet {
                correctIndex = i
                correctIndexSet = true
            }
        }

        //Return question info array
        return ([Int(number1), Int(number2), Int(number3), Int(number4)], returnedArray, correctIndex)
    }
    
    func simplifyFraction(top:Int, bottom:Int) -> [Int] {
        
        var x = top
        var y = bottom
        while (y != 0) {
            let buffer = y
            y = x % y
            x = buffer
        }
        let hcfVal = x
        let newTopVal = top/hcfVal
        let newBottomVal = bottom/hcfVal
        return [newTopVal, newBottomVal]
    }
    
    func setDifficultyLevel() {
        if self.difficulty=="E" {
            self.arrayOperation = ["*","/"]
        }
        else if self.difficulty=="M" {
            self.arrayOperation = ["*","/","+"]
        }
        else if self.difficulty=="H" {
            self.arrayOperation = ["*","/","+","-"]
        }
    }
    
    func createFraction(fractionView:UIView, viewHeight:Int, fontName:String, fontSize:Int, topNb:Int,bottomNb:Int) {
        
        let topLabel:UILabel = UILabel()
        let bottomLabel:UILabel = UILabel()
        let fractionLine:UIButton = UIButton()
        
        fractionView.addSubview(topLabel)
        fractionView.addSubview(bottomLabel)
        fractionView.addSubview(fractionLine)
        
        topLabel.text = String(topNb)
        bottomLabel.text = String(bottomNb)
        topLabel.textAlignment = NSTextAlignment.Center
        bottomLabel.textAlignment = NSTextAlignment.Center
        fractionLine.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        
        topLabel.setConstraintsToSuperview(Int(15*self.heightRatio), bottom: (viewHeight/2+Int(3*self.heightRatio)), left: 0, right: 0)
        bottomLabel.setConstraintsToSuperview(viewHeight/2+Int(3*self.heightRatio), bottom: Int(15*self.heightRatio), left: 0, right: 0)
        fractionLine.setConstraintsToSuperview(viewHeight/2, bottom: Int(CGFloat(viewHeight)/2-self.heightRatio), left: 0, right: 0)

        topLabel.font = UIFont(name: fontName, size: CGFloat(fontSize))
        bottomLabel.font = UIFont(name: fontName, size: CGFloat(fontSize))
        topLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        bottomLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        
        print(viewHeight)
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: AD_ID_FRACTIONS)
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
                self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(fractionsViewController.updateTimer), userInfo: nil, repeats: true)
            } else if self.testStarted == true {
                self.testStarted = false
                self.nextQuestion(UITapGestureRecognizer())
            }
        }
    }

    
}