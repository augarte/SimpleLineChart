//
//  File.swift
//  
//
//  Created by Aimar Ugarte on 10/12/22.
//

import UIKit

public class SLCDataSet {
    let graphPoints: [SLCData]
    let lineColor: UIColor
    var filteredGraphPoints: [SLCData] = []
    
    public init(graphPoints: [SLCData], lineColor: UIColor) {
        self.graphPoints = graphPoints
        self.filteredGraphPoints = graphPoints
        self.lineColor = lineColor
    }
    
    public func filterGraphPints(period: SLCPeriod) {
        let timestamp = Int(NSDate().timeIntervalSince1970)
        filteredGraphPoints = graphPoints.filter({ value in
            return value.x > timestamp - (period.value)
        })
    }
}
