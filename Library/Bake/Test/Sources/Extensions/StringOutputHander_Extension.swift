import BakeTestHelper
//
// Created by René Pirringer on 30.11.2025
//
import Testing

@testable import Bake

extension StringOutputHandler {
	func waitForLines(file: StaticString = #filePath, line: UInt = #line) async -> [String] {
		if self.lines.count > 0 {
			return self.lines
		}
		let location = Testing.SourceLocation(fileID: "Bake/\(file)", filePath: "\(file)", line: Int(line), column: Int(1))



		await confirmation("has lines", sourceLocation: location) { confirm in

			await wait(source: self) { handler in
				handler.lines.count > 0
			}

			if self.lines.count > 0 {
				confirm()
			}
		}
		return self.lines
	}
}
