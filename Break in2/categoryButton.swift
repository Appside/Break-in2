//
//  categoryButton.swift
//  Breakin2 v1.2
//
//  Created by Jean-Charles Koch on 17/11/2015.
//  Copyright © 2015 Jean-Charles Koch. All rights reserved.
//

import UIKit

@IBDesignable

class categoryButton: UIButton {
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        UIColor.redColor().setFill()
        path.fill()
    }
}
