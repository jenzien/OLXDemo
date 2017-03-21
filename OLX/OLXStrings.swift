//
//  OLXStrings.swift
//  OLX
//
//  Created by Jake Enzien on 3/19/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

struct OLXStrings {
    
    static func moreButtonTitle() -> String {
        return NSLocalizedString("moreButtonTitle", comment: "Title for more button on details page")
    }
    
    static func lessButtonTitle() -> String {
        return NSLocalizedString("lessButtonTitle", comment: "Title for less button on details page")
    }
    
    static func resultsString() -> String {
        return NSLocalizedString("results", comment: "Navigation title results count")
    }
    
    static func noResultsError() -> String {
        return NSLocalizedString("noResultsError", comment: "Error message for no results found")
    }
    
    static func noNetworkError() -> String {
        return NSLocalizedString("noNetworkError", comment: "Error message for no network found")
    }
    
    static func tryAgain() -> String {
        return NSLocalizedString("tryAgain", comment: "Try again button")
    }
}
