
import XCTest

enum TestError: Error {
	case failed(message: String)
}

public extension XCTestCase {

	@discardableResult
	func unwrap<T>(_ optional: T?, file: StaticString = #filePath, line: UInt = #line) throws -> T {
		if let optional = optional {
			return optional
		}
		XCTFail("Cannot unwrap given optional because it is nil", file: file, line: line)
		throw TestError.failed(message: "Cannot unwrap given optional because it is nil")
	}

	func fail(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
		XCTFail(message, file: file, line: line)
	}


}
