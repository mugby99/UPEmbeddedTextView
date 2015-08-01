//
//  UPManagedTextViewMetaData.swift
//  Pods
//
//  Created by Adriana Pineda on 8/1/15.
//
//

import Foundation

/**
* Manages data related to the Text View
* used when its height must change
*/
public class UPManagedTextViewMetaData: NSObject {
    
    required public init(reuseIdentifier: String!, enableAutomaticCollapse: Bool, collapsedHeightConstant: CGFloat) {
        self.reusableIdentifier = reuseIdentifier
        self.enableAutomaticCollapse = enableAutomaticCollapse
        self.collapsedHeightConstant = collapsedHeightConstant
    }
    
    var previousRectDictionaryRepresentation: NSDictionary?
    var textViewHeightConstraint:NSLayoutConstraint!
    var shouldCollapseHeightIfNeeded: Bool = true
    var reusableIdentifier: String!
    var currentWidth: CGFloat?
    var enableAutomaticCollapse: Bool = true
    var collapsedHeightConstant: CGFloat = 125
}