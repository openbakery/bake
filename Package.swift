// swift-tools-version:5.9
import PackageDescription

let package = Package(
	name: "Bake",
  products: [
    .library(name: "Bake", type: .dynamic, targets: ["Bake"]),
	 	.executable(name: "BakeCLI", targets: ["BakeCLI"]),
  ],
  dependencies: [
  ],
	targets: [
		.target(
			name: "Bake",
			path: "Library",
			sources: [
				"Main/Sources",
			],
			swiftSettings: [
				.unsafeFlags(["-emit-module", "-emit-library"])
			]
		),

		.executableTarget(
			name: "BakeCLI",
			path: "Bake",
			sources: [
				"Main/Sources",
			]
		)
	]
)
