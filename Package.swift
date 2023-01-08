// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleLineChart",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SimpleLineChart",
            targets: ["SimpleLineChart"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SimpleLineChart",
            dependencies: []),
        .testTarget(
            name: "SimpleLineChartTests",
            dependencies: ["SimpleLineChart"]),
    ]
)
