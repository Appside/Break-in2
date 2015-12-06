//
//  quizzPageViewController.swift
//  Break in2
//
//  Created by Jean-Charles Koch on 24/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import Charts

class QuizzViewController: UIViewController, UIScrollViewDelegate {
    
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
    let descriptionSwipeLabel:UILabel = UILabel()
    let mainScrollView:UIScrollView = UIScrollView()
    let questionView:UIView = UIView()
    let graphView:UIView = UIView()
    var quizzModel:QuizzModel = QuizzModel()
    var quizzArray:[Question] = [Question]()
    var displayedQuestionIndex:Int = 0
    var totalNumberOfQuestions:Int = 19
    let questionLabel:UITextView = UITextView()
    var countSeconds:Int = 00
    var countMinutes:Int = 20
    let answerView:UIView = UIView()
    let nextButton:UILabel = UILabel()
    var selectedAnswers:[Int] = [Int]()
    
    //ViewDidLoad call
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize backgroun UIView
        self.view.addSubview(self.backgroungUIView)
        self.backgroungUIView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.backgroungUIView.addHomeBG()
        
        //Initialize menuBackButton UIView
        self.view.addSubview(self.menuBackButton)
        self.menuBackButton.translatesAutoresizingMaskIntoConstraints = false
        let topMenuViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
        let topMenuViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 75)
        let topMenuViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35)
        let topMenuViewLeftMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        self.menuBackButton.addConstraints([topMenuViewHeight, topMenuViewWidth])
        self.view.addConstraints([topMenuViewLeftMargin,topMenuViewTopMargin])
        self.menuBackButton.layer.cornerRadius = 8.0
        self.menuBackButton.backgroundColor = UIColor.whiteColor()
        let menuLabel:UILabel = UILabel()
        menuLabel.text = "Menu"
        self.menuBackButton.addSubview(menuLabel)
        menuLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        menuLabel.textAlignment = NSTextAlignment.Center
        menuLabel.font = UIFont(name: "HelveticaNeue-Medium",size: 15.0)
        //self.menuBackButton.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
        //self.menuBackButton.layer.borderWidth = 3.0
        menuLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        let tapGestureBackHome:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("backHome:"))
        tapGestureBackHome.numberOfTapsRequired = 1
        self.menuBackButton.addGestureRecognizer(tapGestureBackHome)
        
        //Initialize questionMenu UIView
        self.view.addSubview(self.questionMenu)
        self.questionMenu.translatesAutoresizingMaskIntoConstraints = false
        let questionViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
        let questionViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 135)
        let questionViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35)
        let questionViewRightMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
        self.questionMenu.addConstraints([questionViewHeight, questionViewWidth])
        self.view.addConstraints([questionViewRightMargin,questionViewTopMargin])
        self.questionMenu.layer.cornerRadius = 8.0
        self.questionMenu.backgroundColor = UIColor.whiteColor()
        self.questionMenuLabel.text = "Question 01/20"
        self.questionMenu.addSubview(self.questionMenuLabel)
        self.questionMenuLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        questionMenuLabel.textAlignment = NSTextAlignment.Center
        questionMenuLabel.font = UIFont(name: "HelveticaNeue-Medium",size: 15.0)
        //self.questionMenu.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
        //self.questionMenu.layer.borderWidth = 3.0
        self.questionMenuLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        
        //Initialize swipeMenuTopBar UIView
        self.swipeUIView.addSubview(self.swipeMenuTopBar)
        self.swipeMenuTopBar.translatesAutoresizingMaskIntoConstraints = false
        let swipeMenuTopBarTop:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
        let swipeMenuTopBarLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
        let swipeMenuTopBarRight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10)
        self.swipeUIView.addConstraints([swipeMenuTopBarTop,swipeMenuTopBarLeft,swipeMenuTopBarRight])
        let swipeMenuTopBarHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 70)
        self.swipeMenuTopBar.addConstraint(swipeMenuTopBarHeight)
        self.swipeMenuTopBar.addSubview(self.timeLabel)
        self.timeLabel.text = "20:00"
        self.timeLabel.setConstraintsToSuperview(0, bottom: 35, left: 0, right: 0)
        self.timeLabel.font = UIFont(name: "HelveticaNeue-Bold",size: 20.0)
        self.timeLabel.textAlignment = NSTextAlignment.Center
        self.timeLabel.textColor = UIColor.redColor()
        self.timeLabel.userInteractionEnabled = true
        self.swipeMenuTopBar.addSubview(self.descriptionSwipeLabel)
        self.descriptionSwipeLabel.setConstraintsToSuperview(35, bottom: 0, left: 0, right: 0)
        self.descriptionSwipeLabel.text = "Swipe up for Answers"
        self.descriptionSwipeLabel.font = UIFont(name: "HelveticaNeue-Medium",size: 15.0)
        self.descriptionSwipeLabel.textAlignment = NSTextAlignment.Center
        self.descriptionSwipeLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.descriptionSwipeLabel.userInteractionEnabled = true
        self.swipeUIView.addSubview(self.answerView)
        self.answerView.translatesAutoresizingMaskIntoConstraints = false
        self.answerView.setConstraintsToSuperview(100, bottom: 0, left: 0, right: 0)
        
        //Initialize ScrollView, questionView and GraphView
        self.view.addSubview(self.mainScrollView)
        self.mainScrollView.setConstraintsToSuperview(65, bottom: 100, left: 20, right: 20)
        self.mainScrollView.addSubview(self.questionView)
        self.mainScrollView.addSubview(self.graphView)
        self.questionView.translatesAutoresizingMaskIntoConstraints = false
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        
        let questionViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        self.mainScrollView.addConstraint(questionViewTop)
        
        let questionViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
        let questionViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        self.view.addConstraints([questionViewLeft,questionViewRight])
        let questionViewHeight2:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -10)
        self.view.addConstraint(questionViewHeight2)
        
        //update questionView
        self.questionView.addSubview(self.questionLabel)
        self.questionLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.questionLabel.text = "Question test pour verifier si cela fonctionne correctemeent ou s'il y a quelque chose a changer"
        self.questionLabel.textColor = UIColor.whiteColor()
        self.questionLabel.font = UIFont(name: "HelveticaNeue",size: 18.0)
        self.questionLabel.textAlignment = NSTextAlignment.Center
        self.questionLabel.backgroundColor = UIColor(white: 0, alpha: 0)
        
        //Update top constraint
        let graphViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 100)
        let graphViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let graphViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.mainScrollView.addConstraint(graphViewTop)
        self.view.addConstraints([graphViewLeft,graphViewRight])
        
        //Create nextButton
        let nextUIView:UIView = UIView()
        self.swipeUIView.addSubview(nextUIView)
        nextUIView.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.nextButton.textColor = UIColor.whiteColor()
        self.nextButton.textAlignment = NSTextAlignment.Center
        self.nextButton.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        self.nextButton.text = "Next"
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 425)
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
        for answerIndex=0;answerIndex<=self.totalNumberOfQuestions;answerIndex++ {
            let fixedNumber:Int = 20
            self.selectedAnswers.append(fixedNumber)
        }
        
        //Display questions
        self.displayedQuestionIndex = 0
        self.quizzArray = self.quizzModel.selectQuestions()
        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
        
        //Launch timer
        timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        
        //change scrollview contentsize
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width, height: self.graphView.frame.height + self.questionView.frame.height + 200)
        self.mainScrollView.bringSubviewToFront(self.swipeUIView)
        
        //Initialize swipeUIView
        self.view.addSubview(self.swipeUIView)
        self.swipeUIView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeMenuHeightConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 500)
        self.swipeUIView.addConstraint(self.swipeMenuHeightConstraint)
        self.swipeMenuBottomConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 415)
        let leftMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        let rightMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
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
    
    //Show Swipe Menu
    func showSwipeMenu(sender: UISwipeGestureRecognizer) {
        UIView.animateWithDuration(1, animations: {
            self.swipeMenuBottomConstraint.constant = -20
            self.view.layoutIfNeeded()
            self.graphView.alpha = 0.0
            self.descriptionSwipeLabel.text = "Swipe down for Question"
            }, completion: nil)
    }
    
    //Hie Swipe Menu
    func hideSwipeMenu(sender: UISwipeGestureRecognizer) {
        UIView.animateWithDuration(1, animations: {
            self.swipeMenuBottomConstraint.constant = 415
            self.view.layoutIfNeeded()
            self.graphView.alpha = 1.0
            self.descriptionSwipeLabel.text = "Swipe up for Answers"
            }, completion: nil)
    }
    
    func updateTimer() {
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
        timeLabel.text = newLabel
    }
    
    func backHome(sender:UITapGestureRecognizer) {
        let alertController:UIAlertController = UIAlertController(title: "Return to Menu", message: "Are you sure you want to return home? All progress will be lost!", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default) {(action:UIAlertAction!) in
            self.performSegueWithIdentifier("backHomeSegue", sender: nil)}
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {(action:UIAlertAction!) in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func displayQuestion(arrayOfQuestions:[Question], indexQuestion:Int) {
        
        //Initialize labels
        self.questionMenuLabel.text = "Question \(indexQuestion+1) / \(self.totalNumberOfQuestions+1)"
        
        //Update the view with the new question
        let questionText:String = arrayOfQuestions[indexQuestion].question
        self.questionLabel.text = questionText
        
        // add answers to SwipeUIVIew
        for answerSubView in self.answerView.subviews {
            answerSubView.removeFromSuperview()
        }
        let arrayAnswers:[String] = self.quizzArray[indexQuestion].answers
        let buttonHeight:Int = 50
        var i:Int = 0
        
        for i=0; i<arrayAnswers.count;i++ {
            let answerUIButton:UIView = UIView()
            let answerUILabel:UILabel = UILabel()
            let answerNumber:UILabel = UILabel()
            answerUIButton.translatesAutoresizingMaskIntoConstraints = false
            answerUILabel.translatesAutoresizingMaskIntoConstraints = false
            answerNumber.translatesAutoresizingMaskIntoConstraints = false
            self.answerView.addSubview(answerUIButton)
            answerUIButton.addSubview(answerUILabel)
            answerUIButton.addSubview(answerNumber)
            answerNumber.text = String(i+1)
            answerNumber.textAlignment = NSTextAlignment.Center
            answerNumber.textColor = UIColor.whiteColor()
            answerNumber.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            answerUILabel.text = String(arrayAnswers[i])
            answerUILabel.textAlignment = NSTextAlignment.Center
            answerUILabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            answerUILabel.numberOfLines = 0
            answerUILabel.adjustsFontSizeToFitWidth = true
            answerUIButton.backgroundColor = UIColor.whiteColor()
            answerUILabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
            answerUIButton.layer.borderWidth = 3.0
            answerUIButton.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
            
            //Set constraints to answerViews
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+15)))
            let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20))
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20))
            self.answerView.addConstraints([topMargin,rightMargin,leftMargin])
            
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: CGFloat(buttonHeight))
            answerUIButton.addConstraint(heightConstraint)
            
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
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("answerIsSelected:"))
            answerUIButton.addGestureRecognizer(tapGesture)
            
            //Update graph
            for existingView in self.graphView.subviews {
                    existingView.removeFromSuperview()
            }
            let newChartObject = self.createChartObject(self.displayedQuestionIndex)
            newChartObject.translatesAutoresizingMaskIntoConstraints = false
            let newChartObjectLeftMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
            let newChartObjectRightMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
            let newChartObjectTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            self.graphView.addConstraints([newChartObjectLeftMargin,newChartObjectRightMargin,newChartObjectTopMargin])
            let graphHeight:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 400)
            newChartObject.addConstraint(graphHeight)
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
                        if labelsView.text=="1" || labelsView.text=="2" || labelsView.text=="3" || labelsView.text=="4" || labelsView.text=="5" {
                                labelsView.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                                labelsView.textColor = UIColor.whiteColor()
                        }
                    }
                }
            }
            UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                for labels in actualButton.subviews {
                    if let labelView = labels as? UILabel {
                        labelView.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                        labelView.textColor = UIColor.whiteColor()
                        if labelView.text=="1" || labelView.text=="2" || labelView.text=="3" || labelView.text=="4" || labelView.text=="5" {
                                self.selectedAnswers[self.displayedQuestionIndex] = Int(labelView.text!)! - 1
                        }
                    }
                }
                }, completion: nil)
        }
    }
    
    func nextQuestion(gesture:UITapGestureRecognizer) {

        // If no answer is selected, show Alert
        if self.selectedAnswers[self.displayedQuestionIndex] == 20 {
            let alertController:UIAlertController = UIAlertController(title: "No answer selected", message: "You don't have selected any answer", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Go back", style: .Cancel) {(action:UIAlertAction!) in
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            }
        else {
        //Else go to next question
            //Go to the feedback screen
            if self.displayedQuestionIndex + 1 > self.totalNumberOfQuestions {
                self.feedbackScreen()
            }
            //Continue to the next question
            else {
                UIView.animateWithDuration(1, animations: {
                    self.swipeMenuBottomConstraint.constant = 415
                    self.view.layoutIfNeeded()
                    self.graphView.alpha = 1.0
                    self.descriptionSwipeLabel.text = "Swipe up for Answers"
                    }, completion: nil)
                self.displayedQuestionIndex++
                if self.displayedQuestionIndex==self.totalNumberOfQuestions{
                //Switch Button text to "Complete"
                    self.nextButton.text = "Complete Test"
                }
                else {
                    self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
                }
            }
        }
    }
    
    func createChartObject(questionIndex:Int) -> UIView {
        
        //Select and display chartType
        let chartType:String = self.quizzArray[questionIndex].chartType

        if (chartType=="bar") {
            let chartObject:BarChartView = BarChartView()
            
            //Define chart settings
            chartObject.noDataText = "Error while loading data."
            chartObject.descriptionText = self.quizzArray[questionIndex].axisNames[1]
            chartObject.xAxis.labelPosition = .Top
            chartObject.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
            chartObject.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            chartObject.gridBackgroundColor = UIColor(white: 0, alpha: 0)
            chartObject.xAxis.labelTextColor = UIColor.whiteColor()
            chartObject.leftAxis.labelTextColor = UIColor.whiteColor()
            chartObject.rightAxis.labelTextColor = UIColor.whiteColor()
            chartObject.descriptionTextColor = UIColor.whiteColor()
            chartObject.descriptionTextPosition = CGPoint(x: 150, y: 50)
            chartObject.descriptionTextAlign = NSTextAlignment.Center
            chartObject.descriptionFont = UIFont(name: "HelvetivaNeue-Bold", size: 13)
            
            //Add chart bars
            var xValues:[String]!
            xValues = self.quizzArray[questionIndex].barSegmentNames
            let yUnits = self.quizzArray[questionIndex].yAxis
            let legendString:[String] = self.quizzArray[questionIndex].xAxis
            self.setBarChart(chartObject, dataPoints: xValues, values: yUnits, setLegendNames: legendString)
            
            //Return chart UIView
            chartObject.legend.textColor = UIColor.whiteColor()
            chartObject.legend.position = ChartLegend.ChartLegendPosition.BelowChartCenter
            chartObject.legend.form = ChartLegend.ChartLegendForm.Circle
            chartObject.legend.direction = ChartLegend.ChartLegendDirection.LeftToRight
            self.graphView.addSubview(chartObject)
            return chartObject
        }
            
        else if (chartType=="pie") {
            let chartObject:PieChartView = PieChartView()
            
            //Define chart settings
            chartObject.noDataText = "Error while loading data."
            chartObject.descriptionText = self.quizzArray[questionIndex].chartTitle
            chartObject.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
            chartObject.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            chartObject.descriptionTextColor = UIColor.whiteColor()
            chartObject.descriptionTextPosition = CGPoint(x: 150, y: 50)
            chartObject.descriptionTextAlign = NSTextAlignment.Center
            chartObject.descriptionFont = UIFont(name: "HelvetivaNeue-Bold", size: 13)
            
            //Add Pie Chart
            var xValues:[String]!
            xValues = self.quizzArray[questionIndex].pieSegmentNames
            let yUnits = self.quizzArray[questionIndex].pieSegmentPercentages
            self.setPieChart(chartObject, dataPoints: xValues, values: yUnits)
            
            //Return chart UIView
            chartObject.legend.textColor = UIColor.whiteColor()
            chartObject.legend.position = ChartLegend.ChartLegendPosition.BelowChartCenter
            chartObject.legend.form = ChartLegend.ChartLegendForm.Circle
            chartObject.legend.direction = ChartLegend.ChartLegendDirection.LeftToRight
            self.graphView.addSubview(chartObject)
            return chartObject
        }
            
        else if (chartType=="line") {
            let chartObject:LineChartView = LineChartView()

            //Define chart settings
            chartObject.noDataText = "Error while loading data."
            chartObject.descriptionText = self.quizzArray[questionIndex].axisNames[1]
            chartObject.xAxis.labelPosition = .Top
            chartObject.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
            chartObject.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            chartObject.gridBackgroundColor = UIColor(white: 0, alpha: 0)
            chartObject.xAxis.labelTextColor = UIColor.whiteColor()
            chartObject.leftAxis.labelTextColor = UIColor.whiteColor()
            chartObject.rightAxis.labelTextColor = UIColor.whiteColor()
            chartObject.descriptionTextColor = UIColor.whiteColor()
            chartObject.descriptionTextPosition = CGPoint(x: 150, y: 50)
            chartObject.descriptionTextAlign = NSTextAlignment.Center
            chartObject.descriptionFont = UIFont(name: "HelvetivaNeue-Bold", size: 13)
            
            //Add chart lines
            var xValues:[String]!
            xValues = self.quizzArray[questionIndex].xAxis
            let yUnits = self.quizzArray[questionIndex].yAxis
            let legendString:[String] = self.quizzArray[questionIndex].lineNames
            self.setLineChart(chartObject, dataPoints: xValues, values: yUnits, setLegendNames: legendString)
            
            //Return chart UIView
            chartObject.legend.textColor = UIColor.whiteColor()
            chartObject.legend.position = ChartLegend.ChartLegendPosition.BelowChartCenter
            chartObject.legend.form = ChartLegend.ChartLegendForm.Circle
            chartObject.legend.direction = ChartLegend.ChartLegendDirection.LeftToRight
            self.graphView.addSubview(chartObject)
            return chartObject
        }
            
        else {
            return UIView()
        }
    }
    
    func setBarChart(chartView:BarChartView, dataPoints: [String], values: [[Double]], setLegendNames:[String]) -> BarChartView {
        chartView.noDataText = "Error while loading data."
        
        var colorsChart:[UIColor] = [UIColor]()
        colorsChart = [UIColor.redColor(),UIColor.yellowColor(),UIColor.greenColor(),UIColor.blueColor(),UIColor.orangeColor()]
        
        var dataEntries: [ChartDataEntry] = []
        var y:Int = 0
        var chartDataSets:[BarChartDataSet] = [BarChartDataSet]()
        
        for y=0;y<values.count;y++ {
            for i in 0..<dataPoints.count {
                let dataEntry = BarChartDataEntry(value: values[y][i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            let chartDataSet = BarChartDataSet(yVals: dataEntries, label: setLegendNames[y])
            //let ll = ChartLimitLine(limit: 10.0, label: "Target")
            //chartView.rightAxis.addLimitLine(ll)
            chartDataSet.setColor(colorsChart[y])
            chartDataSets.append(chartDataSet)
            dataEntries.removeAll()
        }
        
        let chartData = BarChartData(xVals: dataPoints, dataSets: chartDataSets)
        chartView.data = chartData
        chartData.setValueTextColor(UIColor.whiteColor())
        return chartView
        
    }
    
    func setPieChart(chartView:PieChartView, dataPoints: [String], values: [Double]) -> PieChartView {

        var colorsChart:[UIColor] = [UIColor]()
        colorsChart = [UIColor.redColor(),UIColor.yellowColor(),UIColor.greenColor(),UIColor.blueColor(),UIColor.orangeColor()]
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        var colors: [UIColor] = []
        for y in 0..<dataPoints.count {
            colors.append(colorsChart[y])
        }
        chartView.data = pieChartData
        pieChartDataSet.colors = colors
        return chartView
    }
    
    func setLineChart(chartView:LineChartView, dataPoints: [String], values: [[Double]], setLegendNames:[String]) -> LineChartView {

        var colorsChart:[UIColor] = [UIColor]()
        colorsChart = [UIColor.redColor(),UIColor.yellowColor(),UIColor.greenColor(),UIColor.blueColor(),UIColor.orangeColor()]
        
        var dataEntries: [ChartDataEntry] = []
        var y:Int = 0
        var lineChartDataSets:[LineChartDataSet] = [LineChartDataSet]()
        
        for y=0;y<values.count;y++ {
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[y][i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: setLegendNames[y])
            lineChartDataSet.setColor(colorsChart[y])
            lineChartDataSet.setCircleColor(colorsChart[y])
            lineChartDataSet.fillColor = colorsChart[y]
            lineChartDataSets.append(lineChartDataSet)
            dataEntries.removeAll()
        }
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSets: lineChartDataSets)
        
        chartView.data = lineChartData
        lineChartData.setValueTextColor(UIColor.whiteColor())
        return chartView
    }
    
    func feedbackScreen() {
        //Display feedback screen here
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}