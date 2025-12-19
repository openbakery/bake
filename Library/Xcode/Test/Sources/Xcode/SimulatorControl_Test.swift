import Bake
import BakeTestHelper
import Foundation
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

		commandRunner.expect(command: "/usr/bin/xcrun", arguments: "simctl", "list", "--json", result: [])

		try await control.list()

		// then
		assertThat(commandRunner.expectationFulfilled, equalTo(true))
	}

	func mockList() throws {
		let contents = try #require(try Bundle.module.load(filename: "simctl.json"))
		commandRunner.expect(command: "/usr/bin/xcrun", arguments: "simctl", "list", "--json", result: [contents])
	}

	@Test
	func list_has_output() async throws {
		try mockList()

		try await control.list()

		// then
		assertThat(control.simulators, present())
	}


	@Test func get_device_by_name_and_version() async throws {
		try mockList()

		// when
		let device = try await control.device(name: "iPad Air", version: "18.6")

		// then
		assertThat(device, present())
		assertThat(device?.name, presentAnd(equalTo("iPad Air (5th generation)")))
	}

}
