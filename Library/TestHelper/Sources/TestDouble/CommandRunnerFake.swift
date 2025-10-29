import Bake
import Foundation

open class CommandRunnerFake: CommandRunner {


	override open func run(
		_ command: String,
		arguments: [String],
		environment: [String: String]? = nil,
		process: Process = ProcessFake(),
		outputHandler: OutputHandler = PrintOutputHandler()
	) async throws {
		self.command = command
		self.arguments = arguments
		self.environment = environment
	}


	override open func runWithResult(
		_ command: String,
		arguments: [String],
		environment: [String: String]? = nil,
		process: Process = Process()
	) async throws -> [String] {
		self.command = command
		self.arguments = arguments
		self.environment = environment
		if let result = results[command] {
			return result
		}
		return []
	}


	public var command: String?
	public var arguments: [String]?
	public var results = [String: [String]]()
	public var environment: [String: String]?
}
