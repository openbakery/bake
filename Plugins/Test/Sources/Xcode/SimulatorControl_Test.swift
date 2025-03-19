import Bake
import Testing

@testable import BakePlugins

struct SimulatorControl_Test {

	let control: SimulatorControl
	let commandRunner: CommandRunner

	init() async throws {
		commandRunner = CommandRunner()
		control = SimulatorControl(commandRunner: commandRunner)
	}

}
