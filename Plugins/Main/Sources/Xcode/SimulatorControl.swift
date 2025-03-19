import Bake
import Foundation

open class SimulatorControl: Target {

	public init(commandRunner: CommandRunner) {
		self.commandRunner = commandRunner
	}

	public required init(from decoder: Decoder) throws {
		fatalError("not implemented")
	}

	public let name = "SimulatorControl"
	let commandRunner: CommandRunner


}
