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
		//
		// assertThat(contents, nilValue())
		assertThat(contents, presentAnd(hasPrefix("== Device Types ==")))
		// #expect(contents.hasPrefix("foo"))
		// 	return result
		// }
		// let path = self.path(forDocument: document)
		// return URL(fileURLWithPath: path)
	}



}
