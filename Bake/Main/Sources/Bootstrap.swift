//
// Created by René Pirringer on 23.12.2025
//

import Bake
import Foundation

public enum LoadingError: Error {
	case resourceMissing(String)
}

struct Bootstrap {

	init(config: URL) throws {
		let data = try Self.load(config: config)
		try self.init(dependencies: data.dependencies, main: data.main, buildDirectory: config.appendingPathComponent(Self.defaultBuildDirectory))
	}

	init(dependencies: [Dependency], main: [String] = [], buildDirectory: URL = .temporaryDirectory) throws {
		if let packageString = try Bundle.module.load(filename: "Package.template") {
			self.packageString = packageString
		} else {
			throw LoadingError.resourceMissing("Cannot load Package.template")
		}
		self.dependencies = dependencies
		self.mainSwift = main
		self.buildDirectory = buildDirectory
	}

	let packageString: String
	let dependencies: [Dependency]
	let mainSwift: [String]
	let buildDirectory: URL
	var bootstrapDirectory: URL { buildDirectory.appendingPathComponent(Self.defaultBootstrapDirectory) }

	static let defaultBuildDirectory = "build/bake/"
	static let defaultBootstrapDirectory = "bootstrap/"

	func run() throws {
		try createPackageSwift()
		try createMainSwift()
	}

	func createPackageSwift() throws {
		let packageFile = bootstrapDirectory.appendingPathComponent("Package.swift")

		let dependenciesString = self.dependencies.map({ $0.description }).joined(separator: ",\n\t\t\t\t")
		let contents = packageString.replacingOccurrences(of: "{{DEPENDENCIES}}", with: dependenciesString)

		try contents.write(to: packageFile, atomically: true, encoding: String.Encoding.utf8)
	}

	func createMainSwift() throws {
		let mainFile = bootstrapDirectory.appendingPathComponent("Sources/main.swift")
		let contents = mainSwift.joined(separator: "\n")
		try contents.write(to: mainFile, atomically: true, encoding: String.Encoding.utf8)
	}

	static func load(config: URL) throws -> (dependencies: [Dependency], main: [String]) {
		let contents = try String(contentsOf: config, encoding: .utf8)

		let parser = LineParser(contents)

		var dependencies = [Dependency]()
		var mainSwift = [String]()
		while let line = parser.nextLine() {

			if line.hasPrefix("@import") {
				if let dependency = Dependency(line: line) {
					dependencies.append(dependency)
					mainSwift.append("import \(dependency.name)")
				}
			} else {
				mainSwift.append(line)
			}
		}

		return (dependencies, mainSwift)
	}

}
