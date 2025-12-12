import Bake
import Foundation

open class SimulatorControl: Target {

	public init(commandRunner: CommandRunner, outputHandler: OutputHandler = PrintOutputHandler()) {
		self.commandRunner = commandRunner
		self.outputHandler = outputHandler
	}

	public required init(from decoder: Decoder) throws {
		fatalError("not implemented")
	}

	public let name = "SimulatorControl"
	let commandRunner: CommandRunner
	let outputHandler: OutputHandler


	public func list() async throws {

		let result = try await commandRunner.runWithResult("/usr/bin/xcrun", "simctl", "list")

		outputHandler.process(line: "foo")
		outputHandler.process(line: "bar")

	}


}
