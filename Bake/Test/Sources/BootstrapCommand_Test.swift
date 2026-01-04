//
// Created by René Pirringer on 3.1.2026
//

import Bake
import BakeTestHelper
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import OBExtra
import Testing

@testable import BakeCLI

@MainActor

struct BootstrapCommand_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}

	@Test func command_name() {
		// expect
		assertThat(BootstrapCommand.configuration.commandName, presentAnd(equalTo("bootstrap")))
	}
}
