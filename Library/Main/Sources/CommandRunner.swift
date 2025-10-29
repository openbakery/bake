import Foundation

open class CommandRunner {

	public init(environment: [String: String]? = nil) {
		self.environment = environment
	}

	let environment: [String: String]?

	open func run(_ command: String, arguments: [String], process: Process = Process(), outputHandler: OutputHandler = PrintOutputHandler()) async throws {
		let command = Command(command: command, arguments: arguments)
		try await command.execute(process: process, environment: environment, outputHandler: outputHandler)
	}

	open func run(_ command: String, _ arguments: String..., process: Process = Process()) async throws {
		try await run(command, arguments: arguments, process: process)
	}

	open func runWithResult(_ command: String, _ arguments: String..., process: Process = Process()) async throws -> [String] {
		return try await runWithResult(command, arguments: arguments, process: process)
	}

	open func runWithResult(_ command: String, arguments: [String], process: Process = Process()) async throws -> [String] {
		let outputHandler = StringOutputHandler()
		try await run(command, arguments: arguments, process: process, outputHandler: outputHandler)
		return outputHandler.lines
	}
}
