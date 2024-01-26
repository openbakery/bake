// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Bake",
    products: [
        .library(name: "Bake", type: .dynamic, targets: ["Bake"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(name: "Bake", swiftSettings: [
            .unsafeFlags(["-emit-module", "-emit-library"])
        ]),
    ]
)
