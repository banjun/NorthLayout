// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "NorthLayout",
    platforms: [.macOS(.v10_11), .iOS(.v9)],
    products: [.library(name: "NorthLayout", targets: ["NorthLayout"])],
    dependencies: [.package(url: "https://github.com/kareman/FootlessParser", .upToNextMajor(from: "0.4.0"))],
    targets: [.target(name: "NorthLayout", dependencies: ["FootlessParser"], path: "Classes")]
)
