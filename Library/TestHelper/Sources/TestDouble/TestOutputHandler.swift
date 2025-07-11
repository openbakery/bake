//
// Created by René Pirringer on 11.7.2025
//

import Bake

open class TestOutputHandler: OutputHandler {

	public init() {
	}

	public typealias LineClosure = (String) -> Void

	public var closure: LineClosure?

	public var lines = [String]()

	open func process(line: String) {
		lines.append(line)
		closure?(line)
	}

}
