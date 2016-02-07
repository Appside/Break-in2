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

class logicalReasoningViewController: QuestionViewController, UIScrollViewDelegate {
    
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
    var quizzArray:[logicalQuestion] = [logicalQuestion]()
    var displayedQuestionIndex:Int = 0
    var totalNumberOfQuestions:Int = 24
    var allowedSeconds:Int = 00
    var allowedMinutes:Int = 10
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
    var logicModel:LogicalModel = LogicalModel()
    
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
        imageViewBackground.image = UIImage(named: "arithBG")
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        self.backgroungUIView.addSubview(imageViewBackground)
        self.backgroungUIView.sendSubviewToBack(imageViewBackground)
        
        //Initialize back home button
        self.view.addSubview(self.menuBackButton)
        self.menuBackButton.translatesAutoresizingMaskIntoConstraints = false
        let topMenuViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
        let topMenuViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 75)
        let topMenuViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35)
        let topMenuViewLeftMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        self.menuBackButton.addConstraints([topMenuViewHeight, topMenuViewWidth])
        self.view.addConstraints([topMenuViewLeftMargin,topMenuViewTopMargin])
        self.menuBackButton.layer.cornerRadius = 8.0
        let menuBackImageVIew:UIImageView = UIImageView()
        menuBackImageVIew.image = UIImage(named: "prevButton")
        menuBackImageVIew.translatesAutoresizingMaskIntoConstraints = false
        self.menuBackButton.addSubview(menuBackImageVIew)
        let arrowTop:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant:0)
        let arrowLeft:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant:0)
        let arrowHeight:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant:UIScreen.mainScreen().bounds.width/14)
        let arrowWidth:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant:UIScreen.mainScreen().bounds.width/14)
        self.menuBackButton.addConstraints([arrowTop,arrowLeft])
        menuBackImageVIew.addConstraints([arrowHeight,arrowWidth])
        let tapGestureBackHome:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("backHome:"))
        tapGestureBackHome.numberOfTapsRequired = 1
        self.menuBackButton.addGestureRecognizer(tapGestureBackHome)
        
        //Initialize questionNumber Label
        self.view.addSubview(self.questionMenu)
        self.questionMenu.translatesAutoresizingMaskIntoConstraints = false
        let questionViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
        let questionViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 40)
        let questionViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35)
        let questionViewRightMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
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
        let swipeMenuTopBarTop:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
        let swipeMenuTopBarLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
        let swipeMenuTopBarRight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10)
        self.swipeUIView.addConstraints([swipeMenuTopBarTop,swipeMenuTopBarLeft,swipeMenuTopBarRight])
        let swipeMenuTopBarHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        
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
        self.mainView.setConstraintsToSuperview(75, bottom: 130, left: 20, right: 20)
        
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
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 50)
        let rightLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20))
        let leftLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20))
        self.swipeUIView.addConstraints([topLabelMargin,rightLabelMargin,leftLabelMargin])
        let heightLabelConstraint:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 50)
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
        self.logicModel = LogicalModel()
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
        self.swipeMenuHeightConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
        self.swipeUIView.addConstraint(self.swipeMenuHeightConstraint)
        self.swipeMenuBottomConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        let rightMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
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
            let tutoDescriptionCenterY:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 300/2-50)
            let tutoDescriptionLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 50)
            let tutoDescriptionRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -50)
            self.tutoView.addConstraints([tutoDescriptionCenterY,tutoDescriptionLeft,tutoDescriptionRight])
            let tutoDescriptionHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 300)
            self.tutoDescription.addConstraint(tutoDescriptionHeight)
            
            self.tutoNextButton.translatesAutoresizingMaskIntoConstraints = false
            let tutoNextButtonBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -20)
            let tutoNextButtonLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 40)
            let tutoNextButtonRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -40)
            self.tutoView.addConstraints([tutoNextButtonBottom,tutoNextButtonLeft,tutoNextButtonRight])
            let tutoNextButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
            self.tutoNextButton.addConstraint(tutoNextButtonHeight)
            
            self.tutoSkipButton.translatesAutoresizingMaskIntoConstraints = false
            let tutoSkipButtonTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 25+(self.view.frame.width/12)+5)
            let tutoSkipButtonCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            self.tutoView.addConstraints([tutoSkipButtonTop,tutoSkipButtonCenterX])
            let tutoSkipButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
            let tutoSkipButtonWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 200)
            self.tutoSkipButton.addConstraints([tutoSkipButtonHeight,tutoSkipButtonWidth])
            
            self.tutoDescriptionTitle.setConstraintsToSuperview(0, bottom: 285, left: 0, right: 0)
            self.tutoDescriptionSep.setConstraintsToSuperview(17, bottom: 282, left: 0, right: 0)
            //self.tutoDescriptionText.setConstraintsToSuperview(20, bottom: 125, left: 0, right: 0)
            self.tutoDescriptionTitle2.setConstraintsToSuperview(160, bottom: 125, left: 0, right: 0)
            self.tutoDescriptionSep2.setConstraintsToSuperview(177, bottom: 122, left: 0, right: 0)
            //self.tutoDescriptionText2.setConstraintsToSuperview(200, bottom: 0, left: 0, right: 0)
            
            self.tutoDescriptionText.translatesAutoresizingMaskIntoConstraints = false
            let tutoDescriptionTextTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20)
            let tutoDescriptionTextLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let tutoDescriptionTextRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            self.tutoDescription.addConstraints([tutoDescriptionTextTop,tutoDescriptionTextLeft,tutoDescriptionTextRight])
            let tutoDescriptionText2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 180)
            let tutoDescriptionText2Left:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let tutoDescriptionText2Right:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            self.tutoDescription.addConstraints([tutoDescriptionText2Top,tutoDescriptionText2Left,tutoDescriptionText2Right])
            
            self.tutoDescriptionText2.translatesAutoresizingMaskIntoConstraints = false
            self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
            let logoImageViewCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            let logoImageViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 25)
            let logoImageViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/12)
            let logoImageViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-40)
            self.logoImageView.addConstraints([logoImageViewHeight, logoImageViewWidth])
            self.tutoView.addConstraints([logoImageViewCenterX, logoImageViewTop])
            
            //Finger ImageView
            self.tutorialFingerImageView.image = UIImage.init(named: "fingbutton")
            self.tutorialFingerImageView.contentMode = UIViewContentMode.ScaleAspectFit
            self.tutorialFingerImageView.translatesAutoresizingMaskIntoConstraints = false
            let descriptionImageViewCenterX:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            let descriptionImageViewCenterY:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -self.view.frame.width/8-100)
            let descriptionImageViewHeight:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/4)
            let descriptionImageViewWidth:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 10)
            self.tutorialFingerImageView.addConstraints([descriptionImageViewHeight, descriptionImageViewWidth])
            self.tutoView.addConstraints([descriptionImageViewCenterX, descriptionImageViewCenterY])
            
            //Tutorial Title
            let labelString:String = String("LOGICAL REASONING")
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 8, length: NSString(string: labelString).length-8))
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
            self.tutoDescriptionText.text = "You will be tested on your ability to analyze logical patterns in a limited amount of time. You will have \(self.allowedMinutes) minutes to answer up to \(self.totalNumberOfQuestions+1) questions."
            self.tutoDescriptionTitle2.text = "Our Recommendation:"
            self.tutoDescriptionText2.text = "We recommend that you achieve a score of at least 85% on the Hard difficulty level before taking the real test."
            
            //Set Tutorial page
            self.tutoPage = 1
            
        } else {
            //Launch timer
            self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
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
            self.tutoDescriptionText.text = "Questions will appear here. Try to select an answer on the right."
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
            whiteBGView.setConstraintsToSuperview(0, bottom: 280, left: 10, right: 10)
            self.whiteBGView.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
            self.mainView.sendSubviewToBack(self.whiteBGView)
            self.view.bringSubviewToFront(self.mainView)
            self.whiteBGView.layer.cornerRadius = 8.0
        }
        if self.tutoPage==3 {
            self.view.bringSubviewToFront(self.tutoView)
            self.tutoView.insertSubview(self.swipeUIView, atIndex: 3)
            self.tutoView.bringSubviewToFront(self.tutoNextButton)
            self.tutoDescriptionText.text = "A timer shows you how much time you have left. Once you have selected an answerm press the \"Continue\" button below to go to the next question."
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
            self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        }
        
    }
    
    func tutoSkip(sender:UITapGestureRecognizer) {
        self.showTutorial = false
        self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
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
        
        let backAlert = SCLAlertView()
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
        backAlert.showCloseButton = false
        
    }
    
    func goBack(){
        
        self.performSegueWithIdentifier("backHomeSegue", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "backHomeSegue" {
            self.timeTimer.invalidate()
            let destinationVC:HomeViewController = segue.destinationViewController as! HomeViewController
            destinationVC.segueFromLoginView = false
        }
        
    }
    
    func displayQuestion(indexQuestion:Int) {
        
        if self.isTestComplete==false {
            
            //Initialize labels
            let labelString:String = String("QUESTION \(indexQuestion+1)/\(self.totalNumberOfQuestions+1)")
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 9, length: NSString(string: labelString).length-9))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0), range: NSRange(location: 0, length: NSString(string: labelString).length))
            self.questionMenuLabel.attributedText = attributedString
            self.questionMenuLabel.attributedText = attributedString
            
        }
        
        // add answers to SwipeUIVIew
        for answerSubView in self.mainView.subviews {
            answerSubView.removeFromSuperview()
        }
        let arrayAnswers:[LogicalPictureView] = self.quizzArray[indexQuestion].answers
        let buttonHeight:Int = Int((self.view.frame.height-250)/4)
        let shapesMargin:Int = 10
        let shapesWidth:Int = (Int(self.view.frame.width)-170-4*shapesMargin)/4
        var i:Int = 0
        var j:Int = 0
        
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
            
            answerNumber.addSubview(arrayAnswers[i])
            arrayAnswers[i].backgroundColor = UIColor.clearColor()
            arrayAnswers[i].translatesAutoresizingMaskIntoConstraints = false
            let centerXAnsw:NSLayoutConstraint = NSLayoutConstraint(item: arrayAnswers[i], attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: answerNumber, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            let centerYAnsw:NSLayoutConstraint = NSLayoutConstraint(item: arrayAnswers[i], attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: answerNumber, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            answerNumber.addConstraints([centerXAnsw,centerYAnsw])
            let heightAnsw:NSLayoutConstraint = NSLayoutConstraint(item: arrayAnswers[i], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(shapesWidth))
            let widthAnsw:NSLayoutConstraint = NSLayoutConstraint(item: arrayAnswers[i], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(shapesWidth))
            arrayAnswers[i].addConstraints([heightAnsw,widthAnsw])
            
            answerNumber.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
            answerNumber.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
            answerNumber.layer.borderWidth = 2.0
            matchingQuestionLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            matchingQuestionLabel.alpha = 0.0
            
            if i==0 {
                //Select first row by default
                answerRow.alpha = 1.0
                answerRow.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.3)
                matchingQuestionLabel.alpha = 1.0
                
                //Set constraints for the shapes
                j = 0
                let questionAsked:[LogicalPictureView] = self.quizzArray[indexQuestion].question
                for j=0;j<4;j++ {
                    matchingQuestionLabel.addSubview(questionAsked[j])
                    questionAsked[j].translatesAutoresizingMaskIntoConstraints = false
                    let topMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: matchingQuestionLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
                    let leftMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: matchingQuestionLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(j*(shapesWidth+shapesMargin)))
                    matchingQuestionLabel.addConstraints([topMMM,leftMMM])
                    let heightMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(shapesWidth))
                    let widthMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(shapesWidth))
                    questionAsked[j].addConstraints([heightMMM,widthMMM])
                    questionAsked[j].backgroundColor = UIColor.clearColor()
                }
                
            }
            
            let top:NSLayoutConstraint = NSLayoutConstraint(item: answerRow, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+10)))
            let left:NSLayoutConstraint = NSLayoutConstraint(item: answerRow, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
            let right:NSLayoutConstraint = NSLayoutConstraint(item: answerRow, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10)
            self.mainView.addConstraints([top,left,right])
            let height:NSLayoutConstraint = NSLayoutConstraint(item: answerRow, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight))
            answerRow.addConstraint(height)
            
            let topM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 5)
            let leftM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5)
            let rightM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -105)
            let bottomM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -5)
            answerRow.addConstraints([topM,leftM,rightM,bottomM])
            
            let topMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 5)
            let rightMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -5)
            let bottomMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -5)
            answerRow.addConstraints([topMM,rightMM,bottomMM])
            let widthMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
            answerNumber.addConstraint(widthMM)
            
            if self.isTestComplete==false {
                let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("answerIsSelected:"))
                answerNumber.addGestureRecognizer(tapGesture)
            }
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
                        anyButton.setTitleColor(UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0), forState: .Normal)
                        anyButton.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
                        anyButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: self.view.getTextSize(22))
                        //anyButton.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
                        //anyButton.layer.borderWidth = 3.0
                        anyButton.titleLabel?.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
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
                    actButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.5)
                    actButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: self.view.getTextSize(20))
                    actButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
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
                                        
                                        //Move question to selected matchingQuestionLabel
                                        let shapesMargin:Int = 10
                                        let shapesWidth:Int = (Int(self.view.frame.width)-170-4*shapesMargin)/4
                                        var j:Int = 0
                                        let questionAsked:[LogicalPictureView] = self.quizzArray[self.displayedQuestionIndex].question
                                        for j=0;j<4;j++ {
                                            actualSubButton.addSubview(questionAsked[j])
                                            questionAsked[j].translatesAutoresizingMaskIntoConstraints = false
                                            let topMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: actualSubButton, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
                                            let leftMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: actualSubButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(j*(shapesWidth+shapesMargin)))
                                            actualSubButton.addConstraints([topMMM,leftMMM])
                                            let heightMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(shapesWidth))
                                            let widthMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(shapesWidth))
                                            questionAsked[j].addConstraints([heightMMM,widthMMM])
                                            questionAsked[j].backgroundColor = UIColor.clearColor()
                                        }
                                        
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
            exitAlert.showError("No Answer Selected", subTitle: "Please Select An Answer Before Proceeding")
        }
        else {
            //Else go to next question
            //Go to the feedback screen
            if self.displayedQuestionIndex + 1 > self.totalNumberOfQuestions {
                
                if self.resultsUploaded==false {
                    //Stop Timer
                    self.timeTimer.invalidate()
                    
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
                    let analytics = PFObject(className: PF_LOGICAL_CLASS_NAME)
                    analytics[PF_LOGICAL_USER] = user
                    analytics[PF_LOGICAL_SCORE] = self.scoreRatio
                    analytics[PF_LOGICAL_TIME] = timeTaken
                    analytics[PF_LOGICAL_USERNAME] = user![PF_USER_USERNAME]
                    
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
        let buttonHeight:Int = 40
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
            self.feebdackScreen.setConstraintsToSuperview(75, bottom: 20, left: 20, right: 20)
            self.feebdackScreen.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.feebdackScreen.layer.cornerRadius = 8.0
            }, completion: nil)
        
        let topComment:UILabel = UILabel()
        self.feebdackScreen.addSubview(topComment)
        topComment.translatesAutoresizingMaskIntoConstraints = false
        let topMg:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
        let leftMg:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        self.feebdackScreen.addConstraints([topMg,leftMg])
        
        let widthCt:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 80)
        let heightCt:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 15)
        topComment.addConstraints([heightCt,widthCt])
        topComment.text = "Select Question For Feedback"
        topComment.numberOfLines = 0
        topComment.textAlignment = NSTextAlignment.Center
        topComment.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        topComment.textColor = UIColor.whiteColor()
        
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
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+10) + 40))
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
            self.feebdackScreen.addConstraints([topMargin,leftMargin])
            
            let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 80)
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: CGFloat(buttonHeight))
            answerUIButton.addConstraints([heightConstraint,widthConstraint])
            
            let topM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let rightM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            let leftM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 50)
            let bottomM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topM,rightM,leftM,bottomM])
            
            let topMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let leftMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let bottomMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topMM,leftMM,bottomMM])
            let widthMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
            answerNumber.addConstraint(widthMM)
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("displayAnswerWithFeedback:"))
            answerUIButton.addGestureRecognizer(tapGesture)
            
        }
        
        self.feebdackScreen.scrollEnabled = true
        let totalHeight:CGFloat = CGFloat((self.selectedAnswers.count+1) * (buttonHeight + 10))
        self.feebdackScreen.contentSize = CGSize(width: (self.view.frame.width - 40), height: totalHeight+10)
        self.nextButton.text = "Back to Results"
    }
    
    func displayAnswerWithFeedback(gesture:UITapGestureRecognizer) {
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.mainView.alpha = 1.0
            self.swipeUIView.alpha = 1.0
            self.feebdackScreen.alpha = 0.0
            
            var questionFeedback:Int = Int()
            let buttonTapped:UIView? = gesture.view
            if let actualButton = buttonTapped {
                questionFeedback = actualButton.tag
            }
            
            self.displayQuestion(questionFeedback)
            if self.quizzArray[questionFeedback].correctAnswer == self.selectedAnswers[questionFeedback] {
                self.timeLabel.text = "Correct Answer"
                self.timeLabel.textColor = UIColor.greenColor()
            }
            else {
                self.timeLabel.text = "Wrong Answer"
                self.timeLabel.textColor = UIColor.redColor()
            }

            //**************
            let correctAnswer:Int = self.quizzArray[questionFeedback].correctAnswer
            let answerSelect:Int = self.selectedAnswers[questionFeedback]
            //**************
            self.mainView.userInteractionEnabled = false
            for element in self.mainView.subviews {
                if let answer = element as? UIButton {
                    if answer.tag == (answerSelect+1) {
                        answer.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.3)
                    } else {
                        answer.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.0)
                    }
                    for answerNb in answer.subviews {
                            if let answerRow = answerNb as? UIButton {
                                if answerRow.tag == (answerSelect+1)*10 {
                                    answerRow.layer.borderColor = UIColor.redColor().CGColor
                                    answerRow.backgroundColor = UIColor.redColor()
                                    answerRow.titleLabel?.textColor = UIColor.whiteColor()
                                }
                                if answerRow.tag == (correctAnswer+1)*10 {
                                    answerRow.layer.borderColor = UIColor.greenColor().CGColor
                                    answerRow.backgroundColor = UIColor.greenColor()
                                    answerRow.titleLabel?.textColor = UIColor.whiteColor()
                                }
                                if answerRow.tag == (answerSelect+1)*100 {
                                    //Move question to selected matchingQuestionLabel
                                    answerRow.alpha = 1.0
                                    let shapesMargin:Int = 10
                                    let shapesWidth:Int = (Int(self.view.frame.width)-170-4*shapesMargin)/4
                                    var j:Int = 0
                                    let questionAsked:[LogicalPictureView] = self.quizzArray[questionFeedback].question
                                    for j=0;j<4;j++ {
                                        answerRow.addSubview(questionAsked[j])
                                        questionAsked[j].translatesAutoresizingMaskIntoConstraints = false
                                        let topMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
                                        let leftMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerRow, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(j*(shapesWidth+shapesMargin)))
                                        answerRow.addConstraints([topMMM,leftMMM])
                                        let heightMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(shapesWidth))
                                        let widthMMM:NSLayoutConstraint = NSLayoutConstraint(item: questionAsked[j], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(shapesWidth))
                                        questionAsked[j].addConstraints([heightMMM,widthMMM])
                                        questionAsked[j].backgroundColor = UIColor.clearColor()
                                    }
                                }
                        }
                    }
                }
            }
            //**************
            
            }, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNewQuestion() {
        //Add a new question to the array
        let newQuestion:logicalQuestion = logicalQuestion()
        let (questionShapes, answerShapes, correctIndex) = self.fillArrayWithRandomNumbers()
        newQuestion.question = questionShapes
        newQuestion.answers = answerShapes
        newQuestion.correctAnswer = correctIndex
        self.quizzArray.append(newQuestion)
    }
    
    func fillArrayWithRandomNumbers() -> ([LogicalPictureView], [LogicalPictureView],Int) {
        
        //Set function's variables
        var questionArray:[LogicalPictureView] = [LogicalPictureView]()
        var answersArray:[LogicalPictureView] = [LogicalPictureView]()
        var returnedArray:[LogicalPictureView] = [LogicalPictureView]()
        var correctIndex:Int = Int()
        var randomIndex:Int = Int()
        var correctIndexSet:Bool = false
        var i:Int = 0
        
        //Generate Question and Answers
        let logicalProblem:[[LogicalPictureView]] = self.logicModel.getLogicalProblem()
        questionArray = logicalProblem[0]
        answersArray = logicalProblem[1]
        
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
        return (questionArray, returnedArray, correctIndex)
    }
    
    func setDifficultyLevel() {
        
        //Initialize timer depending on difficulty
        if self.difficulty == "H" {
            self.allowedSeconds = 00
            self.allowedMinutes = 10
            self.totalNumberOfQuestions = 24
        }
        else if self.difficulty == "M" {
            self.allowedSeconds = 00
            self.allowedMinutes = 15
            self.totalNumberOfQuestions = 24
        }
        else {
            self.allowedSeconds = 00
            self.allowedMinutes = 20
            self.totalNumberOfQuestions = 24
        }
    }
}
