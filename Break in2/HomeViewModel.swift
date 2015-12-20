//
//  quizzModel.swift
//  Breakin2
//
//  Created by Jean-Charles Koch on 11/11/2015.
//  Copyright © 2015 Jean-Charles Koch. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    
    func getAppVariables(outputField:String) -> AnyObject {
        
        //Initialize variables
        var careerTypesArray:AnyObject
        let jsonObject:[NSDictionary] = self.getjsonfile("AppVariables")
        careerTypesArray = jsonObject[0].objectForKey(outputField)!
        
        //Return final array
        return careerTypesArray
    }
    
    func getjsonfile(jsonFileName:String) -> [NSDictionary] {
        
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
                    let arrayOfDictionaries:[NSDictionary] = try NSJSONSerialization.JSONObjectWithData(actualJsonData, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
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
        return [NSDictionary]()
    }
    
}
