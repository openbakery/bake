//
import Foundation

public class Command: Target {

	public let name: String
	public let command: String
	public let arguments: [String]
	let standardOutput = Pipe()

	public convenience init(name: String, command: String, arguments: String...) {
		self.init(name: name, command: command, arguments: arguments)
	}


	public required init(name: String, command: String, arguments: [String]) {
		self.name = name
		self.command = command
		self.arguments = arguments
	}

	public required init(from decoder: Decoder) throws {
		fatalError("not implemented")
	}

	public func execute() throws {
		try execute(process: Process())
	}

	func execute(process: Process) throws {
		process.executableURL = self.executableURL
		process.arguments = processArguments
		let standardError = Pipe()
		process.standardOutput = standardOutput
		process.standardError = standardError
		try process.run()
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
		let bashCommands = ["alias", "bg", "bind", "break", "builtin", "caller", "case", "cd", "command", "compgen", "complete", "compopt", "continue", "coproc",
				"declare", "dirs", "disown", "echo", "enable", "eval", "exec", "exit", "export", "false", "fc", "fg", "getopts", "hash", "help", "history",
				"jobs", "kill", "local", "logout", "mapfile", "popd", "printf", "pushd", "pwd", "read", "readarray", "readonly", "return", "select", "set",
				"shift", "shopt", "source", "suspend", "test", "time", "times", "trap", "true", "type", "typeset", "ulimit", "umask", "unalias", "unset",
				"variables", "wait", "which"]

		return bashCommands.contains(command)
	}


}
