# SimpleLineChart

![Releases](https://img.shields.io/github/v/release/augarte/SimpleLineChart?include_prereleases)
![Versions](https://img.shields.io/cocoapods/v/SimpleLineChart)
![Platform](https://img.shields.io/cocoapods/p/SimpleLineChart.svg?style=flat)
![License](https://img.shields.io/cocoapods/l/SimpleLineChart.svg?style=flat)

## Description

<img alt="SLC" src="Screenshots/SLC.jpg" style="border-radius:18px" height="250px">
<img alt="SLC Styled" src="Screenshots/SLC_Styled.jpg" style="border-radius:18px" height="250px">

SimpleLineChart is a simple, lightweight line chart library for iOS. It provides an easy-to-use interface to create customizable line charts with a few lines of code. The library supports customizable styles. It's a great option for developers who need to quickly add line charts to their iOS apps without the overhead of a larger, more complex charting library.

## Usage

Setting up the chart 
```swift
    let values: [SLCData] = [SLCData(x: 0, y: 5),
                             SLCData(x: 1, y: 7),
                             SLCData(x: 2, y: 9)]

    let lineChart = SimpleLineChart()

    let dataSet = SLCDataSet(graphPoints: values)
    lineChart.loadPoints(dataSet: dataSet)
```

Styling the chart background
```swift
    let chartStyle = SLCChartStyle(backgroundGradient: false,
                                   solidBackgroundColor: .white)
    lineChart.setChartStyle(chartStyle: chartStyle)
```

Styling the chart line
```swift
    let lineStyle = SLCLineStyle(lineColor: .blue,
                                 lineStroke: 3.0,
                                 circleDiameter: 5.0,
                                 lineShadow: true,
                                 lineShadowgradientStart: .blue,
                                 lineShadowgradientEnd: .white)
    dataSet.setLineStyle(lineStyle)
```

## Installation

##### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/augarte/SimpleLineChart.git", .upToNextMajor(from: "1.0.0"))
]
```

##### CocoaPods

    pod 'SimpleLineChart'


## Example

Example app can be found on the following repository [SLCExampleApp](https://github.com/augarte/SLCExampleApp)

## License

SimpleLineChart is available under the GPL license.
See the [LICENSE](https://github.com/augarte/SimpleLineChart/blob/main/LICENSE) for more info.
