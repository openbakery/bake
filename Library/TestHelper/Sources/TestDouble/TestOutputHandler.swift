//
// Created by René Pirringer on 11.7.2025
//

import Bake
import Foundation

@MainActor
public class TestOutputHandler: OutputHandler {

	public init() {
	}

	public typealias LineClosure = (String) -> Void

	public var closure: LineClosure?

	public var lines = [String]()

	public func process(line: String) {
		lines.append(line)
		closure?(line)
	}

	public func getLines() -> [String] {
		return lines
	}


}
