//
// Created by René Pirringer on 22.12.2025
//
import ArgumentParser

public struct Commands {

	@MainActor
	static var commands: [ParsableCommand.Type] = [SimulatorControlCommand.self]

}

struct SimulatorControlCommand: ParsableCommand {
	static let configuration = CommandConfiguration(abstract: "SimulatorControl commands.")

	mutating func run() {
		print("SimulatorControl...")
	}
}
