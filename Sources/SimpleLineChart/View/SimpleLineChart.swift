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
        static let margin: CGFloat = 20.0
        static let periodTopSpace: CGFloat = Constants.margin
        static let periodSpacing: CGFloat = 5.0
        static let periodBottomSpace: CGFloat = 10.0
        static let periodStackHeight: CGFloat = 30.0
        static let cornerRadius: CGFloat = 8.0
        static let cornerRadiusSize = CGSize(width: Constants.cornerRadius,
                                             height: Constants.cornerRadius)
    }
    
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
    private var chartStyle = SLCChartStyle()
    private var selectedPeriod = CurrentValueSubject<SLCPeriod?, Never>(SLCPeriod?(nil))
    private var periodSelectors: Array<SLCPeriod> = [SLCPeriod("1 Month", 2629800),
                                                  SLCPeriod("3 Month", 7889400),
                                                  SLCPeriod("1 Year", 31557600),
                                                  SLCPeriod("All Time", 3155760000)]
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = .clear
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func draw(_ rect: CGRect) {
        guard let dataSet = dataSets.first else {
            showEmptyState(rect)
            return
        }
        
        // MARK: Background
        setupGraph(rect, data: dataSet)
        
        // MARK: Lines
        for data in dataSets {
            drawLine(rect, data: data)
        }
        
        // MARK: Date selectors
        if chartStyle.addPeriodButtons {
            addPeriodStackView(width: rect.width, height: rect.height)
        }
    }
}

// MARK: - Setups
@available(iOS 13.0, *)
private extension SimpleLineChart {
    
    private func setupGraph(_ rect: CGRect, data: SLCDataSet) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // MARK: Load initial points
        if selectedPeriod.value == nil {
            selectedPeriod.value = chartStyle.addPeriodButtons ? periodSelectors.first : periodSelectors.last
        }
        changeDateRange(period: selectedPeriod.value!)
        
        // MARK: Graph setup
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: .allCorners,
            cornerRadii: Constants.cornerRadiusSize
        )
        path.addClip()
        
        // MARK: Background color
        if (chartStyle.backgroundGradient) {
            // Gradient setup
            let colors = [chartStyle.gradientStartColor.cgColor,
                          chartStyle.gradientEndColor.cgColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorLocations: [CGFloat] = [0.0, 1.0]
            
            guard let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: colors as CFArray,
                locations: colorLocations
            ) else { return }

            // MARK: Draw gradient
            let startPoint = CGPoint.zero
            let endPoint = CGPoint(x: 0, y: bounds.height)
            context.drawLinearGradient(
                gradient,
                start: startPoint,
                end: endPoint,
                options: []
            )
        } else {
            layer.cornerRadius = Constants.cornerRadius;
            layer.masksToBounds = true;
            backgroundColor = chartStyle.solidBackgroundColor
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
        let bottomBorder = chartStyle.addPeriodButtons ? Constants.periodStackHeight + Constants.periodTopSpace + Constants.periodBottomSpace : Constants.margin
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
        data.lineStyle.lineColor.setStroke()
        graphPath.lineWidth = data.lineStyle.lineStroke
        graphPath.stroke()
        
        // MARK: Line shadow
        if (data.lineStyle.lineShadow && dataSets.count == 1) {
            context.saveGState()
            // Line shadow gradient setup
            let startColor = data.lineStyle.lineShadowgradientStart.cgColor
            let endColor = data.lineStyle.lineShadowgradientEnd.cgColor

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
                                        y: bounds.height - (chartStyle.backgroundGradient ? 0 : bottomBorder))

            context.drawLinearGradient(
                shadowGradient,
                start: graphStartPoint,
                end: graphEndPoint,
                options: [])
            context.restoreGState()
        }
        
        // MARK: Data points
        let circleDiameter = data.lineStyle.circleDiameter
        data.lineStyle.lineColor.setFill()
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

// MARK: - Period buttons
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
            let button = SLCPeriodButton(period: period,
                                         color:chartStyle.gradientStartColor,
                                         selectedPeriod: selectedPeriod, frame: frame)
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

// MARK: - EmptyState
@available(iOS 13.0, *)
extension SimpleLineChart {
    
    private func showEmptyState(_ rect: CGRect) {
        let emptyState = SLCEmptyState()
        addSubview(emptyState)
        NSLayoutConstraint.activate([
            emptyState.topAnchor.constraint(equalTo: topAnchor),
            emptyState.bottomAnchor.constraint(equalTo: bottomAnchor),
            emptyState.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyState.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Data setup
@available(iOS 13.0, *)
public extension SimpleLineChart {
    
    func loadPoints(dataSet: SLCDataSet) {
        loadPoints(dataSets: [dataSet])
    }
    
    func loadPoints(dataSets: [SLCDataSet]) {
        self.dataSets = dataSets
        self.setNeedsDisplay()
    }
    
    func setChartStyle(chartStyle: SLCChartStyle) {
        self.chartStyle = chartStyle
        self.setNeedsDisplay()
    }
}
