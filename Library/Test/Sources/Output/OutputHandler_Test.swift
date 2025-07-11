//
// Created by René Pirringer
//


import Foundation
import Hamcrest
import Testing

@testable import Bake

class OutputHandler_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}

	func test_instance() {
		let handler = OutputHandler()

		// then
		assertThat(handler, present())
	}

	func test_has_not_data() throws {
		let handler = OutputHandler()

		// then
		assertThat(handler.hasData, presentAnd(equalTo(false)))
	}


	func test_handle_data_instance() throws {
		let handler = OutputHandler()

		// when
		let data = try #require(Data("Hello".utf8))
		handler.handle(data: data)

		// then
		assertThat(handler.hasData, presentAnd(equalTo(true)))
	}

}
