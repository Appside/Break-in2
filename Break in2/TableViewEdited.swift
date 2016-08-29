//
//  File.swift
//  Break in2
//
//  Created by Jonathan Crawford on 29/08/2016.
//  Copyright © 2016 Appside. All rights reserved.
//

import UIKit

class TableViewEdited: UITableView {
    
    var rearrange: RearrangeProperties!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        
        super.init(frame: frame, style: style)
        
        tableFooterView = UIView()
        backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsZero
        
        rowHeight = frame.height/10.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

