//
import Foundation

public class Command: Target, CustomStringConvertible {

	public convenience init(name: String, command: String, arguments: String...) {
		self.init(name: name, command: command, arguments: arguments)
	}

	public convenience init(command: String, arguments: String...) {
		self.init(name: command, command: command, arguments: arguments)
	}

	public convenience init(command: String, arguments: [String]) {
		self.init(name: command, command: command, arguments: arguments)
	}

	public required init(name: String, command: String, arguments: [String]) {
		self.name = name
		self.command = command
		self.arguments = arguments
	}

	public required init(from decoder: Decoder) throws {
		fatalError("not implemented")
	}

	public let name: String
	public let command: String
	public let arguments: [String]
	private var token: Any?


	public enum CommandError: Error {
		case failedExecution(terminationStatus: Int32)
	}


	@MainActor
	func execute(process: Process, environment: [String: String]? = nil, outputHandler: OutputHandler = PrintOutputHandler()) throws {
		let standardOutput = Pipe()
		let standardError = Pipe()

		process.executableURL = self.executableURL
		process.arguments = processArguments
		process.standardOutput = standardOutput
		process.standardError = standardError
		if let environment {
			process.environment = environment
		}

		try process.run()

		token = NotificationCenter.default.addObserver(forName: .NSFileHandleDataAvailable, object: nil, queue: OperationQueue.main) { note in
			guard let handle = note.object as? FileHandle else { return }
			guard handle === standardOutput.fileHandleForReading || handle == standardError.fileHandleForReading else { return }
			defer { handle.waitForDataInBackgroundAndNotify() }
			let data = handle.availableData
			if let string = String(data: data, encoding: .utf8) {
				Task {
					for line in string.split(separator: "\n") {
						outputHandler.process(line: String(line))
					}
				}
			}
		}

		standardOutput.fileHandleForReading.waitForDataInBackgroundAndNotify()
		standardError.fileHandleForReading.waitForDataInBackgroundAndNotify()

		// for try await line in standardOutput.fileHandleForReading.bytes.lines {
		// 	if Task.isCancelled { break }
		// 	processLine(line)
		// }

		// for try await line in standardError.fileHandleForReading.bytes.lines {
		// 	if Task.isCancelled { break }
		// 	processLine(line)
		// }

		process.waitUntilExit()


		if process.terminationStatus != 0 {
			throw CommandError.failedExecution(terminationStatus: process.terminationStatus)
		}
	}



	private var executableURL: URL {
		if isBashCommand {
			return URL(fileURLWithPath: "/bin/bash")
		}

		return URL(fileURLWithPath: command)
	}

	private var processArguments: [String]? {
		if isBashCommand {
			return ["-c", command] + arguments
		}
		return self.arguments

	}

	private var isBashCommand: Bool {
		let bashCommands = [
			"alias", "bg", "bind", "break", "builtin", "caller", "case", "cd", "command", "compgen", "complete", "compopt", "continue", "coproc",
			"declare", "dirs", "disown", "echo", "enable", "eval", "exec", "exit", "export", "false", "fc", "fg", "getopts", "hash", "help", "history",
			"jobs", "kill", "local", "logout", "mapfile", "popd", "printf", "pushd", "pwd", "read", "readarray", "readonly", "return", "select", "set",
			"shift", "shopt", "source", "suspend", "test", "time", "times", "trap", "true", "type", "typeset", "ulimit", "umask", "unalias", "unset",
			"variables", "wait", "which"
		]

		return bashCommands.contains(command)
	}

	public var description: String {
		"Command: \"\(name)\""
	}

}

extension OutputHandler {

	func process(handler: FileHandle) {
	}
}
