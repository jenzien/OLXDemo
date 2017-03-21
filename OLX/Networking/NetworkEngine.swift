//
//  NetworkEngine.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import Freddy

protocol NetworkEngine {
    func enqueue<Model: JSONDecodable>(url: URL, params: [String: String], forceCache: Bool, completion: @escaping (Model?,Error?)->())
}
