//
// Created by René Pirringer on 23.12.2025
//

import Bake
import BakeTestHelper
import BakeXcode
import Hamcrest
import HamcrestSwiftTesting
import Testing

@testable import BakeCLI

@MainActor
class Bootstrap_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}


	@Test func load_package_template() throws {
		let bootstrap = try Bootstrap()

		// then
		assertThat(bootstrap.packageString, hasPrefix("// swift-tools-version: 6.1"))
		assertThat(bootstrap.packageString, containsString(".executable(name: \"bake\", targets: [\"LocalBake\"])"))
	}

	@Test func add_dependencies() throws {
		var bootstrap = try Bootstrap()

		// when
		let dependency = Dependency(name: "BakeXcode", package: "bake")
		bootstrap.add(dependencies: [dependency])
		let packageString = bootstrap.build()

		// then
		assertThat(packageString, hasPrefix("// swift-tools-version: 6.1"))
		assertThat(packageString, containsString(".executable(name: \"bake\", targets: [\"LocalBake\"])"))
		assertThat(packageString, containsString(".product(name: \"BakeXcode\", package: \"bake\")"))
	}

	@Test func add_two_dependencies() throws {
		var bootstrap = try Bootstrap()

		// when
		let first = Dependency(name: "BakeXcode", package: "bake")
		let second = Dependency(name: "Foo", package: "bar")
		bootstrap.add(dependencies: [first, second])
		let packageString = bootstrap.build()

		// then
		assertThat(packageString, hasPrefix("// swift-tools-version: 6.1"))
		assertThat(packageString, containsString(".executable(name: \"bake\", targets: [\"LocalBake\"])"))
		assertThat(packageString, containsString("\n\t\t\t\t.product(name: \"BakeXcode\", package: \"bake\")"))
		assertThat(packageString, containsString("\n\t\t\t\t.product(name: \"Foo\", package: \"bar\")"))
	}

}
