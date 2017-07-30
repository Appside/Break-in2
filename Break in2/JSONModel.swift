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
  
  func getAppVariables(_ outputField:String) -> AnyObject {
    
    //Initialize variables
    var careerTypesArray:AnyObject
    let jsonObject:[NSDictionary] = self.getjsonfile("AppVariables") as [NSDictionary]
    careerTypesArray = jsonObject[0].object(forKey: outputField)! as AnyObject
    
    //Return final array
    return careerTypesArray
  }
  
  func getAppColors() -> [UIColor] {
    
    //Initialize variables
    var colors:[UIColor] = [UIColor]()
    var colorsRGBAlpha:[[CGFloat]] = [[CGFloat]]()
    let jsonObject:[NSDictionary] = self.getjsonfile("AppVariables") as [NSDictionary]
    colorsRGBAlpha = jsonObject[0].object(forKey: "colorsRGBAlpha") as! [[CGFloat]]
    for RGBAlpha in colorsRGBAlpha {
      colors.append(UIColor.init(red: RGBAlpha[0]/255, green: RGBAlpha[1]/255, blue: RGBAlpha[2]/255, alpha: RGBAlpha[3]))
    }
    
    //Return final array
    return colors
  }
  
  func selectNumericalReasoning(_ nbOfQuestions:Int) -> [numericalQuestion] {
    
    //Initialize variables
    var arrayOfQuestions:[numericalQuestion] = [numericalQuestion]()
    
    //Get JSon file
    let jsonObject:[NSDictionary] = self.getjsonfile("NumericalReasoning") as [NSDictionary]
    var randomNumber:Int = Int()
    var selectedQuestions:[Int] = [Int]()
    var y:Int = 0
    
    for _ in stride(from: 0, to: nbOfQuestions, by: 1) {
      
      y = 0
      while y==0 {
        randomNumber = Int(arc4random_uniform(UInt32(jsonObject.count-1)))
        if selectedQuestions.count>0 {
            if selectedQuestions.contains(randomNumber) {
                y = 0
            } else {
                y = 1
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
  
  func selectVerbalReasoning(_ nbOfQuestions:Int) -> [verbalQuestion] {
    
    //Initialize variables
    var arrayOfQuestions:[verbalQuestion] = [verbalQuestion]()
    
    //Get JSon file
    let jsonObject:[NSDictionary] = self.getjsonfile("VerbalReasoning") as [NSDictionary]
    var randomNumber:Int = Int()
    var selectedQuestions:[Int] = [Int]()
    var y:Int = 0
    
    for _ in stride(from: 0, to: nbOfQuestions, by: 1) {
      
      y = 0
      while y==0 {
        randomNumber = Int(arc4random_uniform(UInt32(jsonObject.count-1)))
        if selectedQuestions.count>0 {
            if selectedQuestions.contains(randomNumber) {
                y = 0
            } else {
                y = 1
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
    
    func selectProgramming(_ nbOfQuestions:Int) -> [programmingQuestion] {
        
        //Initialize variables
        var arrayOfQuestions:[programmingQuestion] = [programmingQuestion]()
        
        //Get JSon file
        let jsonObject:[NSDictionary] = self.getjsonfile("Programming") as [NSDictionary]
        var randomNumber:Int = Int()
        var selectedQuestions:[Int] = [Int]()
        var y:Int = 0
      
        for _ in stride(from: 0, to: nbOfQuestions, by: 1) {
            
            y = 0
            while y==0 {
                randomNumber = Int(arc4random_uniform(UInt32(jsonObject.count-1)))
                if selectedQuestions.count>0 {
                    if selectedQuestions.contains(randomNumber) {
                        y = 0
                    } else {
                        y = 1
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
            newQuestion.codePassage = currentJsonDictionary["codePassage"] as! [String]
            newQuestion.feedback = currentJsonDictionary["feedback"] as! [String]
            //Add the new Question to the returned array
            arrayOfQuestions.append(newQuestion)
        }
        
        //Return final array
        return arrayOfQuestions
    }
    
    func selectTechnology(_ nbOfQuestions:Int) -> [technologyQuestion] {
        
        //Initialize variables
        var arrayOfQuestions:[technologyQuestion] = [technologyQuestion]()
        
        //Get JSon file
        let jsonObject:[NSDictionary] = self.getjsonfile("Technology") as [NSDictionary]
        var randomNumber:Int = Int()
        var selectedQuestions:[Int] = [Int]()
        var y:Int = 0
      
        for _ in stride(from: 0, to: nbOfQuestions, by: 1) {
            
            y = 0
            while y==0 {
                randomNumber = Int(arc4random_uniform(UInt32(jsonObject.count-1)))
                if selectedQuestions.count>0 {
                    if selectedQuestions.contains(randomNumber) {
                        y = 0
                    } else {
                        y = 1
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
    
    func getjsonfile(_ jsonFileName:String) -> [[String:AnyObject]] {
                
                let fileURL = Bundle.main.url(forResource: jsonFileName, withExtension: "json")
                
                if let actualfileURL = fileURL {
                    
                    //if let actualJsonData = jsonData {
                    //NSData exist so use NSJSONerialization to parse data
                    do {
                        
                        let jsonData:Data? = try? Data(contentsOf: actualfileURL)
                        
                        //Data correctly parsed
                        let arrayOfDictionaries:[[String:AnyObject]] = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String:AnyObject]]
                        
                        print(jsonFileName + " JSON file retrieved")
                        print(arrayOfDictionaries)
                        
                        return arrayOfDictionaries
                    }
                    catch {
                        //Error parsing JSON data
                        print("Problem reading " + jsonFileName + " JSON Serialization")
                    }

                }else {
                    print("Problem reading " + jsonFileName + " JSON file")
                }
            
            return [[String:AnyObject]]()
        
    }
  
    
    func saveJSONFile(_ jsonFileName:String, completion:(() -> Void)?) {
        let fileManager = FileManager.default
        let directoryURLs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let directoryURL = directoryURLs.first {
            
            let fileURL = directoryURL.appendingPathComponent(jsonFileName + ".json")
            
            if !fileManager.fileExists(atPath: fileURL.path) {
                fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
            }else{
                
                do {
                    try fileManager.removeItem(atPath: fileURL.path)
                    fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
                }
                catch let error as NSError {
                    print("Ooops! Something went wrong: \(error)")
                }
                
            }
            
            let requestURL: URL = URL(string: "http://www.appside.co.uk/48fec57fc197cfebc72982e2ca5fd4625688a533/fb3a346e67946a927bc3d523dd88d61e6aea85f6/" + jsonFileName + ".json")!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
            let session = URLSession.shared
            
            let task = URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: {
                (data, response, error) -> Void in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    
                    do {
                        if let downloadedData = data {
                            let file = try FileHandle(forWritingTo: fileURL)
                            file.write(downloadedData)
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
            }) 
            task.resume()
        }
}

    func refreshJobDeadlines() {
        self.saveJSONFile("JobDeadlines", completion: nil)
}
}
