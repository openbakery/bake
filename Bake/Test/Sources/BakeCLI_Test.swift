
import XCTest
import SwiftHamcrest
@testable import BakeCLI

class BakeCLI_Test: XCTestCase {


	func test_cli() {
		// when
		let bake = BakeCLI()

		// then
		XCTAssertNotNil(bake)
		assertThat(bake, present())
}

	func test_has_logger() {
		// when
		let bake = BakeCLI()

		// then
		assertThat(bake.logger, presentAnd(instanceOf(Logger.self)))
	}

	func test_print_usage_when_run_without_parameters() {
		// when
		let logger = LoggerFake()
		let bake = BakeCLI(logger: logger)

	}

}
