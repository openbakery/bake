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
		assertThat(SDKType.iOS.value, equalTo("iOS"))
		assertThat(SDKType.macOS.value, equalTo("macOS"))
		assertThat(SDKType.tvOS.value, equalTo("tvOS"))
		assertThat(SDKType.watchOS.value, equalTo("watchOS"))
		assertThat(SDKType.visionOS.value, equalTo("visionOS"))

	}
}
