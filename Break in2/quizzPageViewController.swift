//
//  quizzPageViewController.swift
//  Break in2
//
//  Created by Jean-Charles Koch on 24/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import Charts

class quizzPageViewController: UIViewController, UIScrollViewDelegate {
    
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
    var totalNumberOfQuestions:Int = 2
    let questionLabel:UILabel = UILabel()
    var countSeconds:Int = 00
    var countMinutes:Int = 20
    let answerView:UIView = UIView()
    let nextButton:UILabel = UILabel()
    
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
        self.mainScrollView.setConstraintsToSuperview(75, bottom: 100, left: 20, right: 20)
        self.mainScrollView.addSubview(self.questionView)
        self.mainScrollView.addSubview(self.graphView)
        self.questionView.translatesAutoresizingMaskIntoConstraints = false
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        
        let questionViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        self.mainScrollView.addConstraint(questionViewTop)

        let questionViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
        let questionViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        self.view.addConstraints([questionViewLeft,questionViewRight])
        
        //update questionView
        self.questionView.addSubview(self.questionLabel)
        self.questionLabel.setConstraintsToSuperview(15, bottom: 0, left: 0, right: 0)
        self.questionLabel.text = "Question test pour verifier si cela fonctionne correctemeent ou s'il y a quelque chose a changer"
        self.questionLabel.textColor = UIColor.whiteColor()
        self.questionLabel.font = UIFont(name: "HelveticaNeue",size: 20.0)
        self.questionLabel.textAlignment = NSTextAlignment.Center
        self.questionLabel.numberOfLines = 0
        
