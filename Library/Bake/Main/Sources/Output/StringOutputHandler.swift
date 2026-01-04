//
// Created by René Pirringer on 29.10.2025
//


public class StringOutputHandler: OutputHandler, @unchecked Sendable {

	public init() {
		lines = []
	}

	public var lines: [String]


	public func process(line: String) {
		self.lines.append(line)
	}


}
