//
// Created by René Pirringer on 12.12.2025
//

import Bake
import Foundation

open class SimulatorControl: Target {

	public init(commandRunner: CommandRunner = CommandRunner(), outputHandler: OutputHandler = PrintOutputHandler()) {
		self.commandRunner = commandRunner
		self.outputHandler = outputHandler
	}

	public required init(from decoder: Decoder) throws {
		fatalError("not implemented")
	}

	public let name = "SimulatorControl"
	let commandRunner: CommandRunner
	let outputHandler: OutputHandler
	var simulators: Simulators?


	public func loadSimulators() async throws {
		if self.simulators == nil {
			let result = try await commandRunner.runWithResult("/usr/bin/xcrun", "simctl", "list", "--json")
			let parser = SimulatorControlParser()
			self.simulators = parser.parseListJson(result.joined(separator: "\n"))
		}
	}

	public func list() async throws {
		try await loadSimulators()

		outputHandler.process(line: "foo")
		outputHandler.process(line: "bar")

	}

	public func device(name: String? = nil, version: String? = nil, type: SDKType = .iOS) async throws -> Device? {
		try await loadSimulators()
		if let simulators {
			if let version {
				return simulators.device(name: name, version: Version(string: version), type: type)
			}
			return simulators.device(name: name, type: type)
		}
		return nil

	}


}
