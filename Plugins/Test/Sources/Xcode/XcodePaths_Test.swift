//
// Created by René Pirringer on 11.7.2025
//

import Bake
import BakeTestHelper
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import Testing

@testable import BakePlugins

struct XcodePaths_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}

	@Test func default_base_is_current_directory() {
		// when
		let path = XcodePath()

		// then
		let expectedUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
		assertThat(path.baseUrl, presentAnd(equalTo(expectedUrl)))
	}


}
