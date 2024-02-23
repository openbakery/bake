
import Bake
import XCTest
import SwiftHamcrest
import ArgumentParser
@testable import BakeCLI

class BakeCLI_Test: XCTestCase {

	var logger: LoggerFake!
	var bake: BakeCLI!

	override func setUp() {
		super.setUp()
		bake = BakeCLI()
		logger = LoggerFake()
		bake.logger = logger
	}

	override func tearDown() {
		logger = nil
		bake = nil
		super.tearDown()
	}


	func test_instance() {
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
		bake.target = ""

		// when
		try bake.run()

		// then
		assertThat(logger.messages.first, equalTo("Usage: bake target [options]"))
	}

	func test_is_parsabletarget() {
		// the
		assertThat(bake, presentAnd(instanceOf(ParsableCommand.self)))
	}

	func test_has_build_target() throws {
		// given
		bake.target = "build"

		// when
		try bake.run()

		// the
		assertThat(logger.messages.first, not(equalTo("Usage: bake [options] target")))
	}

	func test_execute_unknown_command_prints_usage() throws {
		// given
		bake.target = "foobar"

		// when
		try bake.run()

		// the
		var iterator = logger.messages.makeIterator()
		assertThat(iterator.next(), equalTo("Target not found \"foobar\""))
		assertThat(iterator.next(), equalTo(""))
		assertThat(iterator.next(), equalTo("Usage: bake target [options]"))
	}

	func test_execute_present_target() throws {
		let target = Command(name: "foo")
		bake.targets.append(target)
		bake.target = "foo"

		// when
		try bake.run()

		// then
		var iterator = logger.messages.makeIterator()
		assertThat(iterator.next(), equalTo("Executing target \"foo\""))
	}

	func test_when_multiple_targets_then_execute_target_with_proper_name() throws {
		bake.targets.append(Command(name: "foo"))
		bake.targets.append(Command(name: "bar"))
		bake.target = "bar"

		// when
		try bake.run()

		// then
		var iterator = logger.messages.makeIterator()
		assertThat(iterator.next(), equalTo("Executing target \"bar\""))
	}

}
