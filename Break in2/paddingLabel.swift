//
//  paddingLabel.swift
//  Breakin2 v1.2
//
//  Created by Jean-Charles Koch on 21/11/2015.
//  Copyright © 2015 Jean-Charles Koch. All rights reserved.
//

import UIKit

class paddingLabel: UILabel {
    
    override func drawTextInRect(rect: CGRect) {
        let newRect = CGRectOffset(rect, 10, 0) // move text 10 points to the right
        super.drawTextInRect(newRect)

    }
}