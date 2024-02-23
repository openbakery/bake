

import XCTest
import SwiftHamcrest
@testable import Bake

class ProcessFake: Process {

	var wasExecuted = false
	var _arguments: [String]?
	var _executableURL: URL?

	override func run() throws {
		wasExecuted = true
	}

	override var launchPath: String? {
		set {
		}
		get {
			return nil
		}
	}

	override var arguments: [String]? {
		set {
			_arguments = newValue
		}
		get {
			_arguments
		}
	}

	override var executableURL: URL? {
		set {
			_executableURL = newValue
		}
		get {
			_executableURL
		}
	}

}

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

	func test_process_has_executable() throws {
		let command = createCommand(command: "foobar")

		// when
		try command.execute(process: process)

		// then
		assertThat(process.executableURL?.path, presentAnd(hasSuffix("foobar")))
	}


	func test_process_with_building_shell_command() throws {
		let bashCommands = ["alias", "bg", "bind", "break", "builtin", "caller", "case", "cd", "command", "compgen", "complete", "compopt", "continue", "coproc",
				"declare", "dirs", "disown", "echo", "enable", "eval", "exec", "exit", "export", "false", "fc", "fg", "getopts", "hash", "help", "history",
				"jobs", "kill", "local", "logout", "mapfile", "popd", "printf", "pushd", "pwd", "read", "readarray", "readonly", "return", "select", "set",
				"shift", "shopt", "source", "suspend", "test", "time", "times", "trap", "true", "type", "typeset", "ulimit", "umask", "unalias", "unset",
				"variables", "wait"]

		for bashCommand in bashCommands {
			let process = ProcessFake()
			let command = createCommand(command: bashCommand)

			// when
			try command.execute(process: process)

			// then
			assertThat(process.executableURL?.path, presentAnd(equalTo("/bin/bash")), message: "expected '\(bashCommand)' to be a bash command")
		}
	}


	func test_process_has_arguments() throws {
		let command = createCommand(command: "foobar", arguments: "first", "second")

		// when
		try command.execute(process: process)

		// then
		assertThat(process.arguments, presentAnd(hasCount(2)))
		assertThat(process.arguments?.first, presentAnd(equalTo("first")))
		assertThat(process.arguments?.last, presentAnd(equalTo("second")))
	}

	func test_process_has_arguments_for_bash_command() throws {
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
}


