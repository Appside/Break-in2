//
//  CalendarModel.swift
//  Break in2
//
//  Created by Sangeet on 20/12/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit

class CalendarModel: NSObject {

  func getJobDeadlines() -> [[String:AnyObject]] {
    
    //Initialize variables
    var jobDeadlines:[[String:AnyObject]] = [[String:AnyObject]]()
    jobDeadlines = self.getjsonfile("JobDeadlines")
    
    //Return final array
    return jobDeadlines
  }
  
  func getjsonfile(jsonFileName:String) -> [[String:AnyObject]] {
    
    //Define JSon file URL
    let fileBundlePath:String? = NSBundle.mainBundle().pathForResource(jsonFileName, ofType: "json")
    if let actualFilePath = fileBundlePath {
      //Case where the path has been found
      let urlPath:NSURL = NSURL(fileURLWithPath: actualFilePath)
      let jsonData:NSData? = NSData(contentsOfURL: urlPath)
      if let actualJsonData = jsonData {
        //NSData exist so use NSJSONerialization to parse data
        do {
          //Data correctly parsed
          let arrayOfDictionaries:[[String:AnyObject]] = try NSJSONSerialization.JSONObjectWithData(actualJsonData, options: NSJSONReadingOptions.MutableContainers) as! [[String:AnyObject]]
          return arrayOfDictionaries
        }
        catch {
          //Error parsing JSON data
        }
      }
      else {
        //NSData does not exist
      }
    }
    else {
      //Case where the path does not exist
    }
    return [[String:AnyObject]]()
  }
  
}
