// swift-tools-version: 6.1
import PackageDescription

let package = Package(
	name: "BakeHelloWorld",

	platforms: [
		.macOS(.v13)
	],
	products: [
		.library(name: "BakeHelloWorld", targets: ["BakeHelloWorld"])
	],
	dependencies: [
		.package(url: "https://github.com/openbakery/bake/", branch: "develop")
	],
	targets: [
		.target(
			name: "BakeHelloWorld",
			dependencies: [
				.product(name: "Bake", package: "Bake")
			],
			path: "Main/Sources"
		)
	]
)
