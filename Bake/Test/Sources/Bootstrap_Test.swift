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

@MainActor
class Bootstrap_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
		config = try #require(try Bundle.module.url(filename: "Bake.txt"))
		bootstrap = try Bootstrap(config: config)
	}

	let config: URL
	let bootstrap: Bootstrap


	@Test func load_package_template() throws {
		// then
		assertThat(bootstrap.packageString, hasPrefix("// swift-tools-version: 6.1"))
		assertThat(bootstrap.packageString, containsString(".executable(name: \"bake\", targets: [\"LocalBake\"])"))
	}

	@Test func add_dependencies() throws {
		let dependency = Dependency(name: "BakeXcode", package: "bake")
		let bootstrap = try Bootstrap(dependencies: [dependency])

		// when
		let packageFile = bootstrap.bootstrapDirectory.appendingPathComponent("Package.swift")
		let packageString = try String(contentsOf: packageFile, encoding: .utf8)

		// then
		assertThat(packageString, hasPrefix("// swift-tools-version: 6.1"))
		assertThat(packageString, containsString(".executable(name: \"bake\", targets: [\"LocalBake\"])"))
		assertThat(packageString, containsString(".product(name: \"BakeXcode\", package: \"bake\")"))
	}

	@Test func add_two_dependencies() throws {
		let first = Dependency(name: "BakeXcode", package: "bake")
		let second = Dependency(name: "Foo", package: "bar")
		let bootstrap = try Bootstrap(dependencies: [first, second])

		// when
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

	@Test func dependencies_from_Bake_swift_is_included() throws {
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
		let file = bootstrap.bootstrapDirectory.appendingPathComponent("Source/main.swift")
		let contents = try String(contentsOf: file, encoding: .utf8)

		// then
		assertThat(contents, not(containsString("@import")))
		assertThat(contents, containsString("import BakeXcode"))
	}

	@Test func has_default_bake_build_path() throws {
		// expect
		assertThat(bootstrap.buildDirectory, presentAnd(instanceOf(URL.self)))
		assertThat(bootstrap.buildDirectory.path, presentAnd(hasPrefix(config.path)))
		assertThat(bootstrap.buildDirectory.path, presentAnd(hasSuffix("build/bake")))
	}

	@Test func has_default_bake_bootstrap_path() throws {
		// then
		assertThat(bootstrap.bootstrapDirectory, presentAnd(instanceOf(URL.self)))
		assertThat(bootstrap.bootstrapDirectory.path, presentAnd(hasPrefix(config.path)))
		assertThat(bootstrap.bootstrapDirectory.path, presentAnd(hasSuffix("build/bake/bootstrap")))
	}

	@Test func bootstrap_run_creates_main_swift() throws {
		// when
		try bootstrap.run()

		// then
		let main = bootstrap.bootstrapDirectory.appendingPathComponent("Sources/main.swift")
		assertThat(main.fileExists(), equalTo(true))
	}

}
