// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "CArchSwinject",
                      // platforms
                      platforms: [.iOS(.v11)],
                      // Products
                      products: [.library(name: "CArchSwinject", targets: ["CArchSwinject"])],
                      // Dependencies
                      dependencies: [.package(name: "CArch" , url: "https://github.com/ayham-achami/CArch.git", .branch("mainline")),
                                     .package(name: "Swinject", url: "https://github.com/Swinject/Swinject.git", from: "2.8.2"),
                                     .package(name: "SwinjectStoryboard", url: "https://github.com/Swinject/SwinjectStoryboard.git", from: "2.2.2")],
                      // Targets
                      targets: [.target(name: "CArchSwinject",
                                        dependencies: ["CArch", "Swinject", "SwinjectStoryboard"],
                                        path: "Sources"),
                                .testTarget(name: "CArchSwinjectTests",
                                            dependencies: ["CArchSwinject"],
                                            path: "Tests",
                                            exclude: ["Info.plist"])])
