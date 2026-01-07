//
//
//

import BakeTestHelper
import Foundation
import Hamcrest
import Testing

@testable import Bake

@MainActor
@Suite(.serialized)
class Command_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
		process = ProcessFake()
		outputHandler = StringOutputHandler()
	}

	let process: ProcessFake
	let outputHandler: StringOutputHandler


	func createCommand(name: String = "one", command: String = "two", arguments: String...) -> Command {
		return Command(name: name, command: command, arguments: arguments)
	}

	@Test func command_has_proper_name() {
		let command = createCommand(name: "one")

		// then
		assertThat(command.name, equalTo("one"))
	}

	@Test func command_name_is_command_when_name_was_not_specified() {
		let command = Command(command: "echo")

		// then
		assertThat(command.name, equalTo("echo"))
	}

	@Test func command_has_command() {
		let command = createCommand(command: "one")

		// then
		assertThat(command.command, equalTo("one"))
	}


	@Test func command_arguments_are_optional() {
		let command = Command(command: "pwd")

		// then
		assertThat(command.arguments.count, equalTo(0))
	}

	@Test func command_has_oneargumentsFake() {
		let command = createCommand(arguments: "one")

		// then
		assertThat(command.arguments.count, equalTo(1))
		assertThat(command.arguments.first, presentAnd(equalTo("one")))
	}

	@Test func command_has_multipleargumentsFake() {
		let command = createCommand(arguments: "one", "two", "three")

		// then
		assertThat(command.arguments.count, equalTo(3))
		assertThat(command.arguments.first, presentAnd(equalTo("one")))
		assertThat(command.arguments.last, presentAnd(equalTo("three")))
	}

	@Test func process_has_executable() async throws {
		let command = createCommand(command: "foobar")

		// when
		try await command.execute(process: process)

		// then
		assertThat(process.executableURL?.path, presentAnd(hasSuffix("foobar")))
	}


	@Test func process_with_building_shell_command() async throws {
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
			try await command.execute(process: process)

			// then
			assertThat(process.executableURL?.path, presentAnd(equalTo("/bin/bash")), message: "expected '\(bashCommand)' to be a bash command")
		}
	}

	@Test func process_hasargumentsFake() async throws {
		let command = createCommand(command: "foobar", arguments: "first", "second")

		// when
		try await command.execute(process: process)

		// then
		assertThat(process.arguments, presentAnd(hasCount(2)))
		assertThat(process.arguments?.first, presentAnd(equalTo("first")))
		assertThat(process.arguments?.last, presentAnd(equalTo("second")))
	}

	@Test func process_hasargumentsFake_for_bash_command() async throws {
		let command = createCommand(command: "echo", arguments: "Hello World")

		// when
		try await command.execute(process: process)

		// then
		let arguments = try #require(process.arguments)
		assertThat(arguments, presentAnd(hasCount(3)))
		if arguments.count != 3 {
			return
		}
		assertThat(arguments[0], presentAnd(equalTo("-c")))
		assertThat(arguments[1], presentAnd(equalTo("echo")))
		assertThat(arguments[2], presentAnd(equalTo("Hello World")))
	}


	@Test func command_has_output() async throws {
		let command = createCommand(command: "/bin/echo", arguments: "Hello World")

		// when
		try await command.execute(process: Process(), outputHandler: outputHandler)

		// then
		let lines = await outputHandler.waitForLines()

		assertThat(lines, hasCount(1))
		assertThat(lines.first, presentAnd(equalTo("Hello World")))
	}



	@Test func process_was_executed() async throws {
		let command = createCommand(command: "foobar")

		// when
		try await command.execute(process: process)

		// then
		assertThat(process.wasExecuted, equalTo(true))
	}

	@Test func has_proper_description() {
		let command = Command(name: "Foo", command: "bar", arguments: "first")

		// then
		assertThat(command, instanceOf(CustomStringConvertible.self))
		assertThat(command.description, presentAnd(equalTo("Command: \"Foo\"")))
	}


	@Test func has_environment_set() async throws {
		let process = ProcessFake()
		let command = Command(name: "Foo", command: "bar", arguments: "first")

		// when
		try await command.execute(process: process, environment: ["DEVELOPMENT_DIR": "/Application/Xcode.app/Contents/Developer"])

		// then
		assertThat(process.environment, presentAnd(hasCount(greaterThan(1))))
		assertThat(process.environment, presentAnd(hasEntry("DEVELOPMENT_DIR", "/Application/Xcode.app/Contents/Developer")))
	}

	@Test func load_simctl_json() async throws {
		let command = Command(name: "Foo", command: "/usr/bin/xcrun", arguments: "simctl", "list", "--json")
		let outputHandler = StringOutputHandler()

		// when
		try await command.execute(process: Process(), environment: ["DEVELOPMENT_DIR": "/Application/Xcode.app/Contents/Developer"], outputHandler: outputHandler)

		// then
		assertThat(outputHandler.lines, hasCount(greaterThan(10)))
		assertThat(outputHandler.lines.last, presentAnd(equalTo("}")))


	}

}
