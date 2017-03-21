//
//  Theme.swift
//  OLX
//
//  Created by Jake Enzien on 3/15/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

class Themes {
    static var Default: Theme = DefaultTheme()
    static var Dark: Theme = DarkTheme()
}

protocol Theme {
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
    var primaryText: UIColor { get }
    var accentColor: UIColor { get }
}
