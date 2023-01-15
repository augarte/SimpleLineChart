//
//  File.swift
//  
//
//  Created by Aimar Ugarte on 10/12/22.
//

import UIKit

public class SLCDataSet {
    let graphPoints: [SLCData]
    var filteredGraphPoints: [SLCData] = []
    var lineStyle: SLCLineStyle = SLCLineStyle()
    
    public init(graphPoints: [SLCData]) {
        self.graphPoints = graphPoints
        self.filteredGraphPoints = graphPoints
    }
    
    public func filterGraphPints(period: SLCPeriod) {
        let timestamp = Int(NSDate().timeIntervalSince1970)
        filteredGraphPoints = graphPoints.filter({ value in
            return value.x > timestamp - (period.value)
        })
    }
    
    public func setLineStyle(_ lineStyle: SLCLineStyle) {
        self.lineStyle = lineStyle
    }
}
