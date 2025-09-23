//
// Created by René Pirringer on 11.7.2025
//


public actor PrintOutputHandler: OutputHandler {

	public init() {
	}

	nonisolated public func process(line: String) {
		print("... \(line)")
	}

}
