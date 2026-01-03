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
		.package(url: "https://github.com/openbakery/bake/", branch: "develop")
	],
	targets: [

		.executableTarget(
			name: "LocalBake",
			dependencies: [
				.product(name: "BakeXcode", package: "bake")
			],
			path: "Sources",
		)
	]
)
