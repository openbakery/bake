//
// Created by René Pirringer on 28.11.2025
//

import Foundation
import Hamcrest
import Testing

@testable import Bake

@MainActor
@Suite(.serialized)
struct Log_Test {
	init() async throws {
		HamcrestSwiftTesting.enable()
		stringOutputHandler = StringOutputHandler()
	}

	let stringOutputHandler: StringOutputHandler

	@Test func level() {
		assertThat(Log.Level.debug.description, equalTo("Debug"))
		assertThat(Log.Level.error.description, equalTo("Error"))
		assertThat(Log.Level.info.description, equalTo("Info"))
		assertThat(Log.Level.warn.description, equalTo("Warn"))
	}

	@Test
	func log_debug() async {
		let log = Log(outputHandler: stringOutputHandler, level: .debug)

		// when
		log.log(.debug, "Test")

		// then
		let lines = await stringOutputHandler.waitForLines()
		assertThat(lines.first, presentAnd(equalTo("Test")))
	}


	@Test
	func log_debug_prints_debug() async {
		let log = Log(outputHandler: stringOutputHandler, level: .debug)
		log.showLevel = true

		// when
		log.log(.debug, "Test")

		// then
		let lines = await stringOutputHandler.waitForLines()
		assertThat(lines.first, presentAnd(equalTo("[DEBUG] - Test")))
	}

	@Test
	func default_log_level_is_warn() {
		let log = Log()

		// then
		assertThat(log.level, equalTo(.info))
	}

	@Test
	func level_default_handler_is_PrintHandler() {
		let log = Log()

		// then
		assertThat(log.outputHandlers.first, presentAnd(instanceOf(PrintOutputHandler.self)))
	}

	@Test
	func level_off_does_not_log_anything() async {
		// when
		let log = Log(outputHandler: stringOutputHandler, level: .off)

		// when
		log.log(.debug, "Test")

		// then
		assertThat(stringOutputHandler.lines, hasCount(0))
	}

	@Test
	func level_error_only_prints_errors() async {
		// when
		let log = Log(outputHandler: stringOutputHandler, level: .error)

		// when
		log.log(.info, "Info")
		log.log(.warn, "Warn")
		log.log(.error, "Error")
		log.log(.debug, "Debug")

		// then
		let lines = await stringOutputHandler.waitForLines()
		assertThat(lines, hasCount(1))
		assertThat(lines.first, presentAnd(equalTo("Error")))
	}

	@Test
	func level_debug_only_prints_all_levels() async {
		// when
		let log = Log(outputHandler: stringOutputHandler, level: .debug)

		// when
		log.log(.info, "Info")
		log.log(.warn, "Warn")
		log.log(.error, "Error")
		log.log(.debug, "Debug")

		// then
		let lines = await stringOutputHandler.waitForLines()
		assertThat(lines, hasCount(4))
		assertThat(lines, hasItem("Error"))
		assertThat(lines, hasItem("Info"))
		assertThat(lines, hasItem("Debug"))
		assertThat(lines, hasItem("Warn"))
	}

}
