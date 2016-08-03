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
import SwiftSpinner

class BrainBreakerViewController: QuestionViewController, UIScrollViewDelegate {
    
    //Declare variables
    let backgroungUIView:UIView = UIView()
    let menuBackButton:UIView = UIView()
    var menuBackButtonLeft:NSLayoutConstraint = NSLayoutConstraint()
    let questionMenu:UIView = UIView()
    var questionMenuRight:NSLayoutConstraint = NSLayoutConstraint()
    let questionMenuLabel:UILabel = UILabel()
    var widthRatio:CGFloat = CGFloat()
    var heightRatio:CGFloat = CGFloat()
    var tutoPage:Int = Int()
    let tutoView:UIView = UIView()
    let tutoDescription:UILabel = UILabel()
    let tutoDescription2:UILabel = UILabel()
    var tutoViewLeft:NSLayoutConstraint = NSLayoutConstraint()
    let tutoNextButton:UIButton = UIButton()
    var tutoViewTop:NSLayoutConstraint = NSLayoutConstraint()
    var tutoViewHeight:NSLayoutConstraint = NSLayoutConstraint()
    var tutoViewWidth:NSLayoutConstraint = NSLayoutConstraint()
    
    //Verbal Reasoning variables
    let swipeUIView:UIView = UIView()
    var swipeMenuHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    var swipeMenuBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
    let swipeMenuTopBar:UIView = UIView()
    let timeLabel:UILabel = UILabel()
    var timeTimer:NSTimer = NSTimer()
    let descriptionSwipeLabel:UILabel = UILabel()
    let mainView:UIView = UIView()
    let questionView:UIView = UIView()
    let passageView:UIView = UIView()
    let passageLabel:UITextView = UITextView()
    var quizzArray:[verbalQuestion] = [verbalQuestion]()
    var displayedQuestionIndex:Int = 0
    var totalNumberOfQuestions:Int = 0
    let questionLabel:UITextView = UITextView()
    var allowedSeconds:Int = Int()
    var allowedMinutes:Int = Int()
    var countSeconds:Int = Int()
    var countMinutes:Int = Int()
    let answerView:UIView = UIView()
    let nextButton:UILabel = UILabel()
    var selectedAnswers:[Int] = [Int]()
    var qViewHeight:NSLayoutConstraint = NSLayoutConstraint()
    let feebdackScreen:UIScrollView = UIScrollView()
    var scoreRatio:Float = Float()
    var isTestComplete:Bool = false
    var resultsUploaded:Bool = false
    var testEnded:Bool = false
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //Question Variables
    var questionType:String = String()
    var passage:String = String()
    var question:String = String()
    var answers:[String] = [String]()
    var correctAnswer:Int = Int()
    var explanation:String = String()
    var attemptsRemaining:Int = Int()
    var currentPrize:String = String()
    var timer:NSTimer = NSTimer()
    var newLabel:String = String()
    var questionNumber:Int = Int()
    var startTime:CFAbsoluteTime = CFAbsoluteTime()
    var time:Int = Int()
    
    //ViewDidLoad call
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionType = self.defaults.objectForKey("BrainBreakerQuestionType") as? String ?? String()
        self.passage = self.defaults.objectForKey("BrainBreakerPassage") as? String ?? String()
        self.question = self.defaults.objectForKey("BrainBreakerQuestion") as? String ?? String()
        self.answers = self.defaults.objectForKey("BrainBreakerAnswers") as? [String] ?? [String]()
        self.correctAnswer = self.defaults.integerForKey("BrainBreakerCorrectAnswerIndex")
        self.explanation = self.defaults.objectForKey("BrainBreakerExplanation") as? String ?? String()
        self.attemptsRemaining = self.defaults.integerForKey("NoOfBrainBreakerLives")
        self.currentPrize = self.defaults.objectForKey("BrainBreakerTestPrize") as? String ?? String()
        self.questionNumber = self.defaults.integerForKey("BrainBreakerQuestionNumber")
        
        //self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "brainBreakerTimer", userInfo: nil, repeats: true)
        
        //Initialize timer
        self.allowedSeconds = 00
        self.allowedMinutes = self.defaults.integerForKey("MinutesToAnswerBrainBreaker")
        self.countSeconds = self.allowedSeconds
        self.countMinutes = self.allowedMinutes
        
