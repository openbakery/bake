//
// Created by René Pirringer on 10.1.2026
//

import Hamcrest
import HamcrestSwiftTesting
import Testing

@testable import BakeXcode

struct Destination_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}

	@Test func generic_destination() {
		assertThat(Destination.iOSGeneric.type.value(), presentAnd(equalTo("iOS")))
		assertThat(Destination.iOSGeneric.value, equalTo("generic/platform=iOS"))
		assertThat(Destination(type: .iOS).value, equalTo("generic/platform=iOS"))
		assertThat(Destination(type: .iOS, identifier: "234-234").value, equalTo("platform=iOS,id=234-234"))
		assertThat(Destination(type: .iOS, identifier: "234-234", architecture: .arm64).value, equalTo("platform=iOS,id=234-234,arch=arm64"))
	}

	@Test func destination_from_device() throws {
		let simulators = try #require(Simulators.create())
		let device = try #require(simulators.device())
		assertThat(device.name, equalTo("iPhone 17 Pro"))

		// when
		let destination = simulators.destination(device: device)

		// then
		assertThat(destination?.value, presentAnd(equalTo("platform=iOS Simulator,id=\(device.identifier)")))
	}

	@Test func iOS_simualtor() throws {
		let simulators = try #require(Simulators.create())
		let device = try #require(simulators.device())
		assertThat(device.name, equalTo("iPhone 17 Pro"))

		// when
		let destination = simulators.destination(device: device)

		// then
		assertThat(destination?.value, presentAnd(equalTo("platform=iOS Simulator,id=\(device.identifier)")))
	}
}
