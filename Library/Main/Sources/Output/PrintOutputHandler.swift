//
// Created by René Pirringer on 11.7.2025
//


struct PrintOutputHandler: OutputHandler, Sendable {

	public init() {
	}

	func process(line: String) {
		print(line)
	}

}
