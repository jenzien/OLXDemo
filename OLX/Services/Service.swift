//
//  Service.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation

protocol Servicing {
    init(networkEngine: NetworkEngine)
}

class Service: Servicing {
    let networkEngine: NetworkEngine
    
    required init(networkEngine: NetworkEngine) {
        self.networkEngine = networkEngine
    }
}
