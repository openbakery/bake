//
// Created by René Pirringer on 23.12.2025
//

import Bake
import BakeTestHelper
import BakeXcode
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import OBExtra
import Testing

@testable import BakeCLI

class Bootstrap_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
		config = try #require(try Bundle.module.url(filename: "Bake.txt"))
		commandRunner = CommandRunnerFake()
		bootstrap = try Bootstrap(config: config, commandRunner: commandRunner)
	}


	let config: URL
	let bootstrap: Bootstrap
	let commandRunner: CommandRunnerFake


	@Test func load_package_template() throws {
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
		// expect
		assertThat(bootstrap.dependencies, presentAnd(hasCount(1)))
		assertThat(bootstrap.dependencies.first?.name, presentAnd(equalTo("BakeXcode")))
		assertThat(bootstrap.dependencies.first?.package, presentAnd(equalTo("bake")))
	}

	@Test func dependencies_from_Bake_swift_is_included() async throws {
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
		assertThat(packageString, containsString("\n\t\t\t\t.product(name: \"BakeXcode\", package: \"bake\")"))
	}


	@Test func import_is_removed_from_Bake_swift() throws {
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
		assertThat(contents, containsString("import BakeXcode"))
	}

	@Test func has_default_bake_build_path() throws {
		// expect
		assertThat(bootstrap.buildDirectory, presentAnd(instanceOf(URL.self)))
		let rootPath = config.deletingLastPathComponent()
		assertThat(bootstrap.buildDirectory.path, presentAnd(hasPrefix(rootPath.path)))
		assertThat(bootstrap.buildDirectory.path, presentAnd(hasSuffix("build/bake")))
	}

	@Test func has_default_bake_bootstrap_path() throws {
		// then
		assertThat(bootstrap.bootstrapDirectory, presentAnd(instanceOf(URL.self)))
		let rootPath = config.deletingLastPathComponent()
		assertThat(bootstrap.buildDirectory.path, presentAnd(hasPrefix(rootPath.path)))
		assertThat(bootstrap.bootstrapDirectory.path, presentAnd(hasSuffix("build/bake/bootstrap")))
	}

	@Test
	@MainActor
	func bootstrap_run_creates_main_swift() throws {
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
		try await bootstrap.run()
		assertThat(bootstrap.buildDirectory.fileExists(), equalTo(true))

		// when
		bootstrap.clean()

		// then
		assertThat(bootstrap.buildDirectory.fileExists(), equalTo(false))
	}

	@Test func run_compiles_bundle() async throws {
		// given
		commandRunner.expect(command: "/usr/bin/swift", arguments: "build", "--package-path", bootstrap.bootstrapDirectory.path)
		defer {
			bootstrap.clean()
		}
		try await confirmation("executed") { done in
			commandRunner.runClosure = {
				done()
			}
			try await bootstrap.run()
		}

		// then
		assertThat(commandRunner.expectationFulfilled, equalTo(true))
	}

}
