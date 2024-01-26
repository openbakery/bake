
import XCTest
@testable import BakeCLI

class BakeCLI_Test: XCTestCase {


	func test_cli() {
		let bake = BakeCLI()
		XCTAssertNotNil(bake)
	}

}
