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

	func load(filename: String = "simctl-list.txt") throws -> String? {
		let url = URL(fileURLWithPath: filename)
		guard let basename = url.basename else { return nil }
		guard let type = url.fileExtension else { return nil }
		guard let fullPath = Bundle.module.url(forResource: basename, withExtension: type) else { return nil }
		return try String(contentsOf: fullPath, encoding: .utf8)
	}

	@Test func load_file() throws {
		let contents = try load()

		// then
		assertThat(contents, presentAnd(hasPrefix("== Device Types ==")))
	}

	@Test func parse_devices_types() throws {
		let contents = try #require(try load())
		let parser = SimulatorControlParser()
		let simulators = parser.parse(contents)

		// then
		assertThat(simulators, present())
		assertThat(simulators?.deviceTypes, presentAnd(hasCount(117)))
		assertThat(simulators?.deviceTypes.first?.name, presentAnd(equalTo("iPhone 17 Pro")))
		assertThat(simulators?.deviceTypes.first?.identifier, presentAnd(equalTo("com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro")))

	}



}
