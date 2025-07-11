// swift-tools-version:5.9
import PackageDescription

let package = Package(
	name: "Bake",

	platforms: [
		.macOS(.v12)
	],
	products: [
		.library(name: "Bake", type: .dynamic, targets: ["Bake"]),
		.library(name: "BakePlugins", type: .dynamic, targets: ["BakePlugins"]),
		.executable(name: "BakeCLI", targets: ["BakeCLI"])
	],
	dependencies: [
		.package(url: "https://github.com/nschum/SwiftHamcrest/", branch: "master"),
		.package(url: "https://github.com/openbakery/OBCoder/", branch: "main"),
		.package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "1.0.0")),
		// is version 6.1.1 but the hash is used to allow the dependency when marked unsafe
		.package(url: "https://github.com/swiftlang/swift-testing", .revision("32cf2c500cbc1b45bd4b4803a2a108995f2d31e6"))
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
			path: "Plugins",
			sources: [
				"Main/Sources"
			]
		),
		.executableTarget(
			name: "BakeCLI",
			dependencies: [
				"BakePlugins",
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			],
			path: "Bake",
			sources: [
				"Main/Sources"
			]
			// resources: [
			// 	.process("Resources"),
			// ]
		),
		.target(
			name: "BakeTestHelper",
			dependencies: [
				"Bake"
			],
			path: "Library",
			sources: [
				"TestHelper/Sources"
			]
		),
		.testTarget(
			name: "BakeCLITest",
			dependencies: [
				"BakeCLI",
				.product(name: "Testing", package: "swift-testing"),
				.product(name: "Hamcrest", package: "SwiftHamcrest")
			],
			path: "Bake",
			sources: [
				"Test/Sources"
			],
			resources: [
				.process("Resources")
			]
		),
		.testTarget(
			name: "BakeTest",
			dependencies: [
				"Bake",
				"BakeTestHelper",
				.product(name: "Testing", package: "swift-testing"),
				.product(name: "Hamcrest", package: "SwiftHamcrest")
			],
			path: "Library",
			sources: [
				"Test/Sources"
			]
		),
		.testTarget(
			name: "BakePluginsTest",
			dependencies: [
				"Bake",
				"BakeTestHelper",
				.product(name: "Testing", package: "swift-testing")
			],
			path: "Plugins",
			sources: [
				"Test/Sources"
			]
		)
	]
)
