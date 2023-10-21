// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "CArchSwinject",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .macOS(.v13),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "CArchSwinject",
            targets: [
                "CArchSwinject"
            ]
        ),
        .executable(
            name: "CArchSwinjectClient",
            targets: [
                "CArchSwinjectClient"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", from: "0.52.4"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.3"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/Swinject/SwinjectStoryboard.git", from: "2.2.2"),
        .package(url: "https://github.com/ayham-achami/CArch.git", branch: "feature/v-3.0.0")
    ],
    targets: [
        .macro(
            name: "CArchSwinjectMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "CArchSwinject",
            dependencies: [
                "CArch",
                "Swinject",
                "SwinjectStoryboard"
            ],
            exclude: [
                "Info.plist"
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .executableTarget(
            name: "CArchSwinjectClient",
            dependencies: [
                "CArchSwinject"
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "CArchSwinjectTests",
            dependencies: [
                "CArchSwinject"
            ],
            path: "CArchSwinjectTests",
            exclude: [
                "Info.plist"
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)

