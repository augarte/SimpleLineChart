//
//  File.swift
//  
//
//  Created by Aimar Ugarte on 15/1/23.
//

import UIKit

public class SLCLineStyle {
    var lineColor: UIColor
    var lineStroke: CGFloat
    var circleDiameter: CGFloat
    
    var lineShadow: Bool = true
    var lineShadowgradientStart: UIColor
    var lineShadowgradientEnd: UIColor
    
    public init(lineColor: UIColor = .white,
                lineStroke: CGFloat = 5.0,
                circleDiameter: CGFloat = 0.0,
                lineShadow: Bool = true,
                lineShadowgradientStart: UIColor = UIColor.hexStringToUIColor(hex: "FEB775"),
                lineShadowgradientEnd: UIColor = UIColor.hexStringToUIColor(hex: "FD4345")) {
        self.lineColor = lineColor
        self.lineStroke = lineStroke
        self.circleDiameter = circleDiameter
        self.lineShadow = lineShadow
        self.lineShadowgradientStart = lineShadowgradientStart
        self.lineShadowgradientEnd = lineShadowgradientEnd
    }
}
