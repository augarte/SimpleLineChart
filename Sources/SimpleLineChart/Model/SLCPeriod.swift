//
//  File.swift
//  
//
//  Created by Aimar Ugarte on 11/12/22.
//

import Foundation

public class SLCPeriod {
    var name: String // Name of the period
    var value: Int // Time range in unix time
    
    public init(_ name: String, _ value: Int) {
        self.name = name
        self.value = value
    }
}
