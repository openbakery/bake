//
// Created by René Pirringer on 30.11.2025
//
import Testing

@testable import Bake

extension StringOutputHandler {
	func waitForLines() async -> [String] {
		if self.lines.count > 0 {
			return self.lines
		}
		await confirmation("has lines") { confirm in
			if self.lines.count > 0 {
				confirm()
			}
		}
		return self.lines
	}
}
