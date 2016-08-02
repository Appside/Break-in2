//
//  CalendarModel.swift
//  Break in2
//
//  Created by Sangeet on 20/12/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit

class JSONModel: NSObject, NSURLConnectionDelegate {
  
  var downloadData:NSMutableData = NSMutableData()

  func getJobDeadlines() -> [[String:AnyObject]] {
    
    //Initialize variables
    var jobDeadlines:[[String:AnyObject]] = [[String:AnyObject]]()
    jobDeadlines = self.getjsonfile("JobDeadlines")
    
    //Return final array
    return jobDeadlines
  }
  
  func getAppVariables(outputField:String) -> AnyObject {
    
    //Initialize variables
    var careerTypesArray:AnyObject
    let jsonObject:[NSDictionary] = self.getjsonfile("AppVariables")
    careerTypesArray = jsonObject[0].objectForKey(outputField)!
    
    //Return final array
    return careerTypesArray
  }
  
  func getAppColors() -> [UIColor] {
    
    //Initialize variables
    var colors:[UIColor] = [UIColor]()
    var colorsRGBAlpha:[[CGFloat]] = [[CGFloat]]()
    let jsonObject:[NSDictionary] = self.getjsonfile("AppVariables")
    colorsRGBAlpha = jsonObject[0].objectForKey("colorsRGBAlpha") as! [[CGFloat]]
    for RGBAlpha in colorsRGBAlpha {
      colors.append(UIColor.init(red: RGBAlpha[0]/255, green: RGBAlpha[1]/255, blue: RGBAlpha[2]/255, alpha: RGBAlpha[3]))
    }
    
    //Return final array
    return colors
  }
  
  func selectNumericalReasoning(nbOfQuestions:Int) -> [numericalQuestion] {
    
    //Initialize variables
    var arrayOfQuestions:[numericalQuestion] = [numericalQuestion]()
    
    //Get JSon file
    let jsonObject:[NSDictionary] = self.getjsonfile("NumericalReasoning")
    var randomNumber:Int = Int()
    var selectedQuestions:[Int] = [Int]()
    var index:Int = 0
    var y:Int = 0
    var z:Int = 0
    
    for index in 0.stride(to: nbOfQuestions, by: 1) {
      
      y = 0
      while y==0 {
        randomNumber = Int(arc4random_uniform(UInt32(jsonObject.count-1)))
        if selectedQuestions.count>0 {
          for z in 0.stride(to: selectedQuestions.count, by: 1) {
            if selectedQuestions[z] != randomNumber {
              y = 1
            }
          }
        } else {
          y = 1
        }
      }
      selectedQuestions.append(randomNumber)
      
      let currentJsonDictionary:NSDictionary = jsonObject[randomNumber]
      let newQuestion:numericalQuestion = numericalQuestion()
      //Assign values to the newQuestion
      newQuestion.questionType = currentJsonDictionary["questionType"] as! String
      newQuestion.chartType = currentJsonDictionary["chartType"] as! String
      
      if newQuestion.chartType=="bar" {
        newQuestion.axisNames = currentJsonDictionary["axisNames"] as! [String]
        newQuestion.barSegmentOrientation = currentJsonDictionary["barSegmentOrientation"] as! String
        newQuestion.barSegmentNames = currentJsonDictionary["barSegmentNames"] as! [String]
        newQuestion.xAxis = currentJsonDictionary["xAxis"] as! [String]
        newQuestion.yAxis = currentJsonDictionary["yAxis"] as! [[Double]]
      }
      else if newQuestion.chartType=="line" {
        newQuestion.axisNames = currentJsonDictionary["axisNames"] as! [String]
        newQuestion.lineNames = currentJsonDictionary["lineNames"] as! [String]
        newQuestion.xAxis = currentJsonDictionary["xAxis"] as! [String]
        newQuestion.yAxis = currentJsonDictionary["yAxis"] as! [[Double]]
      }
      else if newQuestion.chartType=="pie" {
        newQuestion.chartTitle = currentJsonDictionary["chartTitle"] as! String
        newQuestion.pieSegmentNames = currentJsonDictionary["pieSegmentNames"] as! [String]
        newQuestion.pieSegmentPercentages = currentJsonDictionary["pieSegmentPercentages"] as! [Double]
        
      }
      
      newQuestion.question = currentJsonDictionary["question"] as! String
      newQuestion.answers = currentJsonDictionary["answers"] as! [String]
      newQuestion.correctAnswer = currentJsonDictionary["correctAnswer"] as! Int
      newQuestion.explaination = currentJsonDictionary["explaination"] as! String
      //Add the new Question to the returned array
      arrayOfQuestions.append(newQuestion)
    }
    
    //Return final array
    return arrayOfQuestions
  }
  
