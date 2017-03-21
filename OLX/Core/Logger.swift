//
//  Logger.swift
//  OLX
//
//  Created by Jake Enzien on 3/13/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

enum LogLevel {
    case Debug
    case Release
}

final class Logger {
    class func log(logLevel: LogLevel = .Debug, message: String) {
        #if DEBUG
            print(message)
        #else
            if logLevel == .Release {
                print(message)
            }
        #endif
        
    }
}
