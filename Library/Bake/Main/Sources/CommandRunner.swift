import Foundation

open class CommandRunner {

	public init() {
	}

	open func run(
		_ command: String,
		arguments: [String],
		workingDirectory: URL? = nil,
		environment: [String: String]? = nil,
		process: Process = Process(),
		outputHandler: OutputHandler = PrintOutputHandler()
	) async throws {
		let command = Command(command: command, arguments: arguments, workingDirectory: workingDirectory)
		try await command.execute(process: process, environment: environment, outputHandler: outputHandler)
	}

	open func run(
		_ command: String,
		_ arguments: String...,
		workingDirectory: URL? = nil,
		environment: [String: String]? = nil,
		process: Process = Process(),
		outputHandler: OutputHandler = PrintOutputHandler()
	) async throws {
		try await run(command, arguments: arguments, workingDirectory: workingDirectory, environment: environment, process: process)
	}

	open func runWithResult(
		_ command: String,
		_ arguments: String...,
		environment: [String: String]? = nil,
		process: Process = Process()
	) async throws -> [String] {
		return try await runWithResult(command, arguments: arguments, environment: environment, process: process)
	}

	open func runWithResult(
		_ command: String,
		arguments: [String],
		environment: [String: String]? = nil,
		process: Process = Process()
	) async throws -> [String] {
		let outputHandler = StringOutputHandler()
		try await run(command, arguments: arguments, environment: environment, process: process, outputHandler: outputHandler)
		return outputHandler.lines
	}

}
