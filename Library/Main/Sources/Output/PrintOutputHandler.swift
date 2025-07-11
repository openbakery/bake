//
// Created by René Pirringer on 11.7.2025
//


open class PrintOutputHandler: OutputHandler {

	public init() {
	}

	open func process(line: String) {
		print(line)
	}

}
