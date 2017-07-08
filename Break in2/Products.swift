//
//  Products.swift
//  Break in2
//
//  Created by Jonathan Crawford on 14/02/2016.
//  Copyright © 2016 Appside. All rights reserved.
//

import Foundation

// Use enum as a simple namespace.  (It has no cases so you can't instantiate it.)
public enum Products {
    
    /// TODO:  Change this to whatever you set on iTunes connect
    fileprivate static let Prefix = "com.APPSIDE.inappragedemo."
    
    /// MARK: - Supported Product Identifiers
    public static let GirlfriendOfDrummer = Prefix + "girlfriendofdrummer"
    public static let NightlyRage         = Prefix + "nightlyrage"
    
    // All of the products assembled into a set of product identifiers.
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [Products.GirlfriendOfDrummer,
        Products.NightlyRage]
    
    /// Static instance of IAPHelper that for rage products.
    public static let store = IAPHelper(productIdentifiers: Products.productIdentifiers)
}

/// Return the resourcename for the product identifier.
func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
