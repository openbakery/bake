

public struct Command: Target {

	public let name: String
	public let command: String
	public let arguments: [String]

	public init(name: String, command: String, arguments: String...) {
		self.init(name: name, command: command, arguments: arguments)
	}

	public init(name: String, command: String, arguments: [String]) {
		self.name = name
		self.command = command
		self.arguments = arguments
	}
}
