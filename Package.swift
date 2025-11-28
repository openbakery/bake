// swift-tools-version: 6.2
import PackageDescription

let package = Package(
	name: "Bake",

	platforms: [
		.macOS(.v13)
	],
	products: [
		.library(name: "Bake", type: .dynamic, targets: ["Bake"]),
		.library(name: "BakePlugins", type: .dynamic, targets: ["BakePlugins"]),
		.executable(name: "BakeCLI", targets: ["BakeCLI"])
	],
	dependencies: [
		.package(url: "https://github.com/openbakery/OBExtra/", branch: "main"),
		.package(url: "https://github.com/nschum/SwiftHamcrest/", branch: "no-macro"),
		.package(url: "https://github.com/openbakery/OBCoder/", branch: "main"),
		.package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "1.0.0"))
	],
	targets: [
		.target(
			name: "Bake",
			dependencies: [
				"OBCoder",
				"OBExtra"
			],
			path: "Library/Main/Sources",
		),
		.target(
			name: "BakeTestHelper",
			dependencies: [
				"Bake"
			],
			path: "Library/TestHelper/Sources",
		),
		.testTarget(
			name: "BakeTest",
			dependencies: [
				"Bake",
				"BakeTestHelper",
				.product(name: "Hamcrest", package: "SwiftHamcrest"),
				.product(name: "HamcrestSwiftTesting", package: "SwiftHamcrest")
			],
			path: "Library/Test/Sources",
		),
		.target(
			name: "BakePlugins",
			dependencies: [
				"Bake",
				"OBCoder",
				"OBExtra"
			],
			path: "Plugins/Main/Sources",
		),
		.testTarget(
			name: "BakePluginsTest",
			dependencies: [
				"Bake",
				"BakePlugins",
				"BakeTestHelper",
				.product(name: "Hamcrest", package: "SwiftHamcrest"),
				.product(name: "HamcrestSwiftTesting", package: "SwiftHamcrest")
			],
			path: "Plugins/Test/Sources"
		),
		.executableTarget(
			name: "BakeCLI",
			dependencies: [
				"Bake",
				"BakePlugins",
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			],
			path: "Bake/Main/Sources",
		),
		.testTarget(
			name: "BakeCLITest",
			dependencies: [
				"BakeCLI",
				"BakeTestHelper",
				.product(name: "Hamcrest", package: "SwiftHamcrest"),
				.product(name: "HamcrestSwiftTesting", package: "SwiftHamcrest")
			],
			path: "Bake/Test/Sources",
		)
	]
)
