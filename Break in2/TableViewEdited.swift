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
    var answerArray:[String] = [String]()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        
        super.init(frame: frame, style: style)
        
        tableFooterView = UIView()
        backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        
        self.estimatedRowHeight = frame.height/15.0
        rowHeight = UITableViewAutomaticDimension
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

