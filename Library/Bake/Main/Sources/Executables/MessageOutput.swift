//
// Created by René Pirringer on 3.2.2026
//

struct MessageOutput: Executable {

	public init(message: String, outputHandler: OutputHandler = PrintOutputHandler()) {
		self.message = message
		self.outputHandler = outputHandler
	}

	let message: String
	let outputHandler: OutputHandler

	func execute() async throws {
		outputHandler.process(line: message)
	}
}
