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
		assertThat(outputHandler.lines.first, presentAnd(equalTo("Runtime(name: iOS 26.2, version: 26.2)")))
		assertThat(outputHandler.lines.count, greaterThan(5))
		guard outputHandler.lines.count > 5 else { return }
		assertThat(outputHandler.lines[1], presentAnd(equalTo("  Device(name: iPhone 17 Pro, identifier: 5883B74D-9B45-4B81-B4BA-FBA6427143CA)")))
	}


	@Test func get_device_by_name_and_version() async throws {
		try mockList()

		// when
		let device = try await control.device(name: "iPad Air", version: "18.6")

		// then
		assertThat(device, present())
		assertThat(device?.name, presentAnd(equalTo("iPad Air (5th generation)")))
	}

	@Test func get_tvOS_device() async throws {
		try mockList()

		// when
		let device = try await control.device(type: .tvOS)

		// then
		assertThat(device, present())
		assertThat(device?.name, presentAnd(equalTo("Apple TV 4K (3rd generation)")))
	}

	@Test func get_tvOS_device_by_name_and_version() async throws {
		try mockList()

		// when
		let device = try await control.device(name: "1080p", version: "26.0", type: .tvOS)

		// then
		assertThat(device, present())
		assertThat(device?.name, presentAnd(equalTo("Apple TV 4K (3rd generation) (at 1080p)")))
	}

	@Test func device_not_found() async throws {
		try mockList()

		// when
		let device = try await control.device(name: "2nd")

		// then
		assertThat(device, nilValue())
	}


	@Test func get_tvOS_destination_by_name_and_version() async throws {
		try mockList()

		// when
		let destination = try await control.destination(name: "1080p", version: "26.0", type: .tvOS)

		// then
		assertThat(destination, present())
		assertThat(destination?.value, presentAnd(equalTo("platform=tvOS Simulator,id=0F7EAF57-C5D9-4D8E-91C6-6EB0F6575EFC")))
	}

	@Test func createDevice() async throws {
		try mockList()

		// when
		let device = try #require(try await control.device(name: "iPhone 17 Pro"))
		try await control.create(device: device)

		// then
		assertThat(device, present())
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcrun")))
		assertThat(
			commandRunner.arguments,
			presentAnd(
				contains(
					"simctl",
					"create",
					"iPhone 17 Pro",
					"com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro",
					"com.apple.CoreSimulator.SimRuntime.iOS-26-2"
				)))
	}

}
