//
import Foundation

public class Command: Target, CustomStringConvertible {

	public convenience init(name: String, command: String, arguments: String..., outputHandler: OutputHandler = PrintOutputHandler()) {
		self.init(name: name, command: command, arguments: arguments, outputHandler: outputHandler)
	}

	public convenience init(command: String, arguments: String..., outputHandler: OutputHandler = PrintOutputHandler()) {
		self.init(name: command, command: command, arguments: arguments, outputHandler: outputHandler)
	}

	public convenience init(command: String, arguments: [String], outputHandler: OutputHandler = PrintOutputHandler()) {
		self.init(name: command, command: command, arguments: arguments, outputHandler: outputHandler)
	}

	public required init(name: String, command: String, arguments: [String], outputHandler: OutputHandler = PrintOutputHandler()) {
		self.name = name
		self.command = command
		self.arguments = arguments
		self.outputHandler = outputHandler
	}

	public required init(from decoder: Decoder) throws {
		fatalError("not implemented")
	}

	public let name: String
	public let command: String
	public let arguments: [String]
	let standardOutput = Pipe()
	let standardError = Pipe()
	public let outputHandler: OutputHandler


	public enum CommandError: Error {
		case failedExecution(terminationStatus: Int32)
	}


	func execute(process: Process = Process()) throws {
		process.executableURL = self.executableURL
		process.arguments = processArguments
		process.standardOutput = standardOutput
		process.standardError = standardError

		try process.run()

		Task {
			for try await line in standardOutput.fileHandleForReading.bytes.lines {
				if Task.isCancelled { break }
				outputHandler.process(line: line)
			}
		}

		Task {
			for try await line in standardError.fileHandleForReading.bytes.lines {
				if Task.isCancelled { break }
				outputHandler.process(line: line)
			}
		}

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
