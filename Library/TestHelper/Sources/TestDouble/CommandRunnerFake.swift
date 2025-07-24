import Bake
import Foundation

open class CommandRunnerFake: CommandRunner {

	override open func run(_ command: String, arguments: [String], process: Process = ProcessFake()) async throws {
		self.command = command
		self.arguments = arguments
	}

	override open func run(_ command: String, _ arguments: String..., process: Process = ProcessFake()) async throws {
		self.command = command
		self.arguments = arguments
	}


	public var command: String?
	public var arguments: [String]?
}