        //Screen size
        self.tutoPage = 0
        let screenFrame:CGRect = UIScreen.mainScreen().bounds
        self.widthRatio = screenFrame.size.width / 414
        self.heightRatio = screenFrame.size.height / 736

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
        
        //Initialize menuBackButton UIView
        self.view.addSubview(self.menuBackButton)
        self.menuBackButton.translatesAutoresizingMaskIntoConstraints = false
        let topMenuViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        let topMenuViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        let topMenuViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35*self.heightRatio)
        self.menuBackButtonLeft = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -1000)
        self.menuBackButton.addConstraints([topMenuViewHeight, topMenuViewWidth])
        self.view.addConstraints([self.menuBackButtonLeft,topMenuViewTopMargin])
        self.menuBackButton.layer.cornerRadius = 8.0
        
        //Display Previous Button
        let menuBackImageVIew:UIImageView = UIImageView()
        menuBackImageVIew.image = UIImage(named: "prevButton")
        menuBackImageVIew.translatesAutoresizingMaskIntoConstraints = false
        self.menuBackButton.addSubview(menuBackImageVIew)
        let arrowTop:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant:0)
        let arrowLeft:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant:0)
        let arrowHeight:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        let arrowWidth:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        self.menuBackButton.addConstraints([arrowTop,arrowLeft])
        menuBackImageVIew.addConstraints([arrowHeight,arrowWidth])
        let tapGestureBackHome:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("backHome:"))
        tapGestureBackHome.numberOfTapsRequired = 1
        self.menuBackButton.addGestureRecognizer(tapGestureBackHome)
        
        //Initialize questionMenu UIView
        self.view.addSubview(self.questionMenu)
        self.questionMenu.translatesAutoresizingMaskIntoConstraints = false
        let questionViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        let questionViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 40*self.widthRatio)
        let questionViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35*self.heightRatio)
        self.questionMenuRight = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 1000)
        self.questionMenu.addConstraints([questionViewHeight, questionViewWidth])
        self.view.addConstraints([self.questionMenuRight,questionViewTopMargin])
        self.view.bringSubviewToFront(self.menuBackButton)
        
        self.questionMenu.addSubview(self.questionMenuLabel)
        self.questionMenuLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        questionMenuLabel.textAlignment = NSTextAlignment.Center
        
        //Verbal Reasoning:
        
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
        self.swipeMenuTopBar.addSubview(self.descriptionSwipeLabel)
        self.descriptionSwipeLabel.setConstraintsToSuperview(Int(30*self.heightRatio), bottom: 0, left: 0, right: 0)
        self.descriptionSwipeLabel.text = "Swipe up for Answers"
        self.descriptionSwipeLabel.font = UIFont(name: "HelveticaNeue-Medium",size: self.view.getTextSize(14))
        self.descriptionSwipeLabel.textAlignment = NSTextAlignment.Center
        self.descriptionSwipeLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.descriptionSwipeLabel.userInteractionEnabled = true
        self.swipeUIView.addSubview(self.answerView)
        self.answerView.translatesAutoresizingMaskIntoConstraints = false
        self.answerView.setConstraintsToSuperview(Int(80*self.heightRatio), bottom: Int(70*self.heightRatio), left: 0, right: 0)
        
        //Initialize mainView, questionView and passageView
        self.view.addSubview(self.mainView)
        self.mainView.setConstraintsToSuperview(Int(75*self.heightRatio), bottom: Int(85*self.heightRatio), left: Int(20*self.widthRatio), right: Int(20*self.widthRatio))
        self.mainView.addSubview(self.questionView)
        self.mainView.addSubview(self.passageView)
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
        
        //Design of passageView
        self.passageView.addSubview(self.passageLabel)
        self.passageLabel.setConstraintsToSuperview(Int(50*self.heightRatio), bottom: Int(40*self.heightRatio), left: Int(40*self.widthRatio), right: Int(40*self.widthRatio))
        self.passageLabel.textColor = UIColor.blackColor()
        self.passageView.backgroundColor = UIColor.whiteColor()
        self.passageLabel.font = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(16))
        self.passageLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        self.passageView.layer.cornerRadius = 10.0
        self.passageLabel.textAlignment = NSTextAlignment.Justified
        
        //update questionView
        self.questionView.addSubview(self.questionLabel)
        self.questionLabel.setConstraintsToSuperview(Int(10*self.heightRatio), bottom: 0, left: Int(15*self.widthRatio), right: Int(15*self.widthRatio))
        self.questionLabel.textColor = UIColor.whiteColor()
        self.questionLabel.font = UIFont(name: "HelveticaNeue-Bold",size: self.view.getTextSize(17))
        self.questionLabel.textAlignment = NSTextAlignment.Center
        self.questionLabel.backgroundColor = UIColor(white: 0, alpha: 0)
        self.questionView.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.questionView.layer.cornerRadius = 8.0
        
        //Update top constraint
        let passageViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 100*self.heightRatio)
        let passageViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let passageViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let passageViewBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.mainView.addConstraints([passageViewTop,passageViewRight,passageViewLeft,passageViewBottom])
        
        //Create nextButton
        let nextUIView:UIView = UIView()
        self.swipeUIView.addSubview(nextUIView)
        nextUIView.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.nextButton.textColor = UIColor.whiteColor()
        self.nextButton.textAlignment = NSTextAlignment.Center
        self.nextButton.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        self.nextButton.text = "Submit Answer"
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 380*self.heightRatio)
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
        
        //Initialize swipeUIView
        self.view.addSubview(self.swipeUIView)
        self.swipeUIView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeMenuHeightConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 450*self.heightRatio)
        self.swipeUIView.addConstraint(self.swipeMenuHeightConstraint)
        self.swipeMenuBottomConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 380*self.heightRatio)
        let leftMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20*self.widthRatio)
        let rightMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20*self.widthRatio)
        self.view.addConstraints([leftMargin,rightMargin,self.swipeMenuBottomConstraint])
        self.swipeUIView.backgroundColor = UIColor.whiteColor()
        self.swipeUIView.layer.cornerRadius = 8.0
        var swipeUpGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
        var swipeDownGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeUpGesture = UISwipeGestureRecognizer.init(target: self, action: Selector("showSwipeMenu:"))
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.Up
        self.swipeUIView.addGestureRecognizer(swipeUpGesture)
        swipeDownGesture = UISwipeGestureRecognizer.init(target: self, action: Selector("hideSwipeMenu:"))
        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.Down
        self.swipeUIView.addGestureRecognizer(swipeDownGesture)
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //Call tutoNextPage
        self.tutoNext()
        self.setConstraints()
        let dateBB = NSDate().dateByAddingTimeInterval(0)
        self.timer = NSTimer(fireDate: dateBB, interval: 1, target: self, selector: "brainBreakerTimer", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func goBackHome(sender:UITapGestureRecognizer) {
        goBack()
    }
    
    func goBack(){
        self.performSegueWithIdentifier("backHomeSegue", sender: nil)
    }
    
    func setConstraints() {
        
        self.tutoViewTop = NSLayoutConstraint(item: self.tutoView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 75*self.heightRatio)
        self.view.addConstraints([self.tutoViewTop,self.tutoViewLeft])
        
    }
    func tutoNext() {
        
        if self.tutoPage==0 {
            
            self.passageView.alpha = 0.0
            self.swipeUIView.alpha = 0.0
            self.questionView.alpha = 0.0
            
            //Display Page Title
            let labelString:String = String("BRAIN BREAKER")
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 6, length: NSString(string: labelString).length-6))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: NSString(string: labelString).length))
            self.questionMenuLabel.attributedText = attributedString
            
            //Display TutoView
            self.view.addSubview(self.tutoView)
            self.tutoView.translatesAutoresizingMaskIntoConstraints = false
            self.tutoViewTop = NSLayoutConstraint(item: self.tutoView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 2000*self.heightRatio)
            self.tutoViewHeight = NSLayoutConstraint(item: self.tutoView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.height - 95*self.heightRatio)
            self.tutoViewWidth = NSLayoutConstraint(item: self.tutoView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: self.view.frame.width - 40*self.widthRatio)
            self.tutoViewLeft = NSLayoutConstraint(item: self.tutoView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20*self.widthRatio)
            self.view.addConstraints([self.tutoViewTop,self.tutoViewLeft])
            self.tutoView.addConstraints([self.tutoViewHeight,self.tutoViewWidth])
            self.tutoView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            self.tutoView.layer.cornerRadius = 8.0
            
            //Tuto Description
            self.tutoView.addSubview(self.tutoDescription)
            self.tutoDescription.translatesAutoresizingMaskIntoConstraints = false
            let tutoDescriptionTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10*self.heightRatio)
            let tutoDescriptionRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10*self.widthRatio)
            let tutoDescriptionLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10*self.widthRatio)
            self.tutoView.addConstraints([tutoDescriptionTop,tutoDescriptionRight,tutoDescriptionLeft])
            let tutoDescriptionHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 210*self.heightRatio)
            self.tutoDescription.addConstraint(tutoDescriptionHeight)
            self.tutoDescription.textColor = UIColor.whiteColor()
            self.tutoDescription.font = UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(15))
            self.tutoDescription.textAlignment = NSTextAlignment.Center
            self.tutoDescription.numberOfLines = 0
            self.tutoDescription.text = "The Brain Breaker competition is the chance for you to win an amazing prize. Premium users have three attempts to answer correctly, whilst free users have one. \n\nIf you do get it right, you will be in with a chance to win the prize below."
            
            //Tuto Description 2
            self.tutoView.addSubview(self.tutoDescription2)
            self.tutoDescription2.translatesAutoresizingMaskIntoConstraints = false
            let tutoDescription2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 220*self.heightRatio)
            let tutoDescription2Right:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription2, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10*self.widthRatio)
            let tutoDescription2Left:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10*self.widthRatio)
            self.tutoView.addConstraints([tutoDescription2Top,tutoDescription2Right,tutoDescription2Left])
            let tutoDescription2Height:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.height - (100+210+10+90))
            self.tutoDescription2.addConstraint(tutoDescription2Height)
            self.tutoDescription2.textColor = UIColor.whiteColor()
            self.tutoDescription2.font = UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(15))
            self.tutoDescription2.textAlignment = NSTextAlignment.Center
            self.tutoDescription2.numberOfLines = 0
            self.tutoDescription2.text = "Attempts Remaining:\n\(self.attemptsRemaining)\n\nCurrent Brain Breaker Prize:\n \(self.currentPrize)\n\nCurrent Brain Breaker Ends in:\n\(self.newLabel)\n"

            //Start Button
            self.tutoView.addSubview(self.tutoNextButton)
            self.tutoNextButton.translatesAutoresizingMaskIntoConstraints = false
            let tutoNextButtonBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -20*self.heightRatio)
            let tutoNextButtonLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 40*self.widthRatio)
            let tutoNextButtonRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -40*self.widthRatio)
            self.tutoView.addConstraints([tutoNextButtonBottom,tutoNextButtonLeft,tutoNextButtonRight])
            let tutoNextButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.heightRatio)
            self.tutoNextButton.addConstraint(tutoNextButtonHeight)
            self.tutoNextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            self.tutoNextButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.tutoNextButton.setTitle("Start", forState: .Normal)
            self.tutoNextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            self.tutoNextButton.titleLabel?.textAlignment = NSTextAlignment.Center
            let tutoNextButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("startTest:"))
            self.tutoNextButton.addGestureRecognizer(tutoNextButtonTap)
            self.tutoView.alpha = 1.0
            
            //Animate constraints
            UIView.animateWithDuration(0.75, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.questionMenuRight.constant = -20*self.widthRatio
                self.menuBackButtonLeft.constant = 20*self.widthRatio
                self.view.layoutIfNeeded()
            }, completion: nil)
            self.setConstraints()
        }
        
    }
    
    func startTest(sender:UITapGestureRecognizer) {
        
        if (self.attemptsRemaining > 0) {
            
            self.attemptsRemaining--
            self.defaults.setInteger(self.attemptsRemaining, forKey: "NoOfBrainBreakerLives")
        
        self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        UIView.animateWithDuration(0.75, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.passageView.alpha = 1.0
            self.swipeUIView.alpha = 1.0
            self.tutoView.alpha = 0.0
            self.questionView.alpha = 1.0
            }, completion: nil)
            
        }else if (tutoNextButton.titleLabel == "Return Home"){
            
        goBack()
        
        }else{
            
            var alertMessage:String = String()
            alertMessage = "You have no attempts remaining"
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
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
    
    //Show Swipe Menu
    func showSwipeMenu(sender: UISwipeGestureRecognizer) {
        UIView.animateWithDuration(1, animations: {
            self.swipeMenuBottomConstraint.constant = 5*self.heightRatio
            self.view.layoutIfNeeded()
            self.passageView.alpha = 0.0
            self.descriptionSwipeLabel.text = "Swipe down for Question"
            }, completion: nil)
    }
    
    //Hie Swipe Menu
    func hideSwipeMenu(sender: UISwipeGestureRecognizer) {
        UIView.animateWithDuration(1, animations: {
            self.swipeMenuBottomConstraint.constant = 380*self.heightRatio
            self.view.layoutIfNeeded()
            self.passageView.alpha = 1.0
            self.descriptionSwipeLabel.text = "Swipe up for Answers"
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
    
    func displayQuestion(arrayOfQuestions:[verbalQuestion], indexQuestion:Int) {
        
        self.passageLabel.text = self.quizzArray[indexQuestion].passage
        //Update the view with the new question
        let questionText:String = arrayOfQuestions[indexQuestion].question
        self.questionLabel.text = questionText
        // add answers to SwipeUIVIew
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
    
    func feedbackScreen() {
        self.timeTimer.invalidate()
        UIView.animateWithDuration(0.75, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.passageView.alpha = 0.0
            self.swipeUIView.alpha = 0.0
            self.questionView.alpha = 0.0
            self.tutoView.alpha = 1.0
            }, completion: nil)
        if self.quizzArray[0].correctAnswer == self.selectedAnswers[0] {
            self.tutoDescription.text = "Correct Answer!\n\nWell done, you are now in with a chance of winning the Brain Breaker prize! The winner(s) will be announced on our social media pages and we will be in touch by email"
        } else {
            self.tutoDescription.text = "Wrong Answer!\n\nUnlucky, please try again when we release our next Brain Breaker Question to be in with a chance of winning a great prize!\n\nJust to let you know, if you sign up for our premium membership, you are allowed up to three attempts at answering the Brain Breaker..."
        }
        self.tutoDescription2.text = "Enjoy the rest of Break IN2..."
        self.tutoNextButton.setTitle("Return to Home", forState: .Normal)
        let tutoNextButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("goBackHome:"))
        self.tutoNextButton.addGestureRecognizer(tutoNextButtonTap)
    }
    
    func brainBreakerTimer(){
        
        startTime = CFAbsoluteTimeGetCurrent()
        let initialTime: NSDate = defaults.objectForKey("BrainBreakerExpirationDate") as! NSDate
        let diff:CFTimeInterval = initialTime.timeIntervalSinceReferenceDate - startTime
        time = Int(diff)
        //self.time = Int(diff)
        //let diff = startTime - initialTime
        
        
        if self.time > 0 {
        //self.time = max(self.secondsBetweenLives - Int(diff), 0)
        let newHour:String = String(format: "%02d", (self.time / 3600))
        let newMin:String = String(format: "%02d", (self.time % 3600) / 60)
        let newSec:String = String(format: "%02d", (self.time % 3600) % 60)
        self.newLabel = "\(newHour) : \(newMin) : \(newSec)"
        self.tutoDescription2.text = "Attempts Remaining:\n\(self.attemptsRemaining)\n\nCurrent Brain Breaker Prize:\n \(self.currentPrize)\n\nCurrent Brain Breaker Ends in:\n\(self.newLabel)\n"
        
        }else{
            
            self.newLabel = "Current Brain Breaker Ended, New Question Coming Soon!"
            self.tutoDescription2.text = "Attempts Remaining:\n\(self.attemptsRemaining)\n\nCurrent Brain Breaker Prize:\n \(self.currentPrize)\n\nCurrent Brain Breaker Ends in:\n\(self.newLabel)\n"
            
            self.tutoNextButton.setTitle("Return Home", forState: .Normal)
            let tutoNextButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("goBackHome:"))
            self.tutoNextButton.addGestureRecognizer(tutoNextButtonTap)
            
            self.timer.invalidate()
            
            
        }
        
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
                        self.descriptionSwipeLabel.text = "Swipe up for Answers"
                        }, completion: nil)
                    self.displayedQuestionIndex++
                    if self.displayedQuestionIndex==self.totalNumberOfQuestions{
                        //Switch Button text to "Complete"
                        self.nextButton.text = "Complete Test"
                    }
                    self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
                }
            }
        }
    
}
    