  func selectVerbalReasoning(nbOfQuestions:Int) -> [verbalQuestion] {
    
    //Initialize variables
    var arrayOfQuestions:[verbalQuestion] = [verbalQuestion]()
    
    //Get JSon file
    let jsonObject:[NSDictionary] = self.getjsonfile("VerbalReasoning")
    var randomNumber:Int = Int()
    var selectedQuestions:[Int] = [Int]()
    var index:Int = 0
    var y:Int = 0
    var z:Int = 0
    
    for index in 0.stride(to: nbOfQuestions, by: 1) {
      
      y = 0
      while y==0 {
        randomNumber = Int(arc4random_uniform(UInt32(jsonObject.count-1)))
        if selectedQuestions.count>0 {
          for z in 0.stride(to: selectedQuestions.count, by: 1) {
            if selectedQuestions[z] != randomNumber {
              y = 1
            }
          }
        } else {
          y = 1
        }
      }
      selectedQuestions.append(randomNumber)
      
      let currentJsonDictionary:NSDictionary = jsonObject[randomNumber]
      let newQuestion:verbalQuestion = verbalQuestion()
      //Assign values to the newQuestion
      newQuestion.questionType = currentJsonDictionary["questionType"] as! String
      newQuestion.passage = currentJsonDictionary["passage"] as! String
      newQuestion.question = currentJsonDictionary["question"] as! String
      newQuestion.answers = currentJsonDictionary["answers"] as! [String]
      newQuestion.correctAnswer = currentJsonDictionary["correctAnswer"] as! Int
      newQuestion.explanation = currentJsonDictionary["explanation"] as! String
      //Add the new Question to the returned array
      arrayOfQuestions.append(newQuestion)
    }
    
    //Return final array
    return arrayOfQuestions
  }
    
    func selectProgramming(nbOfQuestions:Int) -> [programmingQuestion] {
        
        //Initialize variables
        var arrayOfQuestions:[programmingQuestion] = [programmingQuestion]()
        
        //Get JSon file
        let jsonObject:[NSDictionary] = self.getjsonfile("Programming")
        var randomNumber:Int = Int()
        var selectedQuestions:[Int] = [Int]()
        var index:Int = 0
        var y:Int = 0
        var z:Int = 0
        
        for index in 0.stride(to: nbOfQuestions, by: 1) {
            
            y = 0
            while y==0 {
                randomNumber = Int(arc4random_uniform(UInt32(jsonObject.count-1)))
                if selectedQuestions.count>0 {
                    for z in 0.stride(to: selectedQuestions.count, by: 1) {
                        if selectedQuestions[z] != randomNumber {
                            y = 1
                        }
                    }
                } else {
                    y = 1
                }
            }
            selectedQuestions.append(randomNumber)
            
            let currentJsonDictionary:NSDictionary = jsonObject[randomNumber]
            let newQuestion:programmingQuestion = programmingQuestion()
            //Assign values to the newQuestion
            newQuestion.question = currentJsonDictionary["question"] as! String
            newQuestion.codePassage = currentJsonDictionary["codePassage"] as! String
            newQuestion.answers = currentJsonDictionary["answers"] as! [String]
            newQuestion.correctAnswer = currentJsonDictionary["correctAnswer"] as! Int
            newQuestion.feedback = currentJsonDictionary["feedback"] as! String
            //Add the new Question to the returned array
            arrayOfQuestions.append(newQuestion)
        }
        
        //Return final array
        return arrayOfQuestions
    }
    
    func selectTechnology(nbOfQuestions:Int) -> [technologyQuestion] {
        
        //Initialize variables
        var arrayOfQuestions:[technologyQuestion] = [technologyQuestion]()
        
        //Get JSon file
        let jsonObject:[NSDictionary] = self.getjsonfile("Technology")
        var randomNumber:Int = Int()
        var selectedQuestions:[Int] = [Int]()
        var index:Int = 0
        var y:Int = 0
        var z:Int = 0
        
        for index in 0.stride(to: nbOfQuestions, by: 1) {
            
            y = 0
            while y==0 {
                randomNumber = Int(arc4random_uniform(UInt32(jsonObject.count-1)))
                if selectedQuestions.count>0 {
                    for z in 0.stride(to: selectedQuestions.count, by: 1) {
                        if selectedQuestions[z] != randomNumber {
                            y = 1
                        }
                    }
                } else {
                    y = 1
                }
            }
            selectedQuestions.append(randomNumber)
            
            let currentJsonDictionary:NSDictionary = jsonObject[randomNumber]
            let newQuestion:technologyQuestion = technologyQuestion()
            //Assign values to the newQuestion
            newQuestion.question = currentJsonDictionary["question"] as! String
            newQuestion.answers = currentJsonDictionary["answers"] as! [String]
            newQuestion.correctAnswer = currentJsonDictionary["correctAnswer"] as! Int
            newQuestion.explanation = currentJsonDictionary["explanation"] as! String
            //Add the new Question to the returned array
            arrayOfQuestions.append(newQuestion)
        }
        
        //Return final array
        return arrayOfQuestions
    }
    
