// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CArchSwinject",
    platforms: [.iOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CArchSwinject",
            targets: ["CArchSwinject"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "CArch" , url: "https://github.com/ayham-achami/CArch.git", .branch("mainline")),
        .package(name: "Swinject", url: "https://github.com/Swinject/Swinject.git", from: "2.8.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CArchSwinject",
            dependencies: [
                "CArch",
                "Swinject",
                "SwinjectStoryboard"
            ],
            path: "Sources",
            exclude: ["Info.plist"]),
        .testTarget(
            name: "CArchSwinjectTests",
            dependencies: ["CArchSwinject"],
            path: "Tests",
            exclude: ["Info.plist"]),
    ]
)
