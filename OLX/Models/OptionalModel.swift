//
//  OptionalModel.swift
//  OLX
//
//  Created by Jake Enzien on 3/19/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Foundation
import Freddy

struct OptionalModel: JSONDecodable {
    let label: String
    let value: String
    
    init (label: String,
          value: String) {
        self.label = label
        self.value = value
    }
    
    init(json: JSON) throws {
        label = try json.getString(at: "label")
        value = try json.getString(at: "value")
    }
}
