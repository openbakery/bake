import Foundation

open class CommandRunner {

	public init(workingDirectory: URL? = nil, environment: [String: String]? = nil) {
		self.workingDirectory = workingDirectory
		self.environment = environment
	}

	public let workingDirectory: URL?
	public let environment: [String: String]?

	open func run(
		_ command: String,
		arguments: [String],
		process: Process = Process(),
		outputHandler: OutputHandler = PrintOutputHandler()
	) async throws {
		let command = Command(command: command, arguments: arguments, workingDirectory: workingDirectory)
		try await command.execute(process: process, environment: environment, outputHandler: outputHandler)
	}

	open func run(
		_ command: String,
		_ arguments: String...,
		process: Process = Process(),
		outputHandler: OutputHandler = PrintOutputHandler()
	) async throws {
		try await run(command, arguments: arguments, process: process)
	}

	open func runWithResult(
		_ command: String,
		_ arguments: String...,
		process: Process = Process()
	) async throws -> [String] {
		return try await runWithResult(command, arguments: arguments, process: process)
	}

	open func runWithResult(
		_ command: String,
		arguments: [String],
		process: Process = Process()
	) async throws -> [String] {
		let outputHandler = StringOutputHandler()
		try await run(command, arguments: arguments, process: process, outputHandler: outputHandler)
		return outputHandler.lines
	}

}
