//
//  question.swift
//  Breakin2
//
//  Created by Jean-Charles Koch on 11/11/2015.
//  Copyright © 2015 Jean-Charles Koch. All rights reserved.
//

import UIKit

class sequencesList {
    
    func runSequence(sequenceNB:Int, initialNumber:Int) -> Int {
        
        var returnInt:Int = Int()
        
        if sequenceNB==1 {
            returnInt = self.fibonacciSequence(initialNumber)
        }
        
        return returnInt
        
    }
    
    func fibonacciSequence(requestedIndex:Int) -> Int {
        
        let alpha:Float = 1/sqrt(5)
        let beta:Float = -1*alpha
        let phi1:Float = (1+sqrt(5))/2
        let phi2:Float = (-1/phi1)
        let returnNumber:Float = alpha * powf(phi1, Float(requestedIndex)) + beta * powf(phi2, Float(requestedIndex))
        return Int(returnNumber)
    
    }

}