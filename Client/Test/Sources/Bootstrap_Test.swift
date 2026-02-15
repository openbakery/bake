//
// Created by René Pirringer on 23.12.2025
//

import ArgumentParser
import Bake
import BakeTestHelper
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import OBExtra
import Testing

@testable import BakeCLI

@Suite(.serialized)
class Bootstrap_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
		commandRunner = CommandRunnerFake()
	}


	let commandRunner: CommandRunnerFake

	func create() throws -> Bootstrap {
		let config = try #require(try Bundle.module.url(filename: "Bake.txt"))
		return try Bootstrap(config: config, commandRunner: commandRunner)
	}


	@Test func load_package_template() throws {
		// given
		let bootstrap = try create()

		// then
		assertThat(bootstrap.packageString, hasPrefix("// swift-tools-version: 6.1"))
		assertThat(bootstrap.packageString, containsString(".executable(name: \"bake\", targets: [\"LocalBake\"])"))
	}

	@Test func add_dependencies() async throws {
		let buildDirectory = URL.temporaryDirectory.appendingPathComponent("Bake")
		let dependency = Dependency(name: "BakeXcode", package: "bake")
		let bootstrap = try Bootstrap(dependencies: [dependency], buildDirectory: buildDirectory, commandRunner: commandRunner)
		defer {
			bootstrap.clean()
		}

		// when
		try await bootstrap.run()
		let packageFile = bootstrap.bootstrapDirectory.appendingPathComponent("Package.swift")
		let packageString = try String(contentsOf: packageFile, encoding: .utf8)

		// then
		assertThat(packageString, hasPrefix("// swift-tools-version: 6.1"))
		assertThat(packageString, containsString(".executable(name: \"bake\", targets: [\"LocalBake\"])"))
		assertThat(packageString, containsString(".product(name: \"BakeXcode\", package: \"bake\")"))
	}

	@Test
	@MainActor
	func add_two_dependencies() async throws {
		let buildDirectory = URL.temporaryDirectory.appendingPathComponent("Bake")
		let first = Dependency(name: "BakeXcode", package: "bake")
		let second = Dependency(name: "Foo", package: "bar")
		let bootstrap = try Bootstrap(dependencies: [first, second], buildDirectory: buildDirectory, commandRunner: commandRunner)
		defer {
			bootstrap.clean()
		}

		// when
		try bootstrap.prepare()
		let packageFile = bootstrap.bootstrapDirectory.appendingPathComponent("Package.swift")
		let packageString = try String(contentsOf: packageFile, encoding: .utf8)

		// then
		assertThat(packageString, hasPrefix("// swift-tools-version: 6.1"))
		assertThat(packageString, containsString(".executable(name: \"bake\", targets: [\"LocalBake\"])"))
		assertThat(packageString, containsString("\n\t\t\t\t.product(name: \"BakeXcode\", package: \"bake\")"))
		assertThat(packageString, containsString("\n\t\t\t\t.product(name: \"Foo\", package: \"bar\")"))
	}


	@Test func dependencies_from_Bake_swift() throws {
		// given
		let bootstrap = try create()

		// expect
		assertThat(bootstrap.dependencies, presentAnd(hasCount(2)))
		assertThat(bootstrap.dependencies.first?.name, presentAnd(equalTo("OBExtra")))
		assertThat(bootstrap.dependencies.first?.package, presentAnd(equalTo("openbakery")))
	}

	@Test func dependencies_from_Bake_swift_is_included() async throws {
		// given
		let bootstrap = try create()

		// given
		try await bootstrap.run()
		defer {
			bootstrap.clean()
		}

		// when
		let packageFile = bootstrap.bootstrapDirectory.appendingPathComponent("Package.swift")
		let packageString = try String(contentsOf: packageFile, encoding: .utf8)

		// then
		assertThat(packageString, hasPrefix("// swift-tools-version: 6.1"))
		assertThat(packageString, containsString(".executable(name: \"bake\", targets: [\"LocalBake\"])"))
		assertThat(packageString, containsString("\n\t\t\t\t.product(name: \"HelloWorld\", package: \"bake\")"))
	}


	@Test func import_is_removed_from_Bake_swift() throws {
		// given
		let bootstrap = try create()

		// when
		try bootstrap.createMainSwift()
		defer {
			bootstrap.clean()
		}
		let file = bootstrap.bootstrapDirectory.appendingPathComponent("Sources/main.swift")
		assertThat(file.fileExists(), equalTo(true))
		guard !file.fileExists() else { return }
		let contents = try String(contentsOf: file, encoding: .utf8)

		// then
		assertThat(contents, not(containsString("@import")))
		assertThat(contents, containsString("import OBExtra"))
		assertThat(contents, containsString("import BakeXcode"))
	}

	@Test func plugin_is_removed_from_Bake_swift() throws {
		// given
		let bootstrap = try create()

		// when
		try bootstrap.createMainSwift()
		defer {
			bootstrap.clean()
		}
		let file = bootstrap.bootstrapDirectory.appendingPathComponent("Sources/main.swift")
		assertThat(file.fileExists(), equalTo(true))
		guard !file.fileExists() else { return }
		let contents = try String(contentsOf: file, encoding: .utf8)

		// then
		assertThat(contents, not(containsString("@plugin")))
		assertThat(contents, containsString("import BakeXcode"))
	}

	@Test func has_default_bake_build_path() throws {
		// given
		let config = try #require(try Bundle.module.url(filename: "Bake.txt"))
		let bootstrap = try Bootstrap(config: config, commandRunner: commandRunner)

		// expect
		assertThat(bootstrap.buildDirectory, presentAnd(instanceOf(URL.self)))
		let rootPath = config.deletingLastPathComponent()
		assertThat(bootstrap.buildDirectory.path, presentAnd(hasPrefix(rootPath.path)))
		assertThat(bootstrap.buildDirectory.path, presentAnd(hasSuffix("build/bake")))
	}

	@Test func has_default_bake_bootstrap_path() throws {
		// given
		let config = try #require(try Bundle.module.url(filename: "Bake.txt"))
		let bootstrap = try Bootstrap(config: config, commandRunner: commandRunner)

		// then
		assertThat(bootstrap.bootstrapDirectory, presentAnd(instanceOf(URL.self)))
		let rootPath = config.deletingLastPathComponent()
		assertThat(bootstrap.buildDirectory.path, presentAnd(hasPrefix(rootPath.path)))
		assertThat(bootstrap.bootstrapDirectory.path, presentAnd(hasSuffix("build/bake/bootstrap")))
	}

	@Test
	@MainActor
	func bootstrap_run_creates_main_swift() throws {
		// given
		let bootstrap = try create()

		// when
		try bootstrap.prepare()
		defer {
			bootstrap.clean()
		}

		// then
		let main = bootstrap.bootstrapDirectory.appendingPathComponent("Sources/main.swift")
		assertThat(main.fileExists(), equalTo(true))
	}

	@Test func clean() async throws {
		// given
		let bootstrap = try create()

		// given
		try await bootstrap.run()
		assertThat(bootstrap.buildDirectory.fileExists(), equalTo(true))

		// when
		bootstrap.clean()

		// then
		assertThat(bootstrap.buildDirectory.fileExists(), equalTo(false))
	}


	@Test
	func run_compiles_bundle() async throws {
		// given
		let bootstrap = try create()

		// given
		commandRunner.expect(command: "/usr/bin/swift", arguments: "build", "--package-path", bootstrap.bootstrapDirectory.path)
		defer {
			bootstrap.clean()
		}

		try await bootstrap.run()

		// then
		assertThat(commandRunner.expectationFulfilled, equalTo(true))
	}


	@Test
	func copy_bake_to_build_bake() async throws {
		// given
		let bootstrap = try create()

		// given
		defer {
			bootstrap.clean()
		}
		let sourceDirectory = bootstrap.bootstrapDirectory.appendingPathComponent(".build/arm64-apple-macosx/debug/")
		try sourceDirectory.createDirectories()
		let source = sourceDirectory.appendingPathComponent("bake")
		try "dummy".write(to: source, atomically: true, encoding: String.Encoding.utf8)

		try await bootstrap.run()

		// then
		assertThat(commandRunner.expectationFulfilled, equalTo(true))

		let bake = bootstrap.bootstrapDirectory.appendingPathComponent("bake")
		assertThat(bake.fileExists(), equalTo(true), message: "File exists \(bake)")
	}

	@Test
	func copy_dylib_to_build_bake() async throws {
		// given
		let bootstrap = try create()

		// given
		defer {
			bootstrap.clean()
		}
		let sourceDirectory = bootstrap.bootstrapDirectory.appendingPathComponent(".build/arm64-apple-macosx/debug/")
		try sourceDirectory.createDirectories()
		let source = sourceDirectory.appendingPathComponent("libXcodeBake.dylib")
		try "dummy".write(to: source, atomically: true, encoding: String.Encoding.utf8)

		try await bootstrap.run()

		// then
		assertThat(commandRunner.expectationFulfilled, equalTo(true))

		let bake = bootstrap.bootstrapDirectory.appendingPathComponent("libXcodeBake.dylib")
		assertThat(bake.fileExists(), equalTo(true), message: "File exists \(bake)")
	}

	func mainContents(filename: String = "Bake.txt") throws -> String {
		// given
		let config = try #require(try Bundle.module.url(filename: filename))
		let bootstrap = try Bootstrap(config: config, commandRunner: commandRunner)

		// when
		try bootstrap.prepare()
		defer {
			bootstrap.clean()
		}

		// then
		let main = bootstrap.bootstrapDirectory.appendingPathComponent("Sources/main.swift")
		return try String(contentsOf: main, encoding: .utf8)
	}

	@Test
	@MainActor
	func main_contains_commands() throws {
		let contents = try mainContents()

		assertThat(contents, present())
		assertThat(contents, containsString("import ArgumentParser\n"))
		assertThat(contents, containsString("import Foundation\n"))

		let commandContents = """
				private func subcommands() -> [any AsyncParsableCommand.Type] {
					return HelloWorld.commands
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
		assertThat(contents, containsString(commandContents))
	}
	@Test
	@MainActor
	func main_contains_imports() throws {
		let contents = try mainContents()

		assertThat(contents, present())
		assertThat(contents, containsString("import Bake\n"))

	}


	@Test func contains_multiple_commands() async throws {
		// given
		let config = try #require(try Bundle.module.url(filename: "Bake2.txt"))
		let bootstrap = try Bootstrap(config: config, commandRunner: commandRunner)
		try bootstrap.prepare()
		defer {
			bootstrap.clean()
		}

		// when
		let main = bootstrap.bootstrapDirectory.appendingPathComponent("Sources/main.swift")
		let contents = try String(contentsOf: main, encoding: .utf8)

		assertThat(contents, present())
		assertThat(contents, containsString("import ArgumentParser\n"))
		assertThat(contents, containsString("import Foundation\n"))
		let commandContents = """
				private func subcommands() -> [any AsyncParsableCommand.Type] {
					return HelloWorld.commands + BakeXcode.commands
				}
			"""
		assertThat(contents, containsString(commandContents))
	}

	@Test
	@MainActor
	func add_project_command() throws {
		let main = """
			@MainActor
			let project = Project(
				name: "Bake-Example",
				jobs: [
					Job.command(name: "hello", command: "echo", "Hello World!")
				]
			)
			"""

		let result = try Bootstrap.parse(contents: main)
		let contents = result.main.joined(separator: "\n")

		// then
		assertThat(contents, containsString("let project = Project("))
		let commandContents = """
				private func subcommands() -> [any AsyncParsableCommand.Type] {
					return Project.commands
				}
			"""
		assertThat(contents, containsString(commandContents))
	}
}
