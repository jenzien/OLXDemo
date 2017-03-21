//
//  Utilities.swift
//  OLX
//
//  Created by Jake Enzien on 3/13/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

func synchronized(_ lock: Any, closure: ()->()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
