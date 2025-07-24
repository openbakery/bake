import Foundation

open class CommandRunner {

	public init() {
	}

	open func run(_ command: String, arguments: [String], process: Process = Process()) async throws {
		let command = Command(command: command, arguments: arguments)
		try await command.execute(process: process)
	}

	open func run(_ command: String, _ arguments: String..., process: Process = Process()) async throws {
		try await run(command, arguments: arguments, process: process)
	}
}
