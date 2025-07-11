import ArgumentParser
import Bake
import BakePlugins
import Hamcrest
import Testing

@testable import BakeCLI

@MainActor
class BakeCLI_Test {

	let logger: LoggerFake
	var bake: BakeCLI

	init() async throws {
		logger = LoggerFake()
		bake = BakeCLI(logger: logger)
	}



	@Test func print_usage_when_run_without_parameters() throws {
		// given
		bake.target = ""

		// when
		try bake.run()

		// then
		#expect(logger.messages.first == "Usage: bake target [options]")
	}


	@Test func has_build_target() throws {
		// given
		bake.target = "build"

		// when
		try bake.run()

		// the
		#expect(logger.messages.first != "Usage: bake [options] target")
	}

	@Test func execute_unknown_command_prints_usage() throws {
		// given
		bake.target = "foobar"

		// when
		try bake.run()

		// the
		var iterator = logger.messages.makeIterator()
		#expect(iterator.next() == "Target not found \"foobar\"")
		#expect(iterator.next() == "")
		#expect(iterator.next() == "Usage: bake target [options]")
	}

	@Test func execute_present_target() throws {
		let target = Command(name: "foo", command: "")
		bake.targets.append(target)
		bake.target = "foo"

		// when
		try bake.run()

		// then
		var iterator = logger.messages.makeIterator()
		#expect(iterator.next() == "Executing target \"foo\"")
	}

	@Test func when_multiple_targets_then_execute_target_with_proper_name() throws {
		bake.targets.append(Command(name: "foo", command: ""))
		bake.targets.append(Command(name: "bar", command: ""))
		bake.target = "bar"

		// when
		try bake.run()

		// then
		var iterator = logger.messages.makeIterator()
		#expect(iterator.next() == "Executing target \"bar\"")
	}

	@Test func has_simulatorControl_target() {
		#expect(bake.targets.targets.count == 1)
		#expect(bake.targets.targets.first is SimulatorControl)
	}

}
