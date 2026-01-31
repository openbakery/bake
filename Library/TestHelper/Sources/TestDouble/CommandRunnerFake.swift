import Bake
import Foundation

open class CommandRunnerFake: CommandRunner {


	override open func run(
		_ command: String,
		arguments: [String],
		process: Process = ProcessFake(),
		outputHandler: OutputHandler = PrintOutputHandler(),
	) async throws {

		if hasCommand(command: command, arguments: arguments) != nil {
			return
		}
		self.command = command
		self.arguments = arguments
		self.runClosure?()
	}


	override open func runWithResult(
		_ command: String,
		arguments: [String],
		process: Process = Process()
	) async throws -> [String] {

		if let command = hasCommand(command: command, arguments: arguments) {
			return command.result
		}

		self.command = command
		self.arguments = arguments
		self.runClosure?()
		return []
	}

	open func expect(command: String, arguments: String..., result: [String] = []) {
		let command = Command(command: command, arguments: arguments, result: result)
		self.commands.append(command)
	}

	public var commands = [Command]()

	public struct Command: CustomStringConvertible {
		let command: String
		let arguments: [String]
		let result: [String]

		public var description: String {
			return "Command: \(command) \(arguments.joined(separator: " "))"
		}
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
	public var runClosure: (() -> Void)?
}