        //Update top constraint
        let graphViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 100)
        let graphViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let graphViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.mainScrollView.addConstraint(graphViewTop)
        self.view.addConstraints([graphViewLeft,graphViewRight])
        
        //Display questions
        self.displayedQuestionIndex = 0
        self.quizzArray = self.quizzModel.selectQuestions()
        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
        
        let newChartObject = self.createChartObject()
        
        newChartObject.translatesAutoresizingMaskIntoConstraints = false
        let newChartObjectLeftMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let newChartObjectRightMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let newChartObjectTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        self.graphView.addConstraints([newChartObjectLeftMargin,newChartObjectRightMargin,newChartObjectTopMargin])
        let graphHeight:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 450)
        newChartObject.addConstraint(graphHeight)
        
        //Launch timer
        timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        
        //change scrollview contentsize
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width, height: self.graphView.frame.height + self.questionView.frame.height + 200)
        self.mainScrollView.bringSubviewToFront(self.swipeUIView)
        
        //Create nextButton
        self.swipeUIView.addSubview(self.nextButton)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.nextButton.textColor = UIColor.whiteColor()
        self.nextButton.textAlignment = NSTextAlignment.Center
        self.nextButton.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        self.nextButton.text = "Next"
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 425)
        let rightLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20))
        let leftLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20))
        self.swipeUIView.addConstraints([topLabelMargin,rightLabelMargin,leftLabelMargin])
        let heightLabelConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 50)
        self.nextButton.addConstraint(heightLabelConstraint)
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "nextQuestion:")
        self.nextButton.addGestureRecognizer(tapGesture)
        
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
    
    
    func displayQuestion(arrayOfQuestions:[Question], indexQuestion:Int) {
        
        //Initialize labels
        self.questionMenuLabel.text = "Question \(indexQuestion+1) / \(self.totalNumberOfQuestions+1)"

        //Update the view with the new question
        let questionText:String = arrayOfQuestions[indexQuestion].questionText
        self.questionLabel.text = questionText
        
        // add answers to SwipeUIVIew
        for answerSubView in self.answerView.subviews {
            answerSubView.removeFromSuperview()
        }
        let arrayAnswers:[String] = self.quizzArray[indexQuestion].answersText
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
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "answerIsSelected:")
            answerUIButton.addGestureRecognizer(tapGesture)
        }
    }

    func answerIsSelected(gesture:UITapGestureRecognizer) {
        let buttonTapped:UIView? = gesture.view
        if let actualButton = buttonTapped {
            for singleView in self.answerView.subviews {
                singleView.backgroundColor = UIColor.whiteColor()
            }
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                actualButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                for labels in actualButton.subviews {
                    if let labelView = labels as? UILabel {
                        labelView.textColor = UIColor.whiteColor()
                    }
                }
                }, completion: nil)
        }
    }
    
    func nextQuestion(gesture:UITapGestureRecognizer) {
        //call next question
        self.displayedQuestionIndex++
        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
    }
    
    func createChartObject() -> UIView {
        
        //Define chart Axis
        var months: [String]!
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        //Select and display chartType
        let chartType:String = self.quizzArray[0].chartDescription
        if (chartType=="barChart") {
            let chartObject:BarChartView = BarChartView()
            self.setBarChart(chartObject, dataPoints: months, values: unitsSold)
            self.graphView.addSubview(chartObject)
            return chartObject
        }
        else if (chartType=="pieChart") {
            let chartObject:PieChartView = PieChartView()
            self.setPieChart(chartObject, dataPoints: months, values: unitsSold)
            self.graphView.addSubview(chartObject)
            return chartObject
        }
        else if (chartType=="lineChart") {
            let chartObject:LineChartView = LineChartView()
            self.setLineChart(chartObject, dataPoints: months, values: unitsSold)
            self.graphView.addSubview(chartObject)
            return chartObject
        }
        else {
            return UIView()
        }
    }
    
    func setBarChart(chartView:BarChartView, dataPoints: [String], values: [Double]) -> BarChartView {
        chartView.noDataText = "Error while loading data."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartView.data = chartData
        
        chartView.descriptionText = ""
        //chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        chartDataSet.colors = ChartColorTemplates.colorful()
        chartView.xAxis.labelPosition = .Bottom
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        let ll = ChartLimitLine(limit: 10.0, label: "Target")
        chartView.rightAxis.addLimitLine(ll)
        chartView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        return chartView
    }
    
    func setPieChart(chartView:PieChartView, dataPoints: [String], values: [Double]) -> PieChartView {
        chartView.noDataText = "Error while loading data."
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        chartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        chartView.descriptionText = ""
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        chartView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        return chartView
    }
    
    func setLineChart(chartView:LineChartView, dataPoints: [String], values: [Double]) -> LineChartView {
        chartView.noDataText = "Error while loading data."
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        chartView.data = lineChartData
        
        chartView.descriptionText = ""
        lineChartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        chartView.xAxis.labelPosition = .Bottom
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        chartView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        return chartView
    }
    
    /*
    func displayAnswersInView(arrayOfAnswers:[String]) {
        
        //Create a UIVIew per answer
        let buttonHeight:Int = 40
        var i:Int = 0
        for i=0; i<arrayOfAnswers.count;i++ {
            let answerUIButton:UIView = UIView()
            let answerUILabel:UILabel = UILabel()
            let answerNumber:UILabel = UILabel()
            answerUIButton.translatesAutoresizingMaskIntoConstraints = false
            answerUILabel.translatesAutoresizingMaskIntoConstraints = false
            answerNumber.translatesAutoresizingMaskIntoConstraints = false
            self.containerView2.addSubview(answerUIButton)
            answerUIButton.addSubview(answerUILabel)
            answerUIButton.addSubview(answerNumber)
            answerNumber.text = String(i+1)
            answerNumber.textAlignment = NSTextAlignment.Center
            answerNumber.textColor = UIColor.whiteColor()
            answerNumber.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            answerUILabel.text = String(arrayOfAnswers[i])
            answerUILabel.textAlignment = NSTextAlignment.Center
            answerUILabel.textColor = UIColor.whiteColor()
            answerUILabel.numberOfLines = 0
            answerUILabel.adjustsFontSizeToFitWidth = true
            answerUIButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            answerUILabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
            
            //Set constraints to UIViews
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView2, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+5)))
            let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView2, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20))
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView2, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20))
            self.containerView2.addConstraints([topMargin,rightMargin,leftMargin])
            
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
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "answerIsSelected:")
            answerUIButton.addGestureRecognizer(tapGesture)
            
            //Animate transition
            //leftMargin.constant = 1000
            //self.quizzScrollView.layoutIfNeeded()
            //UIView.animateWithDuration(0.04*Double(i+1), animations: {
            //    leftMargin.constant = 20
            //    self.quizzScrollView.layoutIfNeeded()
            //})
        }
        
    }
    
    func answerIsSelected(gesture:UITapGestureRecognizer) {
        let buttonTapped:UIView? = gesture.view
        if let actualButton = buttonTapped {
            for singleView in self.containerView2.subviews {
                singleView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            }
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                actualButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                }, completion: nil)
        }
    }
    
    func createTextLabel(superViewName:UIView, constraintRelatesTo:UIView) -> UILabel {
        //Create and initialize the Label
        let newTextLabel:UILabel = UILabel()
        newTextLabel.translatesAutoresizingMaskIntoConstraints = false
        superViewName.addSubview(newTextLabel)
        newTextLabel.text = "Could not load any question; quick test to see if the height of the label automatically increase depending on the size of the contained string included in the question JSON file"
        newTextLabel.textAlignment = NSTextAlignment.Center
        newTextLabel.textColor = UIColor.blackColor()
        newTextLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
        newTextLabel.numberOfLines = 0
        
        //Set autolayout constraints within container view
        let marginTop:NSLayoutConstraint = NSLayoutConstraint(item: newTextLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: constraintRelatesTo, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20)
        let marginLeft:NSLayoutConstraint = NSLayoutConstraint(item: newTextLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: superViewName, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        let marginRight:NSLayoutConstraint = NSLayoutConstraint(item: newTextLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: superViewName, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
        superViewName.addConstraints([marginLeft,marginRight,marginTop])
        
        //Transition
        UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.containerView.alpha = 1.0
            }, completion: nil)
        
        //Return the created Label
        return newTextLabel
    }
    
    func createSwitchButton() -> UIButton {
        
        //Create and initialize containerView
        self.switchUIView.layer.cornerRadius = 6.0
        self.switchUIView.layer.backgroundColor = UIColor.blackColor().CGColor
        self.switchUIView.translatesAutoresizingMaskIntoConstraints = false
        
        //Initialize left button
        let labelButton:paddingLabel = paddingLabel()
        self.switchUIView.addSubview(labelButton)
        labelButton.translatesAutoresizingMaskIntoConstraints = false
        let contLeft:NSLayoutConstraint = NSLayoutConstraint(item: labelButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let contTop:NSLayoutConstraint = NSLayoutConstraint(item: labelButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let contBottom:NSLayoutConstraint = NSLayoutConstraint(item: labelButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.switchUIView.addConstraints([contLeft,contTop,contBottom])
        let labelWidth:NSLayoutConstraint = NSLayoutConstraint(item: labelButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        labelButton.addConstraint(labelWidth)
        labelButton.textColor = UIColor.whiteColor()
        labelButton.backgroundColor = UIColor.blackColor()
        labelButton.font = UIFont(name: "HelveticaNeue-Bold", size: 10.0)
        labelButton.text = "Go To:"
        labelButton.layer.cornerRadius = 6.0
        labelButton.layer.masksToBounds = true
        
        //Initialize right button
        let textButton:UIButton = UIButton()
        self.switchUIView.addSubview(textButton)
        textButton.translatesAutoresizingMaskIntoConstraints = false
        let constRight:NSLayoutConstraint = NSLayoutConstraint(item: textButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let constTop:NSLayoutConstraint = NSLayoutConstraint(item: textButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let constBottom:NSLayoutConstraint = NSLayoutConstraint(item: textButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.switchUIView.addConstraints([constRight,constTop,constBottom])
        let textWidth:NSLayoutConstraint = NSLayoutConstraint(item: textButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 70)
        textButton.addConstraint(textWidth)
        textButton.titleLabel?.textColor = UIColor.whiteColor()
        textButton.backgroundColor = UIColor.grayColor()
        textButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 10.0)
        textButton.layer.cornerRadius = 6.0
        textButton.titleLabel?.textAlignment = NSTextAlignment.Center
        textButton.layer.masksToBounds = true
        
        return textButton
    }
    
    func showAnswers(sender:UIButton) {
        for singleSubview in self.containerView2.subviews {
            singleSubview.removeFromSuperview()
        }
        UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.containerView.alpha = 0.0
            self.containerView2.alpha = 1.0
            }, completion: nil)
        let arrayOA:[String] = self.quizzArray[sender.tag].answersText
        displayAnswersInView(arrayOA)
        self.answerSwitchButton.setTitle("Question", forState: .Normal)
        self.answerSwitchButton.removeTarget(self, action: "showAnswers:", forControlEvents: UIControlEvents.TouchUpInside)
        self.answerSwitchButton.addTarget(self, action: "showQuestion:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func showQuestion(sender:UIButton) {
        self.answerSwitchButton.removeTarget(self, action: "showQuestion:", forControlEvents: UIControlEvents.TouchUpInside)
        UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.containerView.alpha = 1.0
            self.containerView2.alpha = 0.0
            }, completion: nil)
        self.answerSwitchButton.setTitle("Answers", forState: .Normal)
        self.answerSwitchButton.addTarget(self, action: "showAnswers:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func updateTimer() {
        if (self.countSeconds-1<0) {
            if (self.countMinutes+self.countSeconds==0) {
                self.timerPage.invalidate()
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
        timerLabel.text = newLabel
    }
    
    @IBAction func previousQ(sender: UIButton) {
        if self.displayedQuestionIndex-1 >= 0 {
            self.displayedQuestionIndex--
            updateViewWithNewQuestion(self.displayedQuestionIndex)
        }
    }
    
    @IBAction func nextQ(sender: UIButton) {
        if self.displayedQuestionIndex+1 <= self.totalNumberOfQuestions {
            self.displayedQuestionIndex++
            updateViewWithNewQuestion(self.displayedQuestionIndex)
        }
    }
    
    func updateViewWithNewQuestion(questionToDisplay:Int) {
        if questionToDisplay==self.totalNumberOfQuestions {
            self.nextButton.alpha = 0.4
        }
        else if questionToDisplay==0 {
            self.previousButton.alpha = 0.4
        }
        else {
            self.nextButton.alpha = 1.0
            self.previousButton.alpha = 1.0
        }
        self.displayQuestion(self.quizzArray, indexQuestion: questionToDisplay)
    }

    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}