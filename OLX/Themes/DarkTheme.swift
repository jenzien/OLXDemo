//
//  DarkTheme.swift
//  OLX
//
//  Created by Jake Enzien on 3/16/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import UIKit

final class DarkTheme: Theme {
    
    var primaryColor: UIColor {
        return UIColor.black
    }
    
    var secondaryColor: UIColor {
        return UIColor.white
    }
    
    var primaryText: UIColor {
        return UIColor.white
    }
    
    var accentColor: UIColor {
        return Colors.olxGreen
    }
}
