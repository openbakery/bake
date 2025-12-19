//
// Created by René Pirringer on 15.12.2025
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
struct Simulators_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}


	func parseJson() throws -> Simulators? {
		let contents = try #require(try Bundle.module.load(filename: "simctl.json"))
		let parser = SimulatorControlParser()
		return parser.parseJson(contents)
	}

	@Test func find_runtime_by_type_returns_newest() throws {
		let simulators = try parseJson()

		// when
		let runtime = simulators?.runtime(type: SDKType.iOS)

		// then
		assertThat(runtime?.name, presentAnd(equalTo("iOS 26.2")))
		assertThat(runtime?.version.build, presentAnd(equalTo("23C52")))
	}

	@Test func find_runtime_by_version() throws {
		let simulators = try parseJson()

		// when
		let runtime = simulators?.runtime(type: SDKType.iOS, version: Version(major: 18, minor: 6))

		// then
		assertThat(runtime?.name, presentAnd(equalTo("iOS 18.6")))
	}

	@Test func get_runtime_gets_newest_iOS_runtime() throws {
		let simulators = try parseJson()

		// when
		let runtime = simulators?.runtime()

		// then
		assertThat(runtime?.name, presentAnd(equalTo("iOS 26.2")))
		assertThat(runtime?.type, presentAnd(equalTo(.iOS)))
	}

	@Test func find_device() throws {
		let simulators = try parseJson()

		// when
		let device = try #require(simulators?.device())

		// then
		assertThat(device.name, presentAnd(equalTo("iPhone 17 Pro")))
		let runtime = simulators?.runtime(device: device)
		assertThat(runtime?.name, presentAnd(equalTo("iOS 26.2")))
		assertThat(runtime?.type, presentAnd(equalTo(.iOS)))
	}

	@Test func find_device_by_name() throws {
		let simulators = try parseJson()

		// when
		let device = try #require(simulators?.device("iPad Pro"))

		// then
		assertThat(device.name, presentAnd(equalTo("iPad Pro 13-inch (M5)")))
		let runtime = simulators?.runtime(device: device)
		assertThat(runtime?.name, presentAnd(equalTo("iOS 26.2")))
		assertThat(runtime?.type, presentAnd(equalTo(.iOS)))
	}


	@Test func find_device_by_name_2() throws {
		let simulators = try parseJson()

		// when
		let device = try #require(simulators?.device("iPad Pro 11-inch"))

		// then
		assertThat(device.name, presentAnd(equalTo("iPad Pro 11-inch (M5)")))
	}
}
