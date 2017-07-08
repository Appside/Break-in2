//
//  segueFromLeft.swift
//  Break in2
//
//  Created by Jonathan Crawford on 15/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import QuartzCore

class segueFromLeft: UIStoryboardSegue {
    
    override func perform() {
        let src: UIViewController = self.source
        let dst: UIViewController = self.destination
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 5
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        src.view.layer.add(transition, forKey: kCATransition)
        src.present(dst, animated: false, completion: nil)
    }

}

//with navigation controller

//override func perform() {
//    var src: UIViewController = self.sourceViewController as! UIViewController
//    var dst: UIViewController = self.destinationViewController as! UIViewController
//    var transition: CATransition = CATransition()
//    var timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//    transition.duration = 0.25
//    transition.timingFunction = timeFunc
//    transition.type = kCATransitionPush
//    transition.subtype = kCATransitionFromLeft
//    src.navigationController!.view.layer.addAnimation(transition, forKey: kCATransition)
//    src.navigationController!.pushViewController(dst, animated: false)
//}
