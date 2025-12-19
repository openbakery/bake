//
// Created by René Pirringer on 12.12.2025
//


import Bake
import BakeTestHelper
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import OBExtra
import Testing

@testable import BakeXcode

@MainActor
struct SimulatorControlParser_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}

	func parseJson() throws -> Simulators? {
		let contents = try #require(try Bundle.module.load(filename: "simctl.json"))
		let parser = SimulatorControlParser()
		return parser.parseJson(contents)
	}


	@Test func load_json() throws {
		let contents = try Bundle.module.load(filename: "simctl.json")

		// then
		assertThat(contents, presentAnd(hasPrefix("{")))
	}


	@Test func parseJson_devices_types() throws {
		let simulators = try parseJson()

		// then
		assertThat(simulators?.deviceTypes.count, presentAnd(equalTo(121)))
		assertThat(simulators?.deviceTypes.first?.name, presentAnd(equalTo("iPhone 17 Pro")))
		assertThat(simulators?.deviceTypes.first?.identifier, presentAnd(equalTo("com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro")))
	}

	@Test func parseJson_runtimes() throws {
		let simulators = try parseJson()

		// then
		assertThat(simulators?.runtimes, presentAnd(hasCount(5)))
		assertThat(simulators?.runtimes.last?.name, presentAnd(equalTo("iOS 18.6")))
		assertThat(simulators?.runtimes.last?.identifier, presentAnd(equalTo("com.apple.CoreSimulator.SimRuntime.iOS-18-6")))
		assertThat(simulators?.runtimes.last?.version.major, presentAnd(equalTo(18)))
		assertThat(simulators?.runtimes.last?.version.minor, presentAnd(equalTo(6)))
		assertThat(simulators?.runtimes.last?.version.build, presentAnd(equalTo("22G86")))
	}


	@Test func parseJson_devices() throws {
		let simulators = try parseJson()

		assertThat(simulators?.devices, presentAnd(instanceOf(Devices.self)))

		let runtime = try #require(simulators?.runtimes.first)

		let devices = simulators?.devices(forRuntime: runtime)
		assertThat(devices, presentAnd(hasCount(11)))

	}

}
