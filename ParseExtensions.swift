//
//  Parse.swift
//  Break in2
//
//  Created by Jonathan Crawford on 06/12/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ParseExtensions: UIView {

    class func deleteUserFB(_ user: PFUser){
        
        user.deleteInBackground(block: {(succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
            print(error)
            }
        
    } as! PFBooleanResultBlock)

}
}
