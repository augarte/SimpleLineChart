//
//  File.swift
//  
//
//  Created by Aimar Ugarte on 15/1/23.
//

import UIKit

public class SLCChartStyle {
    var solidBackgroundColor: UIColor
    var backgroundGradient: Bool
    var gradientStartColor: UIColor
    var gradientEndColor: UIColor
    var addPeriodButtons: Bool
    
    public init(backgroundGradient: Bool = true,
                solidBackgroundColor: UIColor = .hexStringToUIColor(hex: "FD4345"),
                gradientStartColor: UIColor = .hexStringToUIColor(hex: "FEB775"),
                gradientEndColor: UIColor = .hexStringToUIColor(hex: "FD4345"),
                addPeriodButtons: Bool = false) {
        self.solidBackgroundColor = solidBackgroundColor
        self.backgroundGradient = backgroundGradient
        self.gradientStartColor = gradientStartColor
        self.gradientEndColor = gradientEndColor
        self.addPeriodButtons = addPeriodButtons
    }
}
