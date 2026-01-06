//
// Created by René Pirringer on 6.1.2026
//

import ArgumentParser
import Bake

struct Options: ParsableArguments {
	@Flag(
		name: [.customLong("debug"), .customShort("d")],
		help: "Enable debug output.")
	var debug = false

}


extension AsyncParsableCommand {

	func apply(options: Options) {
		let debug = options.debug
		Task { @MainActor in
			if debug {
				Log.level = .debug
			}
		}
	}
}


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

	@OptionGroup var options: Options

	mutating func run() async throws {
		self.apply(options: options)
		try await SimulatorControl().list()
	}
}
