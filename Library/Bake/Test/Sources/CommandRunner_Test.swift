import BakeTestHelper
import Foundation
import Hamcrest
import Testing

@testable import Bake

class CommandRunner_Test {

	init() async throws {
		process = ProcessFake()
		commandRunner = CommandRunner()
		HamcrestSwiftTesting.enable()
	}

	let process: ProcessFake
	let commandRunner: CommandRunner


	// func createCommand(name: String = "one", command: String = "two", arguments: String...) -> Command {
	// 	return Command(name: name, command: command, arguments: arguments)
	// }


	@Test func run_command() async throws {
		// when
		let workingDirectory = URL(fileURLWithPath: "/tmp")
		try await commandRunner.run("echo", "Hello World", workingDirectory: workingDirectory, process: process)

		// then
		#expect(process.wasExecuted)
		#expect(process.executableURL?.path == "/bin/bash")
		#expect(process.arguments?.count == 3)
		#expect(process.arguments?.first == "-c")
		#expect(process.arguments?[1] == "echo")
		#expect(process.arguments?.last == "Hello World")
		#expect(process.currentDirectoryURL == workingDirectory)
	}

	@Test func run_command_with_arguments_array() async throws {
		// when
		try await commandRunner.run("echo", arguments: ["Hello World"], process: process)

		// then
		#expect(process.wasExecuted)
		#expect(process.executableURL?.path == "/bin/bash")
		#expect(process.arguments?.count == 3)
		#expect(process.arguments?.first == "-c")
		#expect(process.arguments?[1] == "echo")
		#expect(process.arguments?.last == "Hello World")
	}


	@Test func run_command_with_enviroment() async throws {
		// when
		let process = ProcessFake()
		let commandRunner = CommandRunner()


		try await commandRunner.run("echo", arguments: ["Hello World"], environment: ["FOO": "bar"], process: process)

		// then
		assertThat(process.environment, presentAnd(hasEntry("FOO", "bar")))
	}

	@Test func default_has_no_environment() async throws {
		// when
		let process = ProcessFake()
		let commandRunner = CommandRunner()


		try await commandRunner.run("echo", arguments: ["Hello World"], process: process)

		// then
		assertThat(process.environment, nilValue())
	}

	@Test func executeWithResult() async throws {
		let result = try await commandRunner.runWithResult("/bin/echo", "Hello World")

		assertThat(result.first, presentAnd(equalTo("Hello World")))
	}
}
