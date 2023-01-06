//
//  SimpleLineChart.swift
//  Sendo
//
//  Created by Aimar Ugarte on 29/5/22.
//

import Combine
import UIKit

@available(iOS 13.0, *)
@IBDesignable
public final class SimpleLineChart: UIView {
    
    // MARK: Constants
    private enum Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let periodSpacing: CGFloat = 5.0
        static let periodTopSpace: CGFloat = Constants.margin
        static let periodBottomSpace: CGFloat = 10.0
        static let periodStackHeight: CGFloat = 30.0
    }
    
    // MARK: Inspectables
    @IBInspectable public var lineStroke: CGFloat = 3.0
    @IBInspectable public var lineColor: UIColor = .white
    @IBInspectable public var circleDiameter: CGFloat = 5.0
    
    @IBInspectable public var solidBackgroundColor: UIColor = .hexStringToUIColor(hex: "FD4345")
    
    @IBInspectable public var backgroundGradient: Bool = true
    @IBInspectable public var gradientStartColor: UIColor = .hexStringToUIColor(hex: "FEB775")
    @IBInspectable public var gradientEndColor: UIColor = .hexStringToUIColor(hex: "FD4345")
    
    @IBInspectable public var lineShadow: Bool = true
    @IBInspectable public var lineShadowgradientStart: UIColor = .hexStringToUIColor(hex: "FEB775")
    @IBInspectable public var lineShadowgradientEnd: UIColor = .hexStringToUIColor(hex: "FEB775")
    
    @IBInspectable public var addPeriodButtons: Bool = true
    
    // MARK: UI variables
    private lazy var periodStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        stackview.spacing = Constants.periodSpacing
        return stackview
    }()
    
    // MARK: Private variables
    private var dataSets: [SLCDataSet] = []
    private var selectedPeriod = CurrentValueSubject<SLCPeriod?, Never>(SLCPeriod?(nil))
    private var periodSelectors: Array<SLCPeriod> = [SLCPeriod("1 Month", 2629800),
                                                  SLCPeriod("3 Month", 7889400),
                                                  SLCPeriod("1 Year", 31557600),
                                                  SLCPeriod("All Time", 3155760000)]
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func draw(_ rect: CGRect) {
        // MARK: Background
        setupGraph(rect, data: dataSets.first!)
        
        // MARK: Lines
        for data in dataSets {
            drawLine(rect, data: data)
        }
        
        // MARK: Date selectors
        if addPeriodButtons {
            addPeriodStackView(width: rect.width, height: rect.height)
        }
    }
}

// MARK: Setups
@available(iOS 13.0, *)
private extension SimpleLineChart {
    
    private func setupGraph(_ rect: CGRect, data: SLCDataSet) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // -------------------
        // Load initial points
        if selectedPeriod.value == nil {
            selectedPeriod.value = periodSelectors.first
        }
        changeDateRange(period: selectedPeriod.value!)
        
