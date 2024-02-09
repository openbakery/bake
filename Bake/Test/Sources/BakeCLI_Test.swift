
import XCTest
import SwiftHamcrest
import ArgumentParser
@testable import BakeCLI

class BakeCLI_Test: XCTestCase {

	var logger: LoggerFake!

	override func setUp() {
		super.setUp()
		logger = LoggerFake()
	}

	override func tearDown() {
		logger = nil
		super.tearDown()
	}


	func test_instance() {
		// when
		let bake = BakeCLI()

		// then
		assertThat(bake, present())
	}

	func test_has_logger() {
		// when
		let bake = BakeCLI()

		// then
		assertThat(bake.logger, present())
	}

	func test_print_usage_when_run_without_parameters() throws {
		// given
		var bake = BakeCLI(logger: logger)
		bake.command = ""

		// when
		try bake.run()

		// then
		assertThat(logger.messages.first, equalTo("Usage: bake [options] command"))
	}

	func test_is_parsableCommand() {
		// given
		let bake = BakeCLI(logger: logger)

		// the
		assertThat(bake, presentAnd(instanceOf(ParsableCommand.self)))
	}

	func test_has_build_command() throws {
		// given
		var bake = BakeCLI(logger: logger)
		bake.command = "build"

		// when
		try bake.run()

		// the
		assertThat(logger.messages.first, not(equalTo("Usage: bake [options] command")))
	}

	func test_execute_unknown_command_prints_usage() throws {
		// given
		var bake = BakeCLI(logger: logger)
		bake.command = "foobar"

		// when
		try bake.run()

		// the
		var iterator = logger.messages.makeIterator()
		assertThat(iterator.next(), equalTo("Command not found \"foobar\""))
		assertThat(iterator.next(), equalTo(""))
		assertThat(iterator.next(), equalTo("Usage: bake [options] command"))
	}

}
