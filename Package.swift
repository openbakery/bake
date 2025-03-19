// swift-tools-version:5.9
import PackageDescription

let package = Package(
	name: "Bake",

	platforms: [
		.macOS(.v10_15)
	],
	products: [
		.library(name: "Bake", type: .dynamic, targets: ["Bake"]),
		.library(name: "BakePlugins", type: .dynamic, targets: ["BakePlugins"]),
		.executable(name: "BakeCLI", targets: ["BakeCLI"])
	],
	dependencies: [
		.package(url: "https://github.com/nschum/SwiftHamcrest/", .upToNextMajor(from: "2.2.0")),
		.package(url: "https://github.com/openbakery/OBCoder/", branch: "main"),
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0")
	],
	targets: [
		.target(
			name: "Bake",
			dependencies: [
				"OBCoder",
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			],
			path: "Library",
			sources: [
				"Main/Sources"
			],
			swiftSettings: [
				.unsafeFlags(["-emit-module", "-emit-library"])
			]
		),
		.target(
			name: "BakePlugins",
			dependencies: [
				"OBCoder"
			],
			path: "Plugins/Main",
			sources: [
				"Sources"
			]
		),
		.executableTarget(
			name: "BakeCLI",
			dependencies: [
				"Bake",
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			],
			path: "Bake/Main",
			sources: [
				"Sources"
			]
			// resources: [
			// 	.process("Resources"),
			// ]
		),
		.testTarget(
			name: "BakeCLITest",
			dependencies: [
				"BakeCLI",
				"SwiftHamcrest"
			],
			path: "Bake/Test",
			sources: [
				"Sources"
			],
			resources: [
				.process("Resources")
			]
		),
		.testTarget(
			name: "BakeTest",
			dependencies: [
				"Bake",
				"SwiftHamcrest"
			],
			path: "Library/Test",
			sources: [
				"Sources"
			]
			// resources: [
			// .process("Resources"),
			// ]
		)
	]
)
