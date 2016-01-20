//
//  question.swift
//  Breakin2
//
//  Created by Jean-Charles Koch on 11/11/2015.
//  Copyright © 2015 Jean-Charles Koch. All rights reserved.
//

import UIKit

class sequencesList {
    
    var arithmeticReason:Int = Int()
    var geometricReason:Int = Int()
    var sequenceFirstTerm:Int = Int()
    
    func runSequence(sequenceNB:Int, initialNumber:Int) -> Int {
        
        var returnInt:Int = Int()
        
        if sequenceNB==1 {
            returnInt = self.fibonacciSequence(initialNumber)
        }
        if sequenceNB==2 {
            returnInt = self.arithmeticSequence(initialNumber)
        }
        if sequenceNB==3 {
            returnInt = self.geometricSequence(initialNumber)
        }
        if sequenceNB==4 {
            returnInt = self.squareSequence(initialNumber)
        }
        if sequenceNB==5 {
            returnInt = self.primeNumberSequence(initialNumber)
        }
        return returnInt
        
    }
    
    func addFeedback(sequenceNB:Int) -> String {
        
        var feedbackString:String = String()
        
        if sequenceNB==1 {
            feedbackString = "The terms in this sequence are Fibonacci numbers, meaning that each number in the sequence is equal to the sum of the two previous numbers."
        } else if sequenceNB==2 {
            feedbackString = "This sequence follows an arithmetic progression, the common difference of successive numbers being equal to \(self.arithmeticReason)."
        } else if sequenceNB==3 {
            feedbackString = "This sequence follows a geometric progression with initial value \(self.sequenceFirstTerm) and common ratio \(self.geometricReason)."
        } else if sequenceNB==4 {
            feedbackString = "This sequence returns the square of consecutive integers."
        } else if sequenceNB==5 {
            feedbackString = "This sequence corresponds to the sequence of prime numbers."
        }
        
        return feedbackString
        
    }
    
    func fibonacciSequence(requestedIndex:Int) -> Int {
        
        let alpha:Float = 1/sqrt(5)
        let beta:Float = -1*alpha
        let phi1:Float = (1+sqrt(5))/2
        let phi2:Float = (-1/phi1)
        let returnNumber:Float = alpha * powf(phi1, Float(requestedIndex)) + beta * powf(phi2, Float(requestedIndex))
        
        return Int(returnNumber)
    
    }
    
    func arithmeticSequence(requestIndex:Int) -> Int {
        
        let returnNumber:Int = Int(requestIndex * self.arithmeticReason)
        
        return returnNumber
        
    }
    
    func geometricSequence(requestIndex:Int) -> Int {
        
        let returnNumber:Int = Int(Float(self.sequenceFirstTerm) * powf(Float(self.geometricReason), Float(requestIndex)))
        
        return returnNumber
        
    }
    
    func squareSequence(requestIndex:Int) -> Int {
        
        let returnNumber:Int = requestIndex * requestIndex
        return returnNumber
        
    }
    
    func primeNumberSequence(requestIndex:Int) -> Int {
        
        var prime: Int
        var divisor: Int
        var isPrime: Bool
        var counter = 0
        for (prime = 2;  prime <= 50 && counter < requestIndex;  ++prime )
        {
            isPrime = true;
            for (divisor = 2;  divisor < prime;  ++divisor )
            {
                if ((prime % divisor) == 0 )
                {
                    isPrime = false
                }
            }
            if (isPrime)
            {
                counter++
            }
        }
        
        return prime-1
        
    }

}