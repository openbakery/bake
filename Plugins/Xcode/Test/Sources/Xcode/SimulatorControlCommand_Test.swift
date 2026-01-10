//
// Created by René Pirringer on 6.1.2026
//

import Bake
import BakeTestHelper
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import Testing

@testable import BakeXcode

struct SimulatorControlCommand_Test {

	@Test func commandConfiguration() {
		assertThat(SimulatorControlCommand.configuration.commandName, presentAnd(equalTo("simulatorControl")))
		assertThat(SimulatorControlCommand.configuration.aliases, presentAnd(hasItem("simctl")))
	}

	@Test func has_list_command() {
		assertThat(SimulatorControlCommand.configuration.subcommands, hasItem(instanceOf(SimulatorControlCommandList.Type.self)))
	}

	@Test func list_command_calls_list() async throws {
		let control = SimulatorControlSpy()
		var command = try #require(try SimulatorControlCommandList.parseAsRoot([]) as? SimulatorControlCommandList)
		command.control = control

		// when
		try await command.run()

		// then
		assertThat(control.listCalled, equalTo(true))
	}

	@Test func list_command_configuration() {
		assertThat(SimulatorControlCommandList.configuration.commandName, presentAnd(equalTo("list")))
	}

	@Test func has_deviceId_command() {
		assertThat(SimulatorControlCommand.configuration.subcommands, hasItem(instanceOf(SimulatorControlCommandDeviceId.Type.self)))
	}

	@Test func deviceId_calls_device() async throws {
		let control = SimulatorControlSpy()
		// var command = try #require(try SimulatorControlCommandDeviceId.parseAsRoot(["iPhone"]) as? SimulatorControlCommandDeviceId)
		var command = try SimulatorControlCommandDeviceId.create(["iPhone"])
		command.control = control

		// when
		try await command.run()

		// then
		assertThat(control.deviceName, equalTo("iPhone"))
	}
}
