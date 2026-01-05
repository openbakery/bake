//
// Created by René Pirringer on 23.12.2025
//

import Bake
import Foundation
import OBExtra

public enum LoadingError: Error {
	case resourceMissing(String)
}

struct Bootstrap {

	init(config: URL, commandRunner: CommandRunner) throws {
		let configFile: URL
		if config.isDirectory {
			configFile = config.appendingPathComponent("Bake.swift")
		} else {
			configFile = config
		}
		Log.debug("loading: \(configFile)")

		guard configFile.fileExists() else {
			Log.debug("Config does not exist: \(configFile)")
			throw BakeError.illegalStateError("Config does not exist: \(configFile)")
		}
		let data = try Self.load(config: configFile)

		let rootDirectory = configFile.deletingLastPathComponent()
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
		Log.debug("prepare")
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
		Log.debug("create Package.swift file")
		let packageFile = bootstrapDirectory.appendingPathComponent("Package.swift")

		let dependenciesString = self.dependencies.map({ $0.description }).joined(separator: ",\n\t\t\t\t")
		let contents = packageString.replacingOccurrences(of: "{{DEPENDENCIES}}", with: dependenciesString)

		try contents.write(to: packageFile, atomically: true, encoding: String.Encoding.utf8)
	}

	func createMainSwift() throws {
		Log.debug("create main.swift file")
		let sourcesDirectory = bootstrapDirectory.appendingPathComponent(Self.defaultSources)
		try sourcesDirectory.createDirectories()
		let mainFile = sourcesDirectory.appendingPathComponent("main.swift")
		let contents = mainSwift.joined(separator: "\n")
		try contents.write(to: mainFile, atomically: true, encoding: String.Encoding.utf8)
	}

	func build() async throws {
		Log.debug("build")
		try await commandRunner.run("/usr/bin/swift", "build", "--package-path", bootstrapDirectory.path, outputHandler: LogOutputHandler())
	}

	static func load(config: URL) throws -> (dependencies: [Dependency], main: [String]) {
		let contents = try String(contentsOf: config, encoding: .utf8)

		let parser = LineParser(contents)

		var dependencies = [Dependency]()
		var mainSwift = [String]()
		mainSwift.append("import ArgumentParser")
		mainSwift.append("import Foundation")

		while let line = parser.nextLine() {

			if line.hasPrefix(Dependency.importString) {
				if let dependency = Dependency(import: line) {
					dependencies.append(dependency)
					mainSwift.append("import \(dependency.name)")
				}
			} else if line.hasPrefix(Dependency.pluginString) {
				if let dependency = Dependency(plugin: line) {
					dependencies.append(dependency)
					mainSwift.append("import \(dependency.name)")
				}
			} else {
				mainSwift.append(line)
			}
		}

		let commandContents = """
				private func subcommands() -> [any AsyncParsableCommand.Type] {
					return []
				}

				@main struct BakeCLI: AsyncParsableCommand {
					static let configuration = CommandConfiguration(
						commandName: "bake",
						abstract: "A utility for bulding and running software projects",
						version: "2026.0.0",
						subcommands: subcommands()
					)
				}
			"""
		mainSwift.append(commandContents)

		return (dependencies, mainSwift)
	}

}

