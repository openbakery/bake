import Bake
import BakeTestHelper
import Hamcrest
import Testing

@testable import BakeXcode

struct SimulatorControl_Test {

	init() async throws {
		commandRunner = CommandRunnerFake()

		outputHandler = StringOutputHandler()
		control = SimulatorControl(commandRunner: commandRunner, outputHandler: outputHandler)
	}

	let commandRunner: CommandRunnerFake
	let control: SimulatorControl
	let outputHandler: StringOutputHandler

	@Test
	func list() async throws {

		commandRunner.expect(command: "/usr/bin/xcrun", arguments: "simctl", "list", result: [])

		try await control.list()

		// then
		assertThat(commandRunner.expectationFulfilled, equalTo(true))
	}


	@Test
	func list_has_output() async throws {

		commandRunner.expect(command: "/usr/bin/xcrun", arguments: "simctl", "list", result: [])

		try await control.list()

		// then
		assertThat(outputHandler.lines, hasCount(greaterThan(1)))
	}
}
