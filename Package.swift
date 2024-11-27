// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "NetworkKit",
    products: [
        .library(name: "NetworkKit", targets: ["NetworkKit"])
    ],
    targets: [
        .target(name: "NetworkKit", dependencies: []),
        .testTarget(name: "NetworkKitTests", dependencies: ["NetworkKit"])
    ]
)
