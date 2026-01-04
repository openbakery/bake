//
// Created by René Pirringer on 23.12.2025
//

import Bake
import Foundation

public enum LoadingError: Error {
	case resourceMissing(String)
}

struct Bootstrap {

	init(config: URL, commandRunner: CommandRunner) throws {
		let data = try Self.load(config: config)

		let rootDirectory = config.deletingLastPathComponent()
		try self.init(
			dependencies: data.dependencies,
			main: data.main,
			buildDirectory: rootDirectory.appendingPathComponent(Self.defaultBuildDirectory),
			commandRunner: commandRunner)
	}

	init(dependencies: [Dependency], main: [String] = [], buildDirectory: URL, commandRunner: CommandRunner) throws {
		if let packageString = try Bundle.module.load(filename: "Package.template") {
			self.packageString = packageString
		} else {
			throw LoadingError.resourceMissing("Cannot load Package.template")
		}
		self.dependencies = dependencies
		self.mainSwift = main
		self.buildDirectory = buildDirectory
		self.commandRunner = commandRunner
	}

	let packageString: String
	let dependencies: [Dependency]
	let mainSwift: [String]
	let buildDirectory: URL
	let commandRunner: CommandRunner
	var bootstrapDirectory: URL { buildDirectory.appendingPathComponent(Self.defaultBootstrapDirectory) }

	static let defaultBuildDirectory = "build/bake/"
	static let defaultBootstrapDirectory = "bootstrap/"
	static let defaultSources = "Sources/"

	func prepare() throws {
		try bootstrapDirectory.createDirectories()
		try createPackageSwift()
		try createMainSwift()
	}

	func run() async throws {
		try prepare()
		try await build()
		let source = bootstrapDirectory.appendingPathComponent(".build/arm64-apple-macosx/debug/bake")
		if source.fileExists() {
			try FileManager.default.moveItem(at: source, to: bootstrapDirectory.appendingPathComponent("bake"))
		}
	}

	func clean() {
		buildDirectory.deleteIfExists()
	}

	func createPackageSwift() throws {
		let packageFile = bootstrapDirectory.appendingPathComponent("Package.swift")

		let dependenciesString = self.dependencies.map({ $0.description }).joined(separator: ",\n\t\t\t\t")
		let contents = packageString.replacingOccurrences(of: "{{DEPENDENCIES}}", with: dependenciesString)

		try contents.write(to: packageFile, atomically: true, encoding: String.Encoding.utf8)
	}

	func createMainSwift() throws {
		let sourcesDirectory = bootstrapDirectory.appendingPathComponent(Self.defaultSources)
		try sourcesDirectory.createDirectories()
		let mainFile = sourcesDirectory.appendingPathComponent("main.swift")
		let contents = mainSwift.joined(separator: "\n")
		try contents.write(to: mainFile, atomically: true, encoding: String.Encoding.utf8)
	}

	func build() async throws {
		try await commandRunner.run("/usr/bin/swift", "build", "--package-path", bootstrapDirectory.path, outputHandler: LogOutputHandler())
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
