//
// Created by René Pirringer on 13.2.2026
//


import BakeTestHelper
import Foundation
import Hamcrest
import Testing

@testable import Bake

@MainActor
@Suite(.serialized)
struct ProjectCommandList_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}


	@Test func command_name() {
		// expect
		assertThat(ProjectCommandList.configuration.commandName, presentAnd(equalTo("list")))
	}


	@Test func list_command_calls_list() async throws {
		var command = try #require(try ProjectCommandList.parseAsRoot([]) as? ProjectCommandList)
		let outputHandler = StringOutputHandler()
		Log.instance.add(outputHandler: outputHandler)
		defer {
			Log.instance.remove(outputHandler: outputHandler)
		}

		// when
		try await command.run()

		// then
		let lines = await outputHandler.waitForLines()
		assertThat(lines.first, presentAnd(equalTo("Project Info:")))
	}


}
