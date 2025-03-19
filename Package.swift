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
		.package(url: "https://github.com/nschum/SwiftHamcrest/", .upToNextMajor(from: "2.3.0")),
		.package(url: "https://github.com/openbakery/OBCoder/", branch: "main"),
		.package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "1.0.0")),
		.package(url: "https://github.com/swiftlang/swift-testing", revision: "18c42c19cac3fafd61cab1156d4088664b7424ae")
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
			]
		),
		.target(
			name: "BakePlugins",
			dependencies: [
				"Bake",
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
				"BakePlugins",
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
				.product(name: "Testing", package: "swift-testing"),
				.product(name: "Hamcrest", package: "SwiftHamcrest")
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
				.product(name: "Testing", package: "swift-testing"),
				.product(name: "Hamcrest", package: "SwiftHamcrest")
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
