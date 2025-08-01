import ArgumentParser
import Bake
import BakePlugins
import BakeTestHelper
import Hamcrest
import Testing

@testable import BakeCLI

@MainActor
class BakeCLI_Test {

	let output: TestOutputHandler
	var bake: BakeCLI

	init() async throws {
		output = TestOutputHandler()
		bake = BakeCLI(outputHandler: output)
	}



	@Test func print_usage_when_run_without_parameters() async throws {
		// given
		bake.target = ""

		// when
		try bake.run()

		// then
		let first = output.lines.first
		#expect(first == "Usage: bake target [options]")
	}


	@Test func has_build_target() async throws {
		// given
		bake.target = "build"

		// when
		try bake.run()

		// the
		let first = output.lines.first
		#expect(first != "Usage: bake [options] target")
	}

	@Test func execute_unknown_command_prints_usage() async throws {
		// given
		bake.target = "foobar"

		// when
		try bake.run()

		// the
		var iterator = output.lines.makeIterator()
		#expect(iterator.next() == "Target not found \"foobar\"")
		#expect(iterator.next() == "")
		#expect(iterator.next() == "Usage: bake target [options]")
	}

	@Test func execute_present_target() async throws {
		let target = Command(name: "foo", command: "")
		bake.targets.append(target)
		bake.target = "foo"

		// when
		try bake.run()

		// then
		var iterator = output.lines.makeIterator()
		#expect(iterator.next() == "Executing target \"foo\"")
	}

	@Test func when_multiple_targets_then_execute_target_with_proper_name() async throws {
		bake.targets.append(Command(name: "foo", command: ""))
		bake.targets.append(Command(name: "bar", command: ""))
		bake.target = "bar"

		// when
		try bake.run()

		// then
		var iterator = output.lines.makeIterator()
		#expect(iterator.next() == "Executing target \"bar\"")
	}

	@Test func has_simulatorControl_target() {
		#expect(bake.targets.targets.count == 1)
		#expect(bake.targets.targets.first is SimulatorControl)
	}

}
