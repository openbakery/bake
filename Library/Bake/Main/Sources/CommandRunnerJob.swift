//
// Created by René Pirringer on 6.2.2026
//


import Foundation

public struct CommandRunnerJob: Executable {

	public init(command: String, arguments: [String], commandRunner: CommandRunner) {
		self.command = command
		self.arguments = arguments
		self.commandRunner = commandRunner
	}

	let command: String
	let arguments: [String]
	let commandRunner: CommandRunner

	public func execute() async throws {
		try await commandRunner.run(command, arguments: arguments)
	}


}

extension Job where T == CommandRunnerJob {

	static func command(
		name: String,
		command: String,
		_ arguments: String...,
		commandRunner: CommandRunner = CommandRunner()
	) -> Job {
		let executable = CommandRunnerJob(command: command, arguments: arguments, commandRunner: commandRunner)

		return Job(name: name, executable: executable)

	}

}
