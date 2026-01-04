//
// Created by René Pirringer on 22.12.2025
//
import ArgumentParser

public let commands: [AsyncParsableCommand.Type] = [SimulatorControlCommand.self]


struct SimulatorControlCommand: AsyncParsableCommand {
	static let configuration = CommandConfiguration(abstract: "SimulatorControl commands.")

	mutating func run() async throws {
		print("SimulatorControl...")
	}
}
