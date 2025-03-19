import Foundation

open class CommandRunner {

	public init() {
	}


	func run(_ command: String, _ arguments: String..., process: Process = Process()) throws {
		let command = Command(command: command, arguments: arguments)
		try command.execute(process: process)
	}

}
