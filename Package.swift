// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "CArchSwinject",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .macOS(.v12),
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
        .package(url: "https://github.com/realm/SwiftLint", from: "0.55.1"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.8.7"),
        .package(url: "https://github.com/ayham-achami/CArch.git", branch: "release/3.1.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "510.0.2"),
        .package(url: "https://github.com/Swinject/SwinjectStoryboard.git", from: "2.2.2")
    ],
    targets: [
        .macro(
            name: "CArchSwinjectMacros",
            dependencies: [
                "CArch",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "CArchSwinject",
            dependencies: [
                "CArch",
                "Swinject",
                "SwinjectStoryboard",
                "CArchSwinjectMacros"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .executableTarget(
            name: "CArchSwinjectClient",
            dependencies: [
                "CArch",
                "CArchSwinject"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "CArchSwinjectTests",
            dependencies: [
                "CArchSwinject"
            ],
            path: "CArchSwinjectTests",
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)

let defaultSettings: [SwiftSetting] = [.enableExperimentalFeature("StrictConcurrency=minimal")]
package.targets.forEach { target in
    if var settings = target.swiftSettings, !settings.isEmpty {
        settings.append(contentsOf: defaultSettings)
        target.swiftSettings = settings
    } else {
        target.swiftSettings = defaultSettings
    }
}
