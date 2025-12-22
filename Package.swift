// swift-tools-version: 6.1
import PackageDescription

let package = Package(
	name: "Bake",

	platforms: [
		.macOS(.v13)
	],
	products: [
		.library(name: "Bake", type: .dynamic, targets: ["Bake"]),
		.library(name: "BakeXcode", type: .dynamic, targets: ["BakeXcode"]),
		.executable(name: "BakeCLI", targets: ["BakeCLI"])
	],
	dependencies: [
		.package(url: "https://github.com/openbakery/OBExtra/", branch: "main"),
		.package(url: "https://github.com/nschum/SwiftHamcrest/", branch: "master"),
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
			path: "Library/Bake/Main/Sources",
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
			path: "Library/Bake/Test/Sources",
		),
		.target(
			name: "BakeXcode",
			dependencies: [
				"Bake",
				"OBCoder",
				"OBExtra",
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			],
			path: "Library/Xcode/Main/Sources",
		),
		.testTarget(
			name: "BakeXcodeTest",
			dependencies: [
				"Bake",
				"BakeXcode",
				"BakeTestHelper",
				.product(name: "Hamcrest", package: "SwiftHamcrest"),
				.product(name: "HamcrestSwiftTesting", package: "SwiftHamcrest")
			],
			path: "Library/Xcode/Test",
			sources: [
				"Sources"
			],
			resources: [
				.process("Resources")
			]
		),
		.executableTarget(
			name: "BakeCLI",
			dependencies: [
				"Bake",
				"BakeXcode",
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
