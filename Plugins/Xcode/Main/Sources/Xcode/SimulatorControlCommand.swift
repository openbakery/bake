//
// Created by René Pirringer on 6.1.2026
//

import ArgumentParser

struct SimulatorControlCommand: AsyncParsableCommand {
	static let configuration = CommandConfiguration(
		commandName: "simulatorControl",
		abstract: "SimulatorControl commands.",
		subcommands: [SimulatorControlCommandList.self],
		aliases: ["simctl"]
	)

}


struct SimulatorControlCommandList: AsyncParsableCommand {
	static let configuration = CommandConfiguration(
		commandName: "list",
		abstract: "Lists the available simulators."
	)

	mutating func run() async throws {
		try await SimulatorControl().list()
	}
}
