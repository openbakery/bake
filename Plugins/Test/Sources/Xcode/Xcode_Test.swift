//
// Created by René Pirringer on 29.10.2025
//

import Bake
import BakeTestHelper
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import OBExtra
import Testing

@testable import BakePlugins

@Suite(.serialized)
final class Xcode_Test: Sendable {

	@Test
	func has_commandRunner() {
		let xcode = Xcode()

		// then
		assertThat(xcode.commandRunner, presentAnd(instanceOf(CommandRunner.self)))
	}


	@Test
	func init_with_version_searches_for_xcodes() async throws {
		let commandRunner = CommandRunnerFake()

		commandRunner.expect(command: "/usr/bin/mdfind", arguments: "kMDItemCFBundleIdentifier=com.apple.dt.Xcode", result: [])

		let xcode = try await Xcode(version: Version(major: 26), commandRunner: commandRunner)

		// then
		assertThat(xcode, present())
		assertThat(commandRunner.expectationFulfilled, equalTo(true))
	}

}
