//
import Foundation

public class Command: Target, CustomStringConvertible {

	public convenience init(name: String, command: String, arguments: String..., workingDirectory: URL? = nil) {
		self.init(name: name, command: command, arguments: arguments, workingDirectory: workingDirectory)
	}

	public convenience init(command: String, arguments: String..., workingDirectory: URL? = nil) {
		self.init(name: command, command: command, arguments: arguments, workingDirectory: workingDirectory)
	}

	public convenience init(command: String, arguments: [String], workingDirectory: URL? = nil) {
		self.init(name: command, command: command, arguments: arguments, workingDirectory: workingDirectory)
	}

	public required init(name: String, command: String, arguments: [String], workingDirectory: URL? = nil) {
		self.name = name
		self.command = command
		self.arguments = arguments
		self.workingDirectory = workingDirectory
	}

	public required init(from decoder: Decoder) throws {
		fatalError("not implemented")
	}
	
	deinit {
		if let token { NotificationCenter.default.removeObserver(token) }
	}

	public let name: String
	public let command: String
	public let arguments: [String]
	public let workingDirectory: URL?
	private var token: Any?


	public enum CommandError: Error {
		case failedExecution(terminationStatus: Int32)
	}

	actor DataBuffer {
		private var buffer: Data
		private let outputHandler: OutputHandler
		
		init(outputHandler: OutputHandler) {
			self.outputHandler = outputHandler
			self.buffer = Data()
		}

			func append(_ data: Data) {
					buffer.append(data)
					if let string = String(data: buffer, encoding: .utf8), string.last?.isNewline == true {
							buffer.removeAll()
							for line in string.split(separator: "\n") {
								outputHandler.process(line: String(line))
							}
					}
			}
	}


	@MainActor
	func execute(process: Process, environment: [String: String]? = nil, outputHandler: OutputHandler = PrintOutputHandler()) async throws {
		let standardOutput = Pipe()
		let standardError = Pipe()
		
		let standardOutputBuffer = DataBuffer(outputHandler: outputHandler)

		process.executableURL = self.executableURL
		process.arguments = processArguments
		process.standardOutput = standardOutput
		process.standardError = standardError
		process.currentDirectoryURL = self.workingDirectory
		if let environment {
			var result = ProcessInfo.processInfo.environment
			result.merge(environment) { $1 }
			process.environment = result
		}


		Log.debug("\(name) \(arguments.joined(separator: " "))")

		token = NotificationCenter.default.addObserver(forName: .NSFileHandleDataAvailable, object: nil, queue: OperationQueue.main) { note in
			guard let handle = note.object as? FileHandle else { return }
			guard handle === standardOutput.fileHandleForReading || handle == standardError.fileHandleForReading else { return }
			defer { handle.waitForDataInBackgroundAndNotify() }
		
			Task {
				await standardOutputBuffer.append(handle.availableData)
			}
		}


		standardOutput.fileHandleForReading.waitForDataInBackgroundAndNotify()
		standardError.fileHandleForReading.waitForDataInBackgroundAndNotify()
		
		try process.run()
		process.waitUntilExit()

		// read the rest of the stream
		await standardOutputBuffer.append(standardOutput.fileHandleForReading.availableData)


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
	
	func process(data: Data) {
		if !data.isEmpty {
			if let string =  String(data: data, encoding: .utf8) {
				for line in string.split(separator: "\n") {
					self.process(line: String(line))
				}
			}
		}
	}

}

