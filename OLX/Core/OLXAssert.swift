//
//  OLXAssert.swift
//  OLX
//
//  Created by Jake Enzien on 3/13/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

func OLXAssert(_ condition: @autoclosure () -> Bool, message: String) {
    #if DEBUG
        assert(condition(), message)
    #else
        Logger.log(logLevel: .Release, message)
    #endif
}
