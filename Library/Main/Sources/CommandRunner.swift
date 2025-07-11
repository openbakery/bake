import Foundation

@MainActor
open class CommandRunner {

	public init() {
	}

	open func run(_ command: String, arguments: [String], process: Process = Process()) throws {
		let command = Command(command: command, arguments: arguments)
		try command.execute(process: process)
	}

	open func run(_ command: String, _ arguments: String..., process: Process = Process()) throws {
		try run(command, arguments: arguments, process: process)
	}
}
