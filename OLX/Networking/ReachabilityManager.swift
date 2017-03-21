//
//  ReachabilityManager.swift
//  OLX
//
//  Created by Jake Enzien on 3/19/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Alamofire
import Foundation

protocol ReachabilityManaging {
    var status: NetworkReachabilityManager.NetworkReachabilityStatus { get }
}

final class ReachabilityManager: ReachabilityManaging {
    
    private let networkReachabilityManager = NetworkReachabilityManager(host: "api-v2.olx.com")
    private(set) var status: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    
    init() {
        networkReachabilityManager?.listener = { [weak self] (status) in
            self?.status = status
        }
        
        networkReachabilityManager?.startListening()
    }
    
    deinit {
        networkReachabilityManager?.stopListening()
    }
}
