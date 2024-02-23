

import XCTest
import SwiftHamcrest
@testable import Bake

class Command_Test: XCTestCase {

	func createCommand(name: String = "one", command: String = "two", arguments: String...) -> Command {
		return Command(name: name, command: command, arguments: arguments)
	}

	func test_command_has_proper_name() {
		let command = createCommand(name: "one")

		// then
		assertThat(command.name, equalTo("one"))
	}

	func test_command_has_command() {
		let command = createCommand(command: "one")

		// then
		assertThat(command.command, equalTo("one"))
	}


	func test_command_has_one_arguments() {
		let command = createCommand(arguments: "one")

		// then
		assertThat(command.arguments.count, equalTo(1))
		assertThat(command.arguments.first, presentAnd(equalTo("one")))
	}

	func test_command_has_multiple_arguments() {
		let command = createCommand(arguments: "one", "two", "three")

		// then
		assertThat(command.arguments.count, equalTo(3))
		assertThat(command.arguments.first, presentAnd(equalTo("one")))
		assertThat(command.arguments.last, presentAnd(equalTo("three")))
	}
}