  func getjsonfile(jsonFileName:String) -> [[String:AnyObject]] {
    
    if jsonFileName == "JobDeadlines" {
      let fileManager = NSFileManager.defaultManager()
      let directoryURLs = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
      
      if let directoryURL = directoryURLs.first {
        
        let fileURL = directoryURL.URLByAppendingPathComponent(jsonFileName + ".json")
                
        let jsonData:NSData? = NSData(contentsOfURL: fileURL)
        if let actualJsonData = jsonData {
          //NSData exist so use NSJSONerialization to parse data
          do {
            //Data correctly parsed
            let arrayOfDictionaries:[[String:AnyObject]] = try NSJSONSerialization.JSONObjectWithData(actualJsonData, options: NSJSONReadingOptions.MutableContainers) as! [[String:AnyObject]]
            //print(jsonFileName + " JSON file retrieved")
            return arrayOfDictionaries
          }
          catch {
            //Error parsing JSON data
            print("Problem reading " + jsonFileName + " JSON Serialization")
          }
        }
        else {
          //NSData does not exist
          print("Problem reading " + jsonFileName + " NSData")
        }
        
      }
    }
    else {
      
      let fileURL = NSBundle.mainBundle().URLForResource(jsonFileName, withExtension: "json")
      
      if let actualfileURL = fileURL {
        let jsonData:NSData? = NSData(contentsOfURL: actualfileURL)
        if let actualJsonData = jsonData {
          //NSData exist so use NSJSONerialization to parse data
          do {
            //Data correctly parsed
            let arrayOfDictionaries:[[String:AnyObject]] = try NSJSONSerialization.JSONObjectWithData(actualJsonData, options: NSJSONReadingOptions.MutableContainers) as! [[String:AnyObject]]
            //print(jsonFileName + " JSON file retrieved")
            return arrayOfDictionaries
          }
          catch {
            //Error parsing JSON data
            print("Problem reading " + jsonFileName + " JSON Serialization")
          }
        }
        else {
          //NSData does not exist
          print("Problem reading " + jsonFileName + " NSData")
        }
      }
      else {
        print("Problem reading " + jsonFileName + " JSON file")
      }
    }
    
    return [[String:AnyObject]]()
  }

  func saveJSONFile(jsonFileName:String, completion:(() -> Void)?) {
    let fileManager = NSFileManager.defaultManager()
    let directoryURLs = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    
    if let directoryURL = directoryURLs.first {
      
      let fileURL = directoryURL.URLByAppendingPathComponent(jsonFileName + ".json")
      
      if !fileManager.fileExistsAtPath(fileURL.path!) {
        fileManager.createFileAtPath(fileURL.path!, contents: nil, attributes: nil)
      }else{
        
        do {
            try fileManager.removeItemAtPath(fileURL.path!)
            fileManager.createFileAtPath(fileURL.path!, contents: nil, attributes: nil)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        }
        
      let requestURL: NSURL = NSURL(string: "http://www.appside.co.uk/48fec57fc197cfebc72982e2ca5fd4625688a533/fb3a346e67946a927bc3d523dd88d61e6aea85f6/" + jsonFileName + ".json")!
      let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
      let session = NSURLSession.sharedSession()
      
      let task = session.dataTaskWithRequest(urlRequest) {
        (data, response, error) -> Void in
        
        let httpResponse = response as! NSHTTPURLResponse
        let statusCode = httpResponse.statusCode
        
        if (statusCode == 200) {
          
          do {
            if let downloadedData = data {
              let file = try NSFileHandle(forWritingToURL: fileURL)
              file.writeData(downloadedData)
              print(jsonFileName + " JSON file overwritten!")
            }
            else {
              print("Problem writing " + jsonFileName + " downloaded data")
            }
          }
          catch {
            print("Problem writing " + jsonFileName + " JSON Serialization")
          }
        }
        else {
          print("Problem opening " + jsonFileName + " URL (httpResponse: " + String(statusCode) + ")")
        }
      }
      task.resume()
    }
  }
  
  func refreshJobDeadlines() {
    self.saveJSONFile("JobDeadlines", completion: nil)
  }
  
}
