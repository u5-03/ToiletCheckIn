// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToiletCheckInCore",
    platforms: [.iOS(.v17), .watchOS(.v10)],
    products: [
        .library(
            name: "ToiletCheckInCore",
            targets: ["ToiletCheckInCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-testing", branch: "main"),
    ],
    targets: [
        .target(
            name: "ToiletCheckInCore"),
        .testTarget(
            name: "ToiletCheckInCoreTests",
            dependencies: [
                "ToiletCheckInCore",
                .product(name: "Testing", package: "swift-testing")
            ]),
    ]
)
