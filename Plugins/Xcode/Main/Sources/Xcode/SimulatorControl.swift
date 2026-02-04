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

	open func list() async throws {
		try await loadSimulators()

		Log.debug("print simulators")

		self.simulators?.runtimes.forEach { runtime in
			Log.debug("runtime \(runtime)")
			outputHandler.process(line: "\(runtime)")
			self.simulators?.devices(forRuntime: runtime)?.forEach { device in
				Log.debug("device \(device)")
				outputHandler.process(line: "  \(device)")
			}
		}

	}

	open func device(name: String? = nil, version: String? = nil, type: SDKType = .iOS) async throws -> Device? {
		try await loadSimulators()
		if let simulators {
			Log.debug("Find device by name: \(name ?? ""), version: \(version ?? "")  type \(type)")
			if let version {
				return simulators.device(name: name, version: Version(string: version), type: type)
			}
			return simulators.device(name: name, type: type)
		}
		return nil

	}

	open func destination(name: String? = nil, version: String? = nil, type: SDKType = .iOS) async throws -> Destination? {
		guard let device = try await self.device(name: name, version: version, type: type) else {
			return nil
		}
		return simulators?.destination(device: device)
	}

	open func deviceType(name: String) async throws -> DeviceType? {
		try await loadSimulators()
		return simulators?.deviceType(name: name)
	}

	open func create(deviceType: DeviceType) async throws {
		guard let runtime = simulators?.runtime() else { return }
		try await commandRunner.run("/usr/bin/xcrun", "simctl", "create", deviceType.name, deviceType.identifier, runtime.identifier)
	}

}