        // -------------------
        // Graph setup
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: .allCorners,
            cornerRadii: Constants.cornerRadiusSize
        )
        path.addClip()
        
        // -------------------
        // Background color
        if (backgroundGradient) {
            // Gradient setup
            let colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorLocations: [CGFloat] = [0.0, 1.0]
            
            guard let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: colors as CFArray,
                locations: colorLocations
            ) else { return }

            // Draw gradient
            let startPoint = CGPoint.zero
            let endPoint = CGPoint(x: 0, y: bounds.height)
            context.drawLinearGradient(
                gradient,
                start: startPoint,
                end: endPoint,
                options: []
            )
        } else {
            layer.cornerRadius = 8;
            layer.masksToBounds = true;
            backgroundColor = solidBackgroundColor
            backgroundColor?.setFill()
            UIGraphicsGetCurrentContext()!.fill(rect);
        }
    }
    
    private func drawLine(_ rect: CGRect, data: SLCDataSet) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let width = rect.width
        let height = rect.height
        let margin = Constants.margin
        
        // MARK: X Point
        let graphWidth = width - margin * 2 - 4
        let xValues = data.filteredGraphPoints.map({ point in return point.x })
        guard let minXValue = xValues.min() else { return }
        guard let maxXValue = xValues.max() else { return }
        let columnXPoint = { (column: Int) -> CGFloat in
            // Calculate the gap between points
            guard data.filteredGraphPoints.count > 1 else {
                return CGFloat(graphWidth/2) + margin + 2
            }
            let xPoint = CGFloat(column-minXValue) / CGFloat(maxXValue-minXValue) * graphWidth
            return CGFloat(xPoint) + margin + 2
        }
        
        // MARK: Y Point
        let topBorder = Constants.margin
        let bottomBorder = addPeriodButtons ? Constants.periodStackHeight + Constants.periodTopSpace + Constants.periodBottomSpace : Constants.margin
        let graphHeight = height - topBorder - bottomBorder
        let yValues = data.filteredGraphPoints.map({ point in return point.y })
        guard let minYValue = yValues.min() else { return }
        guard let maxYValue = yValues.max() else { return }
        let columnYPoint = { (graphPoint: Double) -> CGFloat in
            guard data.filteredGraphPoints.count > 1 else {
                return graphHeight + topBorder - (graphHeight/2)
            }
            var yPoint = graphHeight / 2
            if maxYValue-minYValue != 0 {
                yPoint = CGFloat(graphPoint-minYValue) / CGFloat(maxYValue-minYValue) * graphHeight
            }
            return graphHeight + topBorder - yPoint // Flip the graph
        }
        
        // MARK: Stroke
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: columnXPoint(data.filteredGraphPoints[0].x), y: columnYPoint(data.filteredGraphPoints[0].y)))
        for i in 1..<data.filteredGraphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(data.filteredGraphPoints[i].x), y: columnYPoint(data.filteredGraphPoints[i].y))
            graphPath.addLine(to: nextPoint)
        }
        
        // MARK: Line Style
        data.lineColor.setStroke()
        graphPath.lineWidth = lineStroke
        graphPath.stroke()
        
        // MARK: Line shadow
        if (lineShadow && dataSets.count == 1) {
            context.saveGState()
            // Line shadow gradient setup
            let startColor = gradientStartColor.cgColor
            let endColor = backgroundGradient ? gradientEndColor.cgColor : solidBackgroundColor.cgColor

            let colors = [startColor, endColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorLocations: [CGFloat] = [0.0, 1.0]

            guard let shadowGradient = CGGradient(
                colorsSpace: colorSpace,
                colors: colors as CFArray,
                locations: colorLocations
            ) else { return }

            // Draw line shadow
            guard let clippingPath = graphPath.copy() as? UIBezierPath else {
                return
            }

            clippingPath.addLine(to: CGPoint(
                x: columnXPoint(data.filteredGraphPoints[data.filteredGraphPoints.count - 1].x),
                y: height))
            clippingPath.addLine(to: CGPoint(x: columnXPoint(data.filteredGraphPoints[0].x), y: height))
            clippingPath.close()
            clippingPath.addClip()

            let highestYPoint = columnYPoint(maxYValue)
            let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
            let graphEndPoint = CGPoint(x: margin,
                                        y: bounds.height - (backgroundGradient ? 0 : bottomBorder))

            context.drawLinearGradient(
                shadowGradient,
                start: graphStartPoint,
                end: graphEndPoint,
                options: [])
            context.restoreGState()
        }
        
        // MARK: Data points
        data.lineColor.setFill()
        for i in 0..<data.filteredGraphPoints.count {
            var point = CGPoint(x: columnXPoint(data.filteredGraphPoints[i].x), y: columnYPoint(data.filteredGraphPoints[i].y))
            point.x -= circleDiameter / 2
            point.y -= circleDiameter / 1.5

            let circle = UIBezierPath(
                ovalIn: CGRect(
                    origin: point,
                    size: CGSize(
                        width: circleDiameter,
                        height: circleDiameter)
                )
            )
            circle.fill()
        }
    }
}

// MARK: Period buttons
@available(iOS 13.0, *)
private extension SimpleLineChart {
    
    func addPeriodStackView(width: Double, height: Double) {
        guard !periodStackView.isDescendant(of: self) else { return }
        
        addSubview(periodStackView)
        NSLayoutConstraint.activate([
            periodStackView.heightAnchor.constraint(equalToConstant: Constants.periodStackHeight),
            periodStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: Constants.margin),
            periodStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -Constants.margin),
            periodStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -Constants.periodBottomSpace)
        ])
        addPeriodSelectors(width: width, height: height)
    }
    
    func addPeriodSelectors(width: Double, height: Double) {
        periodStackView.removeAllArrangedSubviews()
        let buttonWidth = ((width - (Constants.margin * Double(periodSelectors.count+1))) / Double(periodSelectors.count))
        
        for (i, period) in periodSelectors.enumerated() {
            let separation = i != 0 ? Constants.margin : 0
            let frame = CGRect(x: Constants.margin + (separation + buttonWidth) * Double(i),
                               y: 0,
                               width: buttonWidth,
                               height: Constants.periodStackHeight)
            let button = SLCPeriodButton(period: period, color:gradientStartColor, selectedPeriod: selectedPeriod, frame: frame)
            button.addTarget(self, action: #selector(dateButtonPress), for: .touchUpInside)
            periodStackView.addArrangedSubview(button)
        }
    }
    
    @objc func dateButtonPress(sender: SLCPeriodButton) {
        guard let period = sender.period else { return }
        selectedPeriod.send(period)
        changeDateRange(period: period)
        self.setNeedsDisplay()
    }
    
    func changeDateRange(period: SLCPeriod) {
        selectedPeriod.value = period
        for data in dataSets {
            data.filterGraphPints(period: period)
        }
    }
}

// MARK: Data setup
@available(iOS 13.0, *)
extension SimpleLineChart {
    
    public func loadPoints(dataSet: SLCDataSet) {
        loadPoints(dataSets: [dataSet])
    }
    
    public func loadPoints(dataSets: [SLCDataSet]) {
        self.dataSets = dataSets
        self.setNeedsDisplay()
    }
}
