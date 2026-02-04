//
// Created by René Pirringer on 10.1.2026
//

import Hamcrest
import HamcrestSwiftTesting
import Testing

@testable import BakeXcode

struct SDKType_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}

	@Test func value() {
		assertThat(SDKType.iOS.value(), equalTo("iOS"))
		assertThat(SDKType.macOS.value(), equalTo("macOS"))
		assertThat(SDKType.tvOS.value(), equalTo("tvOS"))
		assertThat(SDKType.watchOS.value(), equalTo("watchOS"))
		assertThat(SDKType.visionOS.value(), equalTo("visionOS"))

		assertThat(SDKType.iOS.value(simulator: true), equalTo("iOS Simulator"))
		assertThat(SDKType.macOS.value(simulator: true), equalTo("macOS"))
		assertThat(SDKType.tvOS.value(simulator: true), equalTo("tvOS Simulator"))
		assertThat(SDKType.watchOS.value(simulator: true), equalTo("watchOS Simulator"))
		assertThat(SDKType.visionOS.value(simulator: true), equalTo("visionOS Simulator"))
	}

	@Test func genericDestination() {
		assertThat(SDKType.iOS.genericDestination.value, equalTo("generic/platform=iOS"))
		assertThat(SDKType.macOS.genericDestination.value, equalTo("platform=macOS"))
		assertThat(SDKType.watchOS.genericDestination.value, equalTo("generic/platform=watchOS"))
		assertThat(SDKType.tvOS.genericDestination.value, equalTo("generic/platform=tvOS"))
		assertThat(SDKType.visionOS.genericDestination.value, equalTo("generic/platform=visionOS"))



	}
}
