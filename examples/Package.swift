// swift-tools-version: 6.1
import PackageDescription

let package = Package(
	name: "LocalBake",

	platforms: [
		.macOS(.v13)
	],
	products: [
		.executable(name: "bake", targets: ["LocalBake"])
	],
	dependencies: [
		.package(url: "https://github.com/openbakery/bake/", branch: "develop"),
		// .package(url: "https://github.com/openbakery/OBExtra/", branch: "main"),
		// .package(url: "https://github.com/openbakery/OBCoder/", branch: "main"),
		.package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "1.0.0"))
	],
	targets: [

		.executableTarget(
			name: "LocalBake",
			dependencies: [
				// .product(name: "Bake", package: "bake"),
				.product(name: "BakeXcode", package: "bake"),
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			],
			path: "Sources",
		)
	]
)
