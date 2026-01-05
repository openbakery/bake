//
// Created by René Pirringer on 5.1.2026
//
import ArgumentParser

public let commands: [AsyncParsableCommand.Type] = [HelloWorldCommand.self]


struct HelloWorldCommand: AsyncParsableCommand {
	static let configuration = CommandConfiguration(abstract: "Prints 'Hello World!'")

	mutating func run() async throws {
		print("Hello World!")
	}
}
