//
// Created by René Pirringer on 3.2.2026
//

public struct MessageOutput: Executable {

	public init(message: String, outputHandler: OutputHandler = PrintOutputHandler()) {
		self.message = message
		self.outputHandler = outputHandler
	}

	let message: String
	let outputHandler: OutputHandler

	public func execute() async throws {
		outputHandler.process(line: message)
	}
}

extension Job where T == MessageOutput {

	public static func message(name: String, message: String, outputHandler: OutputHandler = PrintOutputHandler()) -> Job {
		return Job(
			name: name,
			executable: MessageOutput(message: message, outputHandler: outputHandler))
	}

}
