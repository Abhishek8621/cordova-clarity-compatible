// swift-tools-version:5.9

import PackageDescription

let claritySDKVersion: Version = "3.3.0"

let package = Package(
    name: "cordova-clarity",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "@microsoft/cordova-clarity",
            targets: ["cordova-clarity"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apache/cordova-ios.git", branch: "master"),
        .package(url: "https://github.com/microsoft/clarity-apps", exact: claritySDKVersion)
    ],
    targets: [
        .target(
            name: "cordova-clarity",
            dependencies: [
                .product(name: "Cordova", package: "cordova-ios"),
                .product(name: "Clarity", package: "clarity-apps")
            ],
            path: "src/ios"
        )
    ]
)
