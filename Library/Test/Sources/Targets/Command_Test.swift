//
//
//

import Hamcrest
import XCTest

@testable import Bake

class Command_Test: XCTestCase {

	var process: ProcessFake!

	override func setUp() {
		super.setUp()
		process = ProcessFake()
	}

	override func tearDown() {
		process = nil
		super.tearDown()
	}


	func createCommand(name: String = "one", command: String = "two", arguments: String...) -> Command {
		return Command(name: name, command: command, arguments: arguments)
	}

	func test_command_has_proper_name() {
		let command = createCommand(name: "one")

		// then
		assertThat(command.name, equalTo("one"))
	}

	func test_command_name_is_command_when_name_was_not_specified() {
		let command = Command(command: "echo")

		// then
		assertThat(command.name, equalTo("echo"))
	}

	func test_command_has_command() {
		let command = createCommand(command: "one")

		// then
		assertThat(command.command, equalTo("one"))
	}


	func test_command_arguments_are_optional() {
		let command = Command(command: "pwd")

		// then
		assertThat(command.arguments.count, equalTo(0))
	}

	func test_command_has_oneargumentsFake() {
		let command = createCommand(arguments: "one")

		// then
		assertThat(command.arguments.count, equalTo(1))
		assertThat(command.arguments.first, presentAnd(equalTo("one")))
	}

	func test_command_has_multipleargumentsFake() {
		let command = createCommand(arguments: "one", "two", "three")

		// then
		assertThat(command.arguments.count, equalTo(3))
		assertThat(command.arguments.first, presentAnd(equalTo("one")))
		assertThat(command.arguments.last, presentAnd(equalTo("three")))
	}

	func test_process_has_executable() throws {
		let command = createCommand(command: "foobar")

		// when
		try command.execute(process: process)

		// then
		assertThat(process.executableURL?.path, presentAnd(hasSuffix("foobar")))
	}


	func test_process_with_building_shell_command() throws {
		let bashCommands = [
			"alias", "bg", "bind", "break", "builtin", "caller", "case", "cd", "command", "compgen", "complete", "compopt", "continue", "coproc",
			"declare", "dirs", "disown", "enable", "eval", "exec", "exit", "export", "false", "fc", "fg", "getopts", "hash", "help", "history",
			"jobs", "kill", "local", "logout", "mapfile", "popd", "printf", "pushd", "pwd", "read", "readarray", "readonly", "return", "select", "set",
			"shift", "shopt", "source", "suspend", "test", "time", "times", "trap", "true", "type", "typeset", "ulimit", "umask", "unalias", "unset",
			"variables", "wait", "which"
		]

		for bashCommand in bashCommands {
			let process = ProcessFake()
			let command = createCommand(command: bashCommand)

			// when
			try command.execute(process: process)

			// then
			assertThat(process.executableURL?.path, presentAnd(equalTo("/bin/bash")), message: "expected '\(bashCommand)' to be a bash command")
		}
	}

	func test_process_hasargumentsFake() throws {
		let command = createCommand(command: "foobar", arguments: "first", "second")

		// when
		try command.execute(process: process)

		// then
		assertThat(process.arguments, presentAnd(hasCount(2)))
		assertThat(process.arguments?.first, presentAnd(equalTo("first")))
		assertThat(process.arguments?.last, presentAnd(equalTo("second")))
	}

	func test_process_hasargumentsFake_for_bash_command() throws {
		let command = createCommand(command: "echo", arguments: "Hello World")

		// when
		try command.execute(process: process)

		// then
		let arguments = try unwrap(process.arguments)
		assertThat(arguments, presentAnd(hasCount(3)))
		if arguments.count != 3 {
			return
		}
		assertThat(arguments[0], presentAnd(equalTo("-c")))
		assertThat(arguments[1], presentAnd(equalTo("echo")))
		assertThat(arguments[2], presentAnd(equalTo("Hello World")))
	}



	func test_process_was_executed() throws {
		let command = createCommand(command: "foobar")

		// when
		try command.execute(process: process)

		// then
		assertThat(process.wasExecuted, equalTo(true))
	}

	func test_process_as_standardOutput_pipe() throws {
		// given
		let process = Process()
		let command = createCommand(command: "/bin/echo", arguments: "Hello World")

		// when
		try command.execute(process: process)
		process.waitUntilExit()

		// then
		assertThat(process.standardOutput, present())
		assertThat(process.standardError, present())

		let data = command.standardOutput.fileHandleForReading.availableData
		assertThat(data, present())
		assertThat(data.utf8String, presentAnd(equalTo("Hello World\n")))
	}

	func test_has_proper_description() {
		let command = Command(name: "Foo", command: "bar", arguments: "first")

		// then
		assertThat(command, instanceOf(CustomStringConvertible.self))
		assertThat(command.description, presentAnd(equalTo("Command: \"Foo\"")))
	}


}
