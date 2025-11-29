//
// Created by René Pirringer on 28.11.2025
//

import Foundation
import Hamcrest
import Testing

@testable import Bake

struct Log_Test {

	@Test func level() {
		assertThat(Log.Level.debug.description, equalTo("Debug"))
		assertThat(Log.Level.error.description, equalTo("Error"))
		assertThat(Log.Level.info.description, equalTo("Info"))
		assertThat(Log.Level.warn.description, equalTo("Warn"))
	}

	@Test
	@MainActor
	func log_debug() {
		let stringOutputHandler = StringOutputHandler()

		Log.instance.set(outputHandler: stringOutputHandler)

		Log.debug("Test")

		// then
		assertThat(stringOutputHandler.lines.first, presentAnd(equalTo("Test")))
	}

	@Test
	@MainActor
	func log_debug_prints_debug() {
		let stringOutputHandler = StringOutputHandler()

		Log.instance.set(outputHandler: stringOutputHandler)
		Log.instance.showLevel = true

		Log.debug("Test")

		// then
		assertThat(stringOutputHandler.lines.first, presentAnd(equalTo("[DEBUG] - Test")))
	}

}
