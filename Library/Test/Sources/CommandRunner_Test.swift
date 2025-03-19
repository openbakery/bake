import Testing

@testable import Bake

class CommandRunner_Test {

	init() async throws {
		process = ProcessFake()
		commandRunner = CommandRunner()
	}

	let process: ProcessFake
	let commandRunner: CommandRunner


	// func createCommand(name: String = "one", command: String = "two", arguments: String...) -> Command {
	// 	return Command(name: name, command: command, arguments: arguments)
	// }


	@Test func run_command() throws {
		// when
		try commandRunner.run("echo", "Hello World", process: process)

		// then
		#expect(process.wasExecuted)
		#expect(process.executableURL?.path == "/bin/bash")
		#expect(process.arguments?.count == 3)
		#expect(process.arguments?.first == "-c")
		#expect(process.arguments?[1] == "echo")
		#expect(process.arguments?.last == "Hello World")
	}

}
