//
// Created by René Pirringer on 2.1.2026
//


import Bake
import BakeTestHelper
import BakeXcode
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import Testing

@testable import BakeCLI

@MainActor
class Dependency_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}

	@Test func parse_import() throws {

		// when
		let dependency = Dependency(import: "@import(\"foo\", package: \"bar\")")

		// then
		assertThat(dependency, present())
		assertThat(dependency?.name, presentAnd(equalTo("foo")))
		assertThat(dependency?.package, presentAnd(equalTo("bar")))
	}

	@Test func parse_failure() throws {
		assertThat(Dependency(import: "import(\"foo\", package: \"bar\")"), nilValue())
		assertThat(Dependency(import: "@import(\"foo\""), nilValue())
		assertThat(Dependency(import: "@import(\"foo\",,,"), nilValue())
	}

	@Test(arguments: [
		"@import(\"foo\",   package:    \"bar\"    )",
		"   @import(    \"foo\",package:    \"bar\")    "
	]) func parse_success(line: String) throws {
		let dependency = Dependency(import: line)

		// then
		assertThat(dependency?.name, presentAnd(equalTo("foo")))
		assertThat(dependency?.package, presentAnd(equalTo("bar")))
		assertThat(dependency?.plugin, presentAnd(equalTo(false)))
	}


	@Test func parse_plugin() throws {

		// when
		let dependency = Dependency(plugin: "@plugin(\"foo\", package: \"bar\")")

		// then
		assertThat(dependency, present())
		assertThat(dependency?.name, presentAnd(equalTo("foo")))
		assertThat(dependency?.package, presentAnd(equalTo("bar")))
		assertThat(dependency?.plugin, presentAnd(equalTo(true)))
	}
}
