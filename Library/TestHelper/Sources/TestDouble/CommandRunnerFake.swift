import Bake
import Foundation

open class CommandRunnerFake: CommandRunner {


	override open func run(
		_ command: String,
		arguments: [String],
		workingDirectory: URL? = nil,
		environment: [String: String]? = nil,
		process: Process = ProcessFake(),
		outputHandler: OutputHandler = PrintOutputHandler()
	) async throws {

		if hasCommand(command: command, arguments: arguments) != nil {
			return
		}
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

		if let command = hasCommand(command: command, arguments: arguments) {
			return command.result
		}

		self.command = command
		self.arguments = arguments
		self.environment = environment
		return []
	}

	open func expect(command: String, arguments: String..., result: [String] = []) {
		let command = Command(command: command, arguments: arguments, result: result)
		self.commands.append(command)
	}

	var commands = [Command]()

	struct Command {
		let command: String
		let arguments: [String]
		let result: [String]
	}

	func hasCommand(command: String, arguments: [String]) -> Command? {

		for (index, item) in commands.enumerated() {
			if item.command == command && item.arguments == arguments {
				self.commands.remove(at: index)
				return item
			}
		}
		return nil
	}

	public var expectationFulfilled: Bool {
		self.commands.count == 0
	}

	public var command: String?
	public var arguments: [String]?
	public var environment: [String: String]?
}
