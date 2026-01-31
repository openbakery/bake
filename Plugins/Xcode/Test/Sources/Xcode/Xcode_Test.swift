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

@testable import BakeXcode

@Suite(.serialized)
final class Xcode_Test: Sendable {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}



	@Test
	func init_with_version_searches_for_xcodes() async throws {
		let commandRunner = CommandRunnerFake()

		commandRunner.expect(command: "/usr/bin/mdfind", arguments: "kMDItemCFBundleIdentifier=com.apple.dt.Xcode", result: [])

		_ = try await Xcode(version: Version(major: 26), commandRunner: commandRunner)

		// then
		assertThat(commandRunner.expectationFulfilled, equalTo(true))
	}


	@Test
	func init_checks_xcode_version() async throws {
		let commandRunner = CommandRunnerFake()

		commandRunner.expect(command: "/usr/bin/mdfind", arguments: "kMDItemCFBundleIdentifier=com.apple.dt.Xcode", result: ["/Applications/Xcode-26.app"])
		commandRunner.expect(command: "/Applications/Xcode-26.app/Contents/Developer/usr/bin/xcodebuild", arguments: "-version", result: ["Xcode 26.0", "Build version 17A324"])

		let xcode = try await Xcode(version: Version(major: 26), commandRunner: commandRunner)


		// then
		assertThat(xcode, present())
		assertThat(xcode?.xcodePath, presentAnd(equalTo("/Applications/Xcode-26.app")))
		assertThat(commandRunner.expectationFulfilled, equalTo(true))
	}

	@Test
	func init_finds_xcode_16() async throws {
		let commandRunner = CommandRunnerFake()

		commandRunner.expect(command: "/usr/bin/mdfind", arguments: "kMDItemCFBundleIdentifier=com.apple.dt.Xcode", result: ["/Applications/Xcode-26.app", "/Applications/Xcode-16.4.app"])
		commandRunner.expect(command: "/Applications/Xcode-26.app/Contents/Developer/usr/bin/xcodebuild", arguments: "-version", result: ["Xcode 26.0", "Build version 17A324"])
		commandRunner.expect(command: "/Applications/Xcode-16.4.app/Contents/Developer/usr/bin/xcodebuild", arguments: "-version", result: ["Xcode 16.4", "Build version 16F6"])


		let xcode = try await Xcode(version: Version(major: 16), commandRunner: commandRunner)


		// then
		assertThat(xcode, present())
		assertThat(xcode?.xcodePath, presentAnd(equalTo("/Applications/Xcode-16.4.app")))
		assertThat(commandRunner.expectationFulfilled, equalTo(true))
	}

	@Test
	func init_does_not_find_xcode_15() async throws {
		let commandRunner = CommandRunnerFake()

		commandRunner.expect(command: "/usr/bin/mdfind", arguments: "kMDItemCFBundleIdentifier=com.apple.dt.Xcode", result: ["/Applications/Xcode-26.app", "/Applications/Xcode-16.4.app"])
		commandRunner.expect(command: "/Applications/Xcode-26.app/Contents/Developer/usr/bin/xcodebuild", arguments: "-version", result: ["Xcode 26.0", "Build version 17A324"])
		commandRunner.expect(command: "/Applications/Xcode-16.4.app/Contents/Developer/usr/bin/xcodebuild", arguments: "-version", result: ["Xcode 16.4", "Build version 16F6"])


		let xcode = try await Xcode(version: Version(major: 15), commandRunner: commandRunner)


		// then
		assertThat(xcode, nilValue())
		assertThat(commandRunner.expectationFulfilled, equalTo(true))
	}

	@Test
	func xcode_has_environment() async throws {
		let commandRunner = CommandRunnerFake()

		commandRunner.expect(command: "/usr/bin/mdfind", arguments: "kMDItemCFBundleIdentifier=com.apple.dt.Xcode", result: ["/Applications/Xcode-26.app"])
		commandRunner.expect(command: "/Applications/Xcode-26.app/Contents/Developer/usr/bin/xcodebuild", arguments: "-version", result: ["Xcode 26.0", "Build version 17A324"])

		let xcode = try await Xcode(version: Version(major: 26), commandRunner: commandRunner)


		// then
		assertThat(xcode, present())
		assertThat(xcode?.environment, presentAnd(hasEntry("DEVELOPER_DIR", "/Applications/Xcode-26.app")))
	}


}
