//
// Created by René Pirringer on 6.1.2026
//

import Bake
import BakeTestHelper
import Foundation
import Hamcrest
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

}